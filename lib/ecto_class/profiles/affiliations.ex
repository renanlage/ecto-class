defmodule EctoClass.Profiles.Affiliations do
  @moduledoc """
  Domain module for handling affiliations database transactions.
  """

  alias EctoClass.Profiles.Schemas.{Affiliation, Organization, User}
  alias EctoClass.Repo

  import Ecto.Query

  @typedoc "Default Repo write transactions responses"
  @type default_response :: {:ok, Affiliation.t() | Ecto.Changeset.t()}

  @doc "Creates a new affiliations"
  @spec create(params :: map()) :: default_response()
  def create(params) when is_map(params) do
    params
    |> Affiliation.changeset()
    |> Repo.insert()
  end

  @doc "Updates the given affiliations with the params passed"
  @spec update(affiliations :: Affiliation.t(), params :: map(), opts :: keyword()) ::
          default_response()
  def update(%Affiliation{} = affiliations, params, opts \\ [])
      when is_map(params) and is_list(opts) do
    affiliations
    |> Affiliation.changeset(params)
    |> Repo.update(opts)
  end

  @doc "Deletes the given affiliation"
  @spec delete(affiliation :: Affiliation.t()) :: {:ok, Affiliation.t()}
  def delete(%Affiliation{} = affiliation), do: Repo.delete(affiliation)

  ##########
  # Queries
  ##########

  @doc "Returns one affiliations searching by the given filters"
  @spec get_by(filters :: keyword()) :: Affiliation.t() | nil
  def get_by(filters) when is_list(filters), do: Repo.get_by(Affiliation, filters)

  @doc "Returns true of false when an affiliation is found with the given filters"
  @spec exists?(filters :: keyword()) :: boolean()
  def exists?(filters) when is_list(filters), do: Repo.exists?(Affiliation, filters)

  @doc "Returns all affiliationss that matches the given filters"
  @spec all(filters :: keyword()) :: list(Affiliation.t())
  def all(filters \\ []) when is_list(filters) do
    Affiliation
    |> where(^filters)
    |> Repo.all()
  end

  @doc "Returns one affiliation that matches the given filters"
  @spec one(filters :: keyword()) :: Affiliation.t() | nil
  def one(filters \\ []) when is_list(filters) do
    Affiliation
    |> where(^filters)
    |> Repo.one()
  end

  ##############
  # Preloads
  ##############

  @doc "Preloads the affiliation relations into the structs"
  @spec preload(
          affiliation :: Affiliation.t() | list(Affiliation.t()),
          fields :: list(atom())
        ) :: Affiliation.t() | list(Affiliation.t())
  def preload(%Affiliation{} = affiliation, fields) when is_list(fields),
    do: Repo.preload(affiliation, fields)

  def preload([%Affiliation{} | _] = affiliations, fields) when is_list(fields),
    do: Repo.preload(affiliations, fields)

  ################
  # Agreggations
  ###############

  @doc "Returns how many affiliations are found with the given filters"
  @spec count(filters :: keyword()) :: integer()
  def count(filters \\ []) when is_list(filters) do
    Affiliation
    |> where(^filters)
    |> Repo.aggregate(:count)
  end

  #######
  # Sort
  #######

  @doc "Returns the affiliations ordered by the given fields"
  @spec sort(filters :: keyword(), sort_by :: keyword()) :: list(User.t())
  def sort(filters \\ [], sort_by \\ [desc: :inserted_at])
      when is_list(filters) and is_list(sort_by) do
    Affiliation
    |> where(^filters)
    |> order_by(^sort_by)
    |> Repo.all()
  end

  ########
  # Join
  ########

  def join_all do
    Affiliation
    |> join(:inner, [a], u in User, on: a.user_id == u.id)
    |> join(:inner, [a], o in Organization, on: a.organization_id == o.id)
    |> select([a, u, o], %{a | user: u, organization: o})
    |> Repo.all()
  end
end
