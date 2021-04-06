defmodule EctoClass.Profiles.Users do
  @moduledoc """
  Domain module for handling user database transactions.
  """

  alias EctoClass.Credentials.Schemas.Password
  alias EctoClass.Profiles.Schemas.User
  alias EctoClass.Repo

  import Ecto.Query

  def create(params) when is_map(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  def update(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete(%User{} = user), do: Repo.delete(user)

  def all(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.all()
  end

  def one(filters) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.one()
  end

  def exists?(filters) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.exists?()
  end

  def legal_name_strats_with(legal_name) when is_binary(legal_name) do
    User
    |> where([u], like(u.legal_name, ^"#{legal_name}%"))
    |> Repo.all()
  end

  @doc "Returns how many users are found with the given filters"
  @spec count(filters :: keyword()) :: integer()
  def count(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.aggregate(:count)
  end

  @doc "Returns the users ordered by the given fields"
  @spec sort(filters :: keyword(), sort_by :: keyword()) :: list(User.t())
  def sort(filters \\ [], sort_by \\ [desc: :inserted_at])
      when is_list(filters) and is_list(sort_by) do
    User
    |> where(^filters)
    |> order_by(^sort_by)
    |> Repo.all()
  end

  def join(filters \\ []) do
    User
    |> join(:inner, [u], p in Password, on: u.id == p.user_id)
    |> where(^filters)
    |> select([u, p], %{u | password_credential: p})
    |> Repo.all()
  end

  def preload([%User{} | _] = users) do
    Repo.preload(users, [:password_credential])
  end
end
