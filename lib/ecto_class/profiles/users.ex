defmodule EctoClass.Profiles.Users do
  @moduledoc """
  Domain module for handling user database transactions.
  """

  alias EctoClass.Profiles.Schemas.User
  alias EctoClass.Repo

  require Ecto.Query

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

  @doc "Returns one user searching by the given filters"
  @spec get_by(filters :: keyword()) :: User.t() | nil
  def get_by(filters, opts) when is_list(filters), do: Repo.get_by(User, filters)

  @doc "Return one user searching by it's id"
  @spec get(user_id :: Ecto.UUID.t()) :: User.t() | nil
  def get(user_id) when is_binary(user_id), do: Repo.get(User, user_id)

  @doc "Returns all users that matches the given filters"
  @spec list(filters :: keyword()) :: list(User.t())
  def list(filters \\ []) when is_list(filters) do
    User
    |> Ecto.Query.where(^filters)
    |> Repo.all()
  end
end
