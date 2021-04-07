defmodule EctoClass.Profiles.Schemas.Organization do
  @moduledoc """
  Database schema representation of organizations table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Profiles.Schemas.{Affiliation, User}

  @typedoc "An ecto struct representation of users table"
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          company_name: String.t() | nil,
          legal_name: String.t(),
          document: String.t(),
          document_type: String.t(),
          users: list(User.t()) | Ecto.Association.NotLoaded.t(),
          inserted_at: Datetime.t(),
          updated_at: Datetime.t()
        }

  # Fields used on casting and validations
  @acceptable_document_types ~w(cnpj)
  @required_fields [:legal_name, :document]
  @optional_fields [:company_name, :document_type]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :company_name, :string
    field :legal_name, :string
    field :document, :string
    field :document_type, :string, default: "cnpj"

    many_to_many :users, User, join_through: Affiliation

    timestamps()
  end

  @doc "Generates an `%Ecto.Changeset{}` to insert new registers on database."
  @spec changeset(params :: map()) :: Ecto.Changeset.t()
  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:legal_name, min: 2)
    |> validate_inclusion(:document_type, @acceptable_document_types)
    |> validate_document_by_type()
  end

  @doc "Generates an `%Ecto.Changeset{}` to update the given model on database."
  @spec changeset(model :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = model, params) when is_map(params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:document_type, @acceptable_document_types)
    |> validate_length(:company_name, min: 2)
    |> validate_length(:legal_name, min: 2)
    |> validate_length(:document, min: 14)
    |> validate_document_by_type()
    |> unique_constraint(:username)
  end

  # This could be converted into a custom ecto type
  # For more info check https://hexdocs.pm/ecto/Ecto.Type.html
  defp validate_document_by_type(
         %Ecto.Changeset{
           changes: %{
             document: document,
             document_type: "cnpj"
           }
         } = changeset
       ) do
    %Cnpj{number: document}
    |> Brcpfcnpj.cnpj_valid?()
    |> case do
      true -> add_error(changeset, :document, "Invalid CNPJ")
      false -> changeset
    end
  end

  defp validate_document_by_type(changeset), do: changeset
end
