defmodule EctoClass.Profiles.Schemas.User do
  @moduledoc """
  Database schema representation of users table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Credentials.Schemas.Password
  alias EctoClass.Profiles.Schemas.{Affiliation, Organization}

  @typedoc "An ecto struct representation of users table"
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          username: String.t(),
          email_verified: boolean(),
          social_name: String.t() | nil,
          legal_name: String.t(),
          document: String.t(),
          document_type: String.t(),
          password_credential: Password.t() | Ecto.Association.NotLoaded.t(),
          organizations: list(Organizatio.t()) | Ecto.Association.NotLoaded.t(),
          inserted_at: Datetime.t(),
          updated_at: Datetime.t()
        }

  # Fields used on casting and validations
  @acceptable_document_types ~w(cpf rg cnh)
  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
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

    # Relations
    has_one :password_credential, Password, on_replace: :update
    many_to_many :organizations, Organization, join_through: Affiliation

    timestamps()
  end

  @doc "Generates an `%Ecto.Changeset{}` to insert new registers on database."
  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:password_credential, with: &Password.changeset/2)
    |> validate_required(@required_fields)
    |> validate_length(:legal_name, min: 2)
    |> validate_inclusion(:document_type, @acceptable_document_types)
    |> validate_format(:username, @email_regex)
    |> unique_constraint(:username)
  end

  @doc "Generates an `%Ecto.Changeset{}` to update the given model on database."
  @spec changeset(model :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = model, params) when is_map(params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:password_credential, with: &Password.changeset/2)
    |> validate_inclusion(:document_type, @acceptable_document_types)
    |> validate_length(:social_name, min: 2)
    |> validate_length(:legal_name, min: 2)
    |> validate_length(:document, min: 11)
    |> unique_constraint(:username)
  end
end
