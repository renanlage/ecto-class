defmodule EctoClass.Profiles.Affiliations do
  @moduledoc """
  Domain module for handling affiliations database transactions.
  """

  alias EctoClass.Profiles.Schemas.Affiliation
  alias EctoClass.Repo

  require Ecto.Query

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
  @spec update(affiliations :: Affiliation.t(), params :: map(), opts :: keyword()) :: default_response()
  def update(%Affiliation{} = affiliations, params, opts \\ []) when is_map(params) and is_list(opts) do
    affiliations
    |> Affiliation.changeset(params)
    |> Repo.update(opts)
  end

  @doc "Deletes the given affiliation"
  @spec delete(affiliation :: Affiliation.t()) :: {:ok, Affiliation.t()}
  def delete(%Affiliation{} = affiliation), do: Repo.delete(affiliation)

  @doc "Returns one affiliations searching by the given filters"
  @spec get_by(filters :: keyword()) :: Affiliation.t() | nil
  def get_by(filters, opts) when is_list(filters), do: Repo.get_by(Affiliation, filters)

  @doc "Return one affiliations searching by it's id"
  @spec get(affiliations_id :: Ecto.UUID.t()) :: Affiliation.t() | nil
  def get(affiliations_id) when is_binary(affiliations_id), do: Repo.get(Affiliation, affiliations_id)

  @doc "Returns all affiliationss that matches the given filters"
  @spec list(filters :: keyword()) :: list(Affiliation.t())
  def list(filters \\ []) when is_list(filters) do
    Affiliation
    |> Ecto.Query.where(^filters)
    |> Repo.all()
  end
end
