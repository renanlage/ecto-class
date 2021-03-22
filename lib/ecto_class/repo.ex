defmodule EctoClass.Repo do
  use Ecto.Repo,
    otp_app: :ecto_class,
    adapter: Ecto.Adapters.Postgres
end
