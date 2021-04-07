defmodule EctoClass.Profiles.Users do
  @moduledoc """
  Domain module for handling user database transactions.
  """

  alias EctoClass.Credentials.Schemas.Password
  alias EctoClass.Profiles.Organizations
  alias EctoClass.Profiles.Schemas.{User, Organization}
  alias EctoClass.Repo
  alias Ecto.Multi

  import Ecto.Query

  require Logger

  def insert_everybody(user_params, org_params) do
    Repo.transact(fn ->
      Logger.info("Inserting everybody")

      with {:ok, org} <- Organizations.create(org_params),
           _ <- Logger.info("Organization was inserted"),
           {:ok, user} <- create(user_params) do
        Logger.info("Successfully inserted everybody")
        {:ok, {user, org}}
      end
    end)
  end

  def insert_everybody_multi(user_params, org_params) do
    Multi.new()
    |> Multi.insert(:insert_organization, Organization.changeset(org_params))
    |> Multi.run(:log, fn _repo, changes ->
      org = Map.get(changes, :insert_organization)
      Logger.info("Organization created with id = #{org.id}")
      {:ok, :ok}
    end)
    |> Multi.insert(:insert_user, User.changeset(user_params))
    |> Repo.transaction()
  end

  def create(params) when is_map(params) do
    Repo.insert_schema(User, params)
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

  def select_count(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.aggregate(:count)
  end

  def select_sort(filters \\ [], sort_by \\ [desc: :inserted_at])
      when is_list(filters) and is_list(sort_by) do
    User
    |> where(^filters)
    |> order_by(^sort_by)
    |> Repo.all()
  end

  def select_join(filters \\ []) do
    User
    |> join(:inner, [u], p in Password, on: u.id == p.user_id)
    |> where(^filters)
    |> select([u, p], %{u | password_credential: p})
    |> Repo.all()
  end

  def select_preload([%User{} | _] = users) do
    Repo.preload(users, [:password_credential])
  end

  def select_subquery do
    sub =
      from(p in Password)
      |> select([p], p.user_id)

    from(u in User)
    |> where([u, p], u.id not in subquery(sub))
    |> Repo.all()
  end

  def select_group_by do
    from(u in User)
    |> group_by([u], u.document)
    |> select([u], u.document)
    |> Repo.all()
  end

  def select_having do
    from(u in User)
    |> group_by([u], u.document)
    |> having([u], count(u.document) <= 1)
    |> select([u], u.document)
    |> Repo.all()
  end
end
