import Config

config :ecto_class,
  ecto_repos: [EctoClass.Repo]

config :ecto_class, EctoClass.Repo,
  database: "ecto_class",
  username: "ecto_class",
  password: "ecto_class",
  hostname: "localhost",
  port: 5432
