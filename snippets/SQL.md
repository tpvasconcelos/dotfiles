# SQL Snippets

#### Disable results caching for current session

```sql
set enable_result_cache_for_session to off;
```

#### Compare two queries

Use the following template to get the difference between two queries:

```sql
with q1 as (<insert_query_1_here>)
   , q2 as (<insert_query_2_here>)
select * from q1 except select * from q2
union all (
select * from q2 except select * from q1);
```

ref: <https://stackoverflow.com/questions/11017678/sql-server-compare-results-of-two-queries-that-should-be-identical/63380681#63380681>
