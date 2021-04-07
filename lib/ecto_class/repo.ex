defmodule EctoClass.Repo do
  use Ecto.Repo,
    otp_app: :ecto_class,
    adapter: Ecto.Adapters.Postgres

  def insert_schema(module, params) do
    params
    |> module.changeset()
    |> insert()
  end

  def transact(function) when is_function(function) do
    transaction(fn ->
      case function.() do
        {:ok, result} ->
          result

        {:error, reason} ->
          rollback(reason)
      end
    end)
  end
end
