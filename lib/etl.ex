defmodule Etl do
  def main(_argv) do
    {:ok, sql_server_pid} = Tds.Connection.start_link(
      hostname: "hostname",
      username: "username",
      password: "password",
      database: "database",
    )
    {:ok, sql_server_result} = Tds.Connection.query(
      sql_server_pid,
      "SELECT COUNT(*) FROM Job",
      []
    )

    {:ok, postgrex_pid} = Postgrex.start_link(
      hostname: "localhost",
      database: "database",
    )
    postgrex_result = Postgrex.query!(
      postgrex_pid,
      "SELECT COUNT(*) FROM categories",
      []
    )

    IO.puts("Jobs count: #{hd hd sql_server_result.rows}")
    IO.puts("Categories count: #{hd hd postgrex_result.rows}")
  end
end
