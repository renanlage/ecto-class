import Config

config :logger, level: :warn
config :ecto_class, EctoClass.Repo, pool: Ecto.Adapters.SQL.Sandbox
