defmodule EctoClass.Profiles.Users do
  @moduledoc """
  Domain module for handling user database transactions.
  """

  alias EctoClass.Profiles.Schemas.{Password, User}
  alias EctoClass.Repo

  import Ecto.Query

  @typedoc "Default Repo write transactions responses"
  @type default_response :: {:ok, User.t() | Ecto.Changeset.t()}

  @doc "Creates a new user"
  @spec create(params :: map()) :: default_response()
  def create(params) when is_map(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  @doc "Updates the given user with the params passed"
  @spec update(user :: User.t(), params :: map(), opts :: keyword()) :: default_response()
  def update(%User{} = user, params, opts \\ []) when is_map(params) and is_list(opts) do
    user
    |> User.changeset(params)
    |> Repo.update(opts)
  end

  @doc "Deletes the given user"
  @spec delete(user :: User.t()) :: {:ok, User.t()}
  def delete(%User{} = user), do: Repo.delete(user)

  ##########
  # Queries
  ##########

  @doc "Returns one user searching by the given filters"
  @spec get_by(filters :: keyword()) :: User.t() | nil
  def get_by(filters) when is_list(filters), do: Repo.get_by(User, filters)

  @doc "Return one user searching by it's id"
  @spec get(user_id :: Ecto.UUID.t()) :: User.t() | nil
  def get(user_id) when is_binary(user_id), do: Repo.get(User, user_id)

  @doc "Returns true of false when an user is found with the given filters"
  @spec exists?(filters :: keyword()) :: boolean()
  def exists?(filters) when is_list(filters), do: Repo.exists?(User, filters)

  @doc "Returns all users that matches the given filters"
  @spec all(filters :: keyword()) :: list(User.t())
  def all(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.all()
  end

  @doc "Returns all users that matches the given document"
  @spec all_by_document(documents :: list(String.t())) :: list(User.t())
  def all_by_document(documents) when is_list(documents) do
    User
    |> where([u], u.document in ^documents)
    |> Repo.all()
  end

  @doc "Returns all users that matches the starts with the given part of the name"
  @spec legal_name_starts_with(name_slice :: String.t()) :: list(User.t())
  def legal_name_starts_with(name_slice) when is_binary(name_slice) do
    User
    |> where([u], like(u.legal_name, ^"#{name_slice}%"))
    |> Repo.all()
  end

  @doc "Returns all users that matches the ends with the given part of the name"
  @spec legal_name_ends_with(name_slice :: String.t()) :: list(User.t())
  def legal_name_ends_with(name_slice) when is_binary(name_slice) do
    User
    |> where([u], like(u.legal_name, ^"%#{name_slice}"))
    |> Repo.all()
  end

  @doc "Returns all users that matches the contains the given part of the name"
  @spec legal_name_contains(name_slice :: String.t()) :: list(User.t())
  def legal_name_contains(name_slice) when is_binary(name_slice) do
    User
    |> where([u], like(u.legal_name, ^"%#{name_slice}%"))
    |> Repo.all()
  end

  @doc "Returns one user that matches the given filters"
  @spec one(filters :: keyword()) :: User.t() | nil
  def one(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.one()
  end

  @doc "Returns all users that has an password using subquery"
  @spec subquery() :: list(User.t())
  def subquery do
    sub =
      from(p in Password)
      |> select([p], p.user_id)

    from(u in User)
    |> where([u, p], u.id not in subquery(sub))
    |> Repo.all()
  end

  ##############
  # Preloads
  ##############

  @doc "Preloads the user relations into the structs"
  @spec preload(
          user :: User.t() | list(User.t()),
          fields :: list(atom())
        ) :: User.t() | list(User.t())
  def preload(%User{} = user, fields) when is_list(fields),
    do: Repo.preload(user, fields)

  def preload([%User{} | _] = users, fields) when is_list(fields),
    do: Repo.preload(users, fields)

  ################
  # Agreggations
  ###############

  @doc "Returns how many users are found with the given filters"
  @spec count(filters :: keyword()) :: integer()
  def count(filters \\ []) when is_list(filters) do
    User
    |> where(^filters)
    |> Repo.aggregate(:count)
  end

  @doc "Returns all users grouped by document"
  @spec group_by() :: list(User.t())
  def group_by do
    from(u in User)
    |> group_by([u], u.document)
    |> select([u], u.document)
    |> Repo.all()
  end

  @doc "Returns all users that has document duplicated"
  @spec having() :: list(User.t())
  def having do
    from(u in User)
    |> group_by([u], u.document)
    |> having([u], count(u.document) <= 1)
    |> select([u], u.document)
    |> Repo.all()
  end

  #######
  # Sort
  #######

  @doc "Returns the users ordered by the given fields"
  @spec sort(filters :: keyword(), sort_by :: keyword()) :: list(User.t())
  def sort(filters \\ [], sort_by \\ [desc: :inserted_at])
      when is_list(filters) and is_list(sort_by) do
    User
    |> where(^filters)
    |> order_by(^sort_by)
    |> Repo.all()
  end
end
