defmodule EctoClass.Profiles.Organizations do
  @moduledoc """
  Domain module for handling organization database transactions.
  """

  alias EctoClass.Profiles.Schemas.Organization
  alias EctoClass.Repo

  import Ecto.Query

  @typedoc "Default Repo write transactions responses"
  @type default_response :: {:ok, Organization.t() | Ecto.Changeset.t()}

  @doc "Creates a new organization"
  @spec create(params :: map()) :: default_response()
  def create(params) when is_map(params) do
    params
    |> Organization.changeset()
    |> Repo.insert()
  end

  @doc "Updates the given organization with the params passed"
  @spec update(organization :: Organization.t(), params :: map(), opts :: keyword()) ::
          default_response()
  def update(%Organization{} = organization, params, opts \\ [])
      when is_map(params) and is_list(opts) do
    organization
    |> Organization.changeset(params)
    |> Repo.update(opts)
  end

  @doc "Deletes the given organization"
  @spec delete(organization :: Organization.t()) :: {:ok, Organization.t()}
  def delete(%Organization{} = organization), do: Repo.delete(organization)

  ##########
  # Queries
  ##########

  @doc "Returns one organization searching by the given filters"
  @spec get_by(filters :: keyword()) :: Organization.t() | nil
  def get_by(filters) when is_list(filters), do: Repo.get_by(Organization, filters)

  @doc "Return one organization searching by it's id"
  @spec get(organization_id :: Ecto.UUID.t()) :: Organization.t() | nil
  def get(organization_id) when is_binary(organization_id),
    do: Repo.get(Organization, organization_id)

  @doc "Returns true of false when an affiliation is found with the given filters"
  @spec exists?(filters :: keyword()) :: boolean()
  def exists?(filters) when is_list(filters), do: Repo.exists?(Organization, filters)

  @doc "Returns all organizations that matches the given filters"
  @spec all(filters :: keyword()) :: list(Organization.t())
  def all(filters \\ []) when is_list(filters) do
    Organization
    |> where(^filters)
    |> Repo.all()
  end

  @doc "Returns one organization that matches the given filters"
  @spec one(filters :: keyword()) :: Organization.t() | nil
  def one(filters \\ []) when is_list(filters) do
    Organization
    |> where(^filters)
    |> Repo.one()
  end

  ##############
  # Preloads
  ##############

  @doc "Preloads the organization relations into the structs"
  @spec preload(
          organization :: Organization.t() | list(Organization.t()),
          fields :: list(atom())
        ) :: Organization.t() | list(Organization.t())
  def preload(%Organization{} = organization, fields) when is_list(fields),
    do: Repo.preload(organization, fields)

  def preload([%Organization{} | _] = organizations, fields) when is_list(fields),
    do: Repo.preload(organizations, fields)

  ################
  # Agreggations
  ###############

  @doc "Returns how many organizations are found with the given filters"
  @spec count(filters :: keyword()) :: integer()
  def count(filters \\ []) when is_list(filters) do
    Organization
    |> where(^filters)
    |> Repo.aggregate(:count)
  end

  #######
  # Sort
  #######

  @doc "Returns the organizations ordered by the given fields"
  @spec sort(filters :: keyword(), sort_by :: keyword()) :: list(User.t())
  def sort(filters \\ [], sort_by \\ [desc: :inserted_at])
      when is_list(filters) and is_list(sort_by) do
    Organization
    |> where(^filters)
    |> order_by(^sort_by)
    |> Repo.all()
  end
end
