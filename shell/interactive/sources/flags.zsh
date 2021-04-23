########################################
# CPP and LDF Flags & PKG_CONFIG_PATH
########################################

## openssl
#export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@1.1/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@1.1/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig"

## readline
#export LDFLAGS="-L${BREW_PREFIX}/opt/readline/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/readline/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/readline/lib/pkgconfig"

## sqlite
#export LDFLAGS="-L${BREW_PREFIX}/opt/sqlite/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/sqlite/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/sqlite/lib/pkgconfig"

## llvm
#export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/llvm/include"

## zlib
#export LDFLAGS="-L${BREW_PREFIX}/opt/llvm/lib -Wl,-rpath,${BREW_PREFIX}/opt/llvm/lib"
#export LDFLAGS="-L${BREW_PREFIX}/opt/zlib/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/zlib/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/zlib/lib/pkgconfig"

## ruby
#export LDFLAGS="-L${BREW_PREFIX}/opt/ruby/lib"
#export CPPFLAGS="-I${BREW_PREFIX}/opt/ruby/include"
#export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/ruby/lib/pkgconfig"


# # MERGED
export LDFLAGS="-L${BREW_PREFIX}/opt/openssl@1.1/lib -L${BREW_PREFIX}/opt/readline/lib -L${BREW_PREFIX}/opt/sqlite/lib -L${BREW_PREFIX}/opt/llvm/lib -L${BREW_PREFIX}/opt/zlib/lib -L${BREW_PREFIX}/opt/ruby/lib"
export CPPFLAGS="-I${BREW_PREFIX}/opt/openssl@1.1/include -I${BREW_PREFIX}/opt/readline/include -I${BREW_PREFIX}/opt/sqlite/include -I${BREW_PREFIX}/opt/llvm/include -I${BREW_PREFIX}/opt/zlib/include -I${BREW_PREFIX}/opt/ruby/include"
export PKG_CONFIG_PATH="${BREW_PREFIX}/opt/openssl@1.1/lib/pkgconfig:${BREW_PREFIX}/opt/readline/lib/pkgconfig:${BREW_PREFIX}/opt/sqlite/lib/pkgconfig:${BREW_PREFIX}/opt/zlib/lib/pkgconfig:${BREW_PREFIX}/opt/ruby/lib/pkgconfig"
