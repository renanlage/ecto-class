defmodule EctoClass.Profiles.Schemas.Affiliation do
  @moduledoc """
  Database schema representation of affiliations table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Profiles.Schemas.{Organization, User}

  @typedoc "An ecto struct representation of affiliations table"
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          user: User.t() | Ecto.Association.NotLoaded.t(),
          user_id: Ecto.UUID.t(),
          organization: Organization.t() | Ecto.Association.NotLoaded.t(),
          organization_id: Ecto.UUID.t(),
          is_business_partner: boolean(),
          is_business_partner_checked_at: Datetime.t(),
          inserted_at: Datetime.t(),
          updated_at: Datetime.t()
        }

  # Fields used on casting and validations
  @optional_fields [:is_business_partner, :is_business_partner_checked_at]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "affiliations" do
    field :is_business_partner, :boolean, default: false
    field :is_business_partner_checked_at, :utc_datetime, default: DateTime.utc_now()

    # Relations
    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps()
  end

  @doc "Generates an `%Ecto.Changeset{}` to update the given model on database."
  @spec changeset(model :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = model, params)
      when is_map(params),
      do: cast(model, params, @optional_fields)
end
