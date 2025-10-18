#!/usr/bin/env -S uv run --script
#
# /// script
# dependencies = [
#   "rich",
#   "aiohttp",
# ]
# ///

"""
Homebrew Quick Look Tools Analyzer
Searches for Quick Look tools in Homebrew and fetches GitHub statistics.
Performance optimized with async subprocess and reduced API calls.
"""

import asyncio
import aiohttp
from datetime import datetime
from typing import Optional, Dict, List, Tuple
import json
import argparse
from dataclasses import dataclass
import re
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn
from rich.table import Table
from rich.panel import Panel
from rich import box

console = Console()

@dataclass
class PackageInfo:
    """Data class for package information"""
    package: str
    github_url: str
    stars: int | str
    last_commit: str
    deprecated: bool

class BrewError(Exception):
    """Custom exception for Brew-related errors"""
    pass

class GitHubAPIError(Exception):
    """Custom exception for GitHub API errors"""
    pass

async def run_brew_command_async(args: List[str]) -> Optional[str]:
    """
    Run a brew command asynchronously and return its output.
    
    Args:
        args: List of command arguments including 'brew'
    
    Returns:
        Command output or None on error
    """
    try:
        process = await asyncio.create_subprocess_exec(
            *args,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        
        stdout, stderr = await asyncio.wait_for(
            process.communicate(),
            timeout=30
        )
        
        if process.returncode != 0:
            error_msg = stderr.decode() if stderr else "Unknown error"
            console.print(f"[yellow]Warning: brew command failed for {args[-1]}: {error_msg.strip()}[/yellow]")
            return None
        
        return stdout.decode()
    except asyncio.TimeoutError:
        console.print(f"[red]Error: Command timed out: {' '.join(args)}[/red]")
        return None
    except Exception as e:
        console.print(f"[red]Error running {' '.join(args)}: {e}[/red]")
        return None

def run_brew_command_sync(args: List[str]) -> Optional[str]:
    """
    Run a brew command synchronously (for initial search only).
    
    Args:
        args: List of command arguments including 'brew'
    
    Returns:
        Command output or None on error
    """
    import subprocess
    try:
        result = subprocess.run(
            args,
            capture_output=True,
            text=True,
            check=True,
            timeout=30
        )
        return result.stdout
    except subprocess.TimeoutExpired:
        console.print(f"[red]Error: Command timed out: {' '.join(args)}[/red]")
        return None
    except subprocess.CalledProcessError as e:
        console.print(f"[red]Error running {' '.join(args)}: {e}[/red]")
        if e.stderr:
            console.print(f"[red]stderr: {e.stderr}[/red]")
        return None

def parse_packages_from_search(output: str) -> List[str]:
    """
    Parse package names from brew search output.
    
    Args:
        output: Raw output from brew search command
    
    Returns:
        List of package names
    """
    packages = []
    for line in output.strip().split('\n'):
        # Skip empty lines and section headers
        if not line.strip() or line.startswith('='):
            continue
        # Extract package name (first word before any description)
        # Strip trailing colon (used by brew to denote casks)
        parts = line.split()
        if parts:
            package_name = parts[0].rstrip(':')
            packages.append(package_name)
    return packages

def extract_urls_from_brew_info(info_json: str) -> Tuple[Optional[str], Optional[str], bool]:
    """
    Extract GitHub URL, homepage, and deprecation status from brew info JSON output.
    
    Args:
        info_json: JSON string from brew info command
    
    Returns:
        Tuple of (github_url, homepage_url, deprecated)
    """
    try:
        data = json.loads(info_json)
        
        # Check formulae first, then casks
        items = data.get('formulae', []) + data.get('casks', [])
        
        github_url = None
        homepage_url = None
        deprecated = False
        
        for item in items:
            # Check deprecation status
            deprecated = item.get('deprecated', False) or item.get('disabled', False)
            # Also check for deprecation reason fields
            if item.get('deprecation_reason') or item.get('disable_reason'):
                deprecated = True
            
            # Get homepage
            homepage = item.get('homepage', '')
            if homepage:
                homepage_url = homepage.split('#')[0].rstrip('/')
            
            # Check if homepage is a GitHub URL
            if homepage and 'github.com' in homepage:
                github_url = homepage_url
            
            # Fallback to tap URL for GitHub
            if not github_url:
                tap = item.get('tap', '')
                if 'github.com' in tap:
                    github_url = f"https://github.com/{tap}".rstrip('/')
                
        return github_url, homepage_url, deprecated
    except json.JSONDecodeError as e:
        console.print(f"[yellow]Warning: Failed to parse brew info JSON: {e}[/yellow]")
        return None, None, False

def parse_github_url(url: str) -> Optional[Tuple[str, str]]:
    """
    Extract owner and repo from GitHub URL.
    
    Args:
        url: GitHub URL
    
    Returns:
        Tuple of (owner, repo) or None if invalid
    """
    # Match github.com/owner/repo pattern
    match = re.search(r'github\.com/([^/]+)/([^/\s#?]+)', url)
    if match:
        owner, repo = match.groups()
        # Remove .git suffix if present
        repo = repo.rstrip('.git')
        return owner, repo
    return None

async def fetch_github_stats(
    session: aiohttp.ClientSession,
    owner: str,
    repo: str
) -> Tuple[Optional[int], Optional[str]]:
    """
    Fetch stars and last commit date from GitHub API.
    Uses single API call with pushed_at field for better performance.
    
    Args:
        session: aiohttp client session
        owner: Repository owner
        repo: Repository name
    
    Returns:
        Tuple of (stars, last_commit_date)
    """
    api_url = f"https://api.github.com/repos/{owner}/{repo}"
    
    try:
        # Fetch repo info (includes pushed_at which is last push date)
        async with session.get(
            api_url,
            timeout=aiohttp.ClientTimeout(total=10)
        ) as response:
            if response.status == 404:
                console.print(f"[yellow]Repository not found: {owner}/{repo}[/yellow]")
                return None, None
            elif response.status == 403:
                # Check if it's rate limit
                remaining = response.headers.get('X-RateLimit-Remaining', '0')
                if remaining == '0':
                    console.print(f"[yellow]GitHub API rate limit exceeded[/yellow]")
                return None, None
            elif response.status != 200:
                console.print(f"[yellow]GitHub API error {response.status} for {owner}/{repo}[/yellow]")
                return None, None
            
            data = await response.json()
            stars = data.get('stargazers_count', 0)
            
            # Use pushed_at which represents the last push (more recent than last commit in default branch)
            pushed_at = data.get('pushed_at')
            if pushed_at:
                dt = datetime.fromisoformat(pushed_at.replace('Z', '+00:00'))
                last_commit = dt.strftime('%Y-%m-%d')
            else:
                last_commit = 'N/A'
            
            return stars, last_commit
            
    except asyncio.TimeoutError:
        console.print(f"[yellow]Timeout fetching GitHub info for {owner}/{repo}[/yellow]")
        return None, None
    except aiohttp.ClientError as e:
        console.print(f"[yellow]Network error for {owner}/{repo}: {e}[/yellow]")
        return None, None
    except Exception as e:
        console.print(f"[yellow]Unexpected error for {owner}/{repo}: {e}[/yellow]")
        return None, None

async def process_package(
    session: aiohttp.ClientSession,
    package: str,
    progress: Progress,
    task,
    semaphore: asyncio.Semaphore
) -> Optional[PackageInfo]:
    """
    Process a single package: get brew info and fetch GitHub stats.
    
    Args:
        session: aiohttp client session
        package: Package name
        progress: Rich progress bar
        task: Progress task ID
        semaphore: Semaphore to limit concurrent operations
    
    Returns:
        PackageInfo or None if processing failed
    """
    async with semaphore:
        progress.update(task, description=f"[cyan]Processing {package}...")
        
        # Get brew info (now async!)
        info_output = await run_brew_command_async(['brew', 'info', '--json=v2', package])
        if not info_output:
            progress.update(task, advance=1)
            return None
        
        # Extract GitHub URL, homepage, and deprecation status
        github_url, homepage_url, deprecated = extract_urls_from_brew_info(info_output)
        
        # If no GitHub URL found, use homepage as fallback
        if not github_url:
            progress.update(task, advance=1)
            return PackageInfo(
                package=package,
                github_url=homepage_url or 'Not found',
                stars='N/A',
                last_commit='N/A',
                deprecated=deprecated
            )
        
        # Parse GitHub URL
        parsed = parse_github_url(github_url)
        if not parsed:
            progress.update(task, advance=1)
            return PackageInfo(
                package=package,
                github_url=homepage_url or github_url,
                stars='N/A',
                last_commit='N/A',
                deprecated=deprecated
            )
        
        owner, repo = parsed
        
        # Fetch GitHub stats
        stars, last_commit = await fetch_github_stats(session, owner, repo)
        
        progress.update(task, advance=1)
        
        return PackageInfo(
            package=package,
            github_url=github_url,
            stars=stars if stars is not None else 'N/A',
            last_commit=last_commit or 'N/A',
            deprecated=deprecated
        )

async def fetch_all_packages(packages: List[str], max_concurrent: int = 15) -> List[PackageInfo]:
    """
    Fetch GitHub info for all packages concurrently with rate limiting.
    
    Args:
        packages: List of package names
        max_concurrent: Maximum number of concurrent operations
    
    Returns:
        List of PackageInfo objects
    """
    # Semaphore to limit concurrent operations
    semaphore = asyncio.Semaphore(max_concurrent)
    
    # Connector with connection pooling
    connector = aiohttp.TCPConnector(
        limit=20,  # Total connection pool size
        limit_per_host=10  # Connections per host
    )
    
    async with aiohttp.ClientSession(connector=connector) as session:
        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            TaskProgressColumn(),
            console=console
        ) as progress:
            task = progress.add_task(
                "[green]Fetching package info...",
                total=len(packages)
            )
            
            tasks = [
                process_package(session, package, progress, task, semaphore)
                for package in packages
            ]
            results = await asyncio.gather(*tasks, return_exceptions=True)
            
            # Filter out None values and exceptions
            return [
                r for r in results
                if isinstance(r, PackageInfo)
            ]

def display_results(results: List[PackageInfo]) -> None:
    """Display results in a rich formatted table."""
    if not results:
        console.print("[yellow]No results to display[/yellow]")
        return
    
    table = Table(
        title="Quick Look Tools from Homebrew",
        box=box.ROUNDED,
        show_header=True,
        header_style="bold magenta"
    )
    
    table.add_column("Package", style="cyan", no_wrap=True)
    table.add_column("Project URL", style="blue", overflow="fold")
    table.add_column("Stars", justify="right", style="yellow")
    table.add_column("Last Commit", style="green")
    table.add_column("Deprecated", justify="center", style="red")
    
    # Sort: non-deprecated first, then by stars (descending)
    sorted_results = sorted(
        results,
        key=lambda x: (
            x.deprecated,  # False (0) comes before True (1)
            -(x.stars if isinstance(x.stars, int) else -1)  # Negative for descending
        )
    )
    
    for result in sorted_results:
        github_display = (
            result.github_url
            if result.github_url != 'Not found'
            else '[dim]Not found[/dim]'
        )
        stars_display = (
            f"{result.stars:,}"
            if isinstance(result.stars, int)
            else '[dim]N/A[/dim]'
        )
        commit_display = (
            result.last_commit
            if result.last_commit != 'N/A'
            else '[dim]N/A[/dim]'
        )
        deprecated_display = (
            '[red]✗ Yes[/red]'
            if result.deprecated
            else '[green]✓ No[/green]'
        )
        
        table.add_row(
            result.package,
            github_display,
            stars_display,
            commit_display,
            deprecated_display
        )
    
    console.print("\n")
    console.print(table)

def export_markdown(results: List[PackageInfo]) -> None:
    """Export results as markdown table."""
    console.print("\n[bold cyan]Markdown Output:[/bold cyan]\n")
    
    print("| Package | Project URL | Stars | Last Commit | Deprecated |")
    print("|---------|-------------|-------|-------------|------------|")
    
    # Sort: non-deprecated first, then by stars (descending)
    sorted_results = sorted(
        results,
        key=lambda x: (
            x.deprecated,  # False (0) comes before True (1)
            -(x.stars if isinstance(x.stars, int) else -1)  # Negative for descending
        )
    )
    
    for result in sorted_results:
        github_link = (
            f"[Link]({result.github_url})"
            if result.github_url != 'Not found'
            else 'Not found'
        )
        stars = (
            f"{result.stars:,}"
            if isinstance(result.stars, int)
            else result.stars
        )
        deprecated = "Yes" if result.deprecated else "No"
        print(f"| {result.package} | {github_link} | {stars} | {result.last_commit} | {deprecated} |")

async def main() -> None:
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Analyze Homebrew Quick Look tools and fetch GitHub stats"
    )
    parser.add_argument(
        '--debug',
        type=int,
        nargs='?',
        const=3,
        default=None,
        metavar='N',
        help='Debug mode: limit processing to N packages (default: 3)'
    )
    parser.add_argument(
        '--markdown',
        action='store_true',
        help='Export markdown output without prompting'
    )
    parser.add_argument(
        '--query',
        type=str,
        default='Quick Look',
        help='Search query for brew packages (default: "Quick Look")'
    )
    parser.add_argument(
        '--max-concurrent',
        type=int,
        default=15,
        help='Maximum concurrent operations (default: 15)'
    )
    args = parser.parse_args()
    
    # Display header
    console.print(Panel.fit(
        f"[bold cyan]Homebrew Package Analyzer[/bold cyan]\n"
        f"Searching for packages matching: '{args.query}'",
        border_style="cyan"
    ))
    
    # Run brew search (only sync operation)
    with console.status("[bold green]Running brew search..."):
        search_output = run_brew_command_sync(['brew', 'search', '--desc', args.query])
    
    if not search_output:
        console.print("[red]No results found or error occurred.[/red]")
        return
    
    # Parse package names
    packages = parse_packages_from_search(search_output)
    
    if not packages:
        console.print("[red]No packages found matching the query.[/red]")
        return
    
    total_packages = len(packages)
    
    # Apply debug limit if specified
    if args.debug is not None:
        packages = packages[:args.debug]
        console.print(
            f"\n[yellow]⚠  DEBUG MODE:[/yellow] "
            f"Processing [bold]{len(packages)}[/bold] of {total_packages} packages"
        )
    else:
        console.print(
            f"\n[green]✓[/green] Found [bold]{total_packages}[/bold] packages"
        )
    
    # Fetch GitHub info
    results = await fetch_all_packages(packages, max_concurrent=args.max_concurrent)
    
    if not results:
        console.print("[red]No package information could be retrieved.[/red]")
        return
    
    # Display results
    display_results(results)
    
    # Export markdown
    if args.markdown or (
        console.is_interactive and
        console.input("\n[bold]Export markdown? (y/n): [/bold]").lower() == 'y'
    ):
        console.print()
        export_markdown(results)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        console.print("\n[yellow]Operation cancelled by user[/yellow]")
    except Exception as e:
        console.print(f"\n[red]Unexpected error: {e}[/red]")
        raise
