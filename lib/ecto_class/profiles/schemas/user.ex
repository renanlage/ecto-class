defmodule EctoClass.Profiles.Schemas.User do
  @moduledoc """
  Database schema representation of users table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Credentials.Schemas.Password
  alias EctoClass.Profiles.Schemas.{Address, Organization, Affiliation}

  @required_fields [:username, :document, :legal_name]
  @optional_fields [:email_verified, :social_name, :document_type]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email_verified, :boolean, default: false
    field :social_name, :string
    field :legal_name, :string
    field :document, :string
    field :document_type, :string, default: "cpf"

    # Jsonb
    embeds_many :phones, Phones, on_replace: :delete do
      field :number, :string
      field :ddd, :string
      field :country_code, :string, default: "+55"
    end

    embeds_one :address, Address

    # Relations
    has_one :password_credential, Password, on_replace: :update, on_delete: :delete_all
    has_many :affiliations, Affiliation, foreign_key: :user_id, references: :id
    many_to_many :organizations, Organization, join_through: Affiliation

    timestamps()
  end

  def changeset(params) when is_map(params),
    do: do_changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = model, params) when is_map(params),
    do: do_changeset(model, params)

  defp do_changeset(%__MODULE__{} = model, params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:password_credential, required: false, with: &Password.changeset/2)
    |> cast_embed(:phones, with: &changeset_phones/2)
    |> cast_embed(:address, required: true)
    |> validate_required(@required_fields)
    |> validate_length(:legal_name, min: 2)
    |> validate_inclusion(:document_type, ["cpf", "rg"])
    |> unique_constraint(:username, name: :users_username_index)
  end

  defp changeset_phones(model, params) do
    model
    |> cast(params, [:number, :ddd, :country_code])
    |> validate_required([:number, :ddd])
  end
end
