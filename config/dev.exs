use Mix.Config

config :etl, source_hostname: System.get_env("SOURCE_HOSTNAME")
config :etl, source_username: System.get_env("SOURCE_USERNAME")
config :etl, source_password: System.get_env("SOURCE_PASSWORD")
config :etl, source_database: System.get_env("SOURCE_DATABASE")
config :etl, destination_hostname: System.get_env("DESTINATION_HOSTNAME")
config :etl, destination_database: System.get_env("DESTINATION_DATABASE")
