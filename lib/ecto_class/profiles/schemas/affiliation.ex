defmodule EctoClass.Profiles.Schemas.Affiliation do
  @moduledoc """
  Database schema representation of affiliations table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Profiles.Schemas.{Organization, User}

  @fields [:is_business_partner, :user, :organization]

  @primary_key false
  @foreign_key_type Ecto.UUID
  schema "affiliations" do
    field :is_business_partner, :boolean, default: false

    belongs_to :user, User, foreign_key: :user_id, references: :id, primary_key: true
    belongs_to :organization, Organization, primary_key: true

    timestamps()
  end

  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> cast(params, [:is_business_partner])
    |> cast_assoc(:user, required: true)
    |> cast_assoc(:organization, required: true)
    |> validate_required(@fields)
  end

  def pure_id_changeset(params) when is_map(params) do
    %__MODULE__{}
    |> cast(params, [:is_business_partner, :user_id, :organization_id])
    |> validate_required([:is_business_partner, :user_id, :organization_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:organization_id)
  end
end
