:odbc.start()

{:ok, source_pid} = :odbc.connect(
  'DSN=TeamworkCopy;UID=<user-id>;PWD=<password>',
  []
)
{:ok, dest_pid} = :odbc.connect('DSN=TeamworkDev', [])

{ :selected, _, results } = IO.inspect :odbc.sql_query(
  source_pid,
  'select top 1 Id, Title from Job'
)
[{ id, title }] = results

IO.inspect :odbc.param_query(
  dest_pid,
  'insert into legacy_jobs (legacy_id, created_at, updated_at) values (?, now(), now())',
  [{:sql_integer, [1]}]
)
IO.inspect :odbc.sql_query(
  dest_pid,
  'select legacy_id, title from legacy_jobs limit 5'
)
