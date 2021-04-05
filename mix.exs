defmodule EctoClass.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_class,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EctoClass.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # This makes sure your factory and any other
  # modules in test/support are compiled when in the test environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Database deps
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},

      # Crypto libraries for exemple purposes
      # It's not necessary for the database
      {:argon2_elixir, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.2"},
      {:pbkdf2_elixir, "~> 1.2"},

      # Library for validating cpf and cpnj for
      # exemple purposes
      {:brcpfcnpj, "~> 0.2.1"},

      # Tools for code quality
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test}
    ]
  end

  defp aliases do
    [
      setup: [
        "ecto.create --quiet -r EctoClass.Repo",
        "ecto.migrate --quiet -r EctoClass.Repo"
      ],
      reset: [
        "ecto.drop --quiet -r EctoClass.Repo",
        "setup"
      ],
      test: [
        "ecto.create --quiet -r EctoClass.Repo",
        "ecto.migrate -r EctoClass.Repo",
        "test"
      ]
    ]
  end
end
