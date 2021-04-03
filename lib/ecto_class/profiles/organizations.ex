defmodule EctoClass.Profiles.Organizations do
  @moduledoc """
  Domain module for handling organization database transactions.
  """

  alias EctoClass.Profiles.Schemas.Organization
  alias EctoClass.Repo

  require Ecto.Query

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
  @spec update(organization :: Organization.t(), params :: map(), opts :: keyword()) :: default_response()
  def update(%Organization{} = organization, params, opts \\ []) when is_map(params) and is_list(opts) do
    organization
    |> Organization.changeset(params)
    |> Repo.update(opts)
  end

  @doc "Deletes the given organization"
  @spec delete(organization :: Organization.t()) :: {:ok, Organization.t()}
  def delete(%Organization{} = organization), do: Repo.delete(organization)

  @doc "Returns one organization searching by the given filters"
  @spec get_by(filters :: keyword()) :: Organization.t() | nil
  def get_by(filters) when is_list(filters), do: Repo.get_by(Organization, filters)

  @doc "Return one organization searching by it's id"
  @spec get(organization_id :: Ecto.UUID.t()) :: Organization.t() | nil
  def get(organization_id) when is_binary(organization_id),
    do: Repo.get(Organization, organization_id)

  @doc "Returns all organizations that matches the given filters"
  @spec list(filters :: keyword()) :: list(Organization.t())
  def list(filters \\ []) when is_list(filters) do
    Organization
    |> Ecto.Query.where(^filters)
    |> Repo.all()
  end
end
