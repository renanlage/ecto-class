defmodule EctoClass.Profiles.Schemas.User do
  @moduledoc """
  Database schema representation of users table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Credentials.Schemas.Password

  @required_fields [:username, :document, :legal_name]
  @optional_fields [:email_verified, :social_name, :document_type]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :email_verified, :boolean, default: false
    field :social_name, :string
    field :legal_name, :string
    field :document, :string
    field :document_type, :string, default: "cpf"

    # Jsonb

    # Relations
    has_one :password_credential, Password, on_replace: :update, on_delete: :delete_all

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
    |> validate_required(@required_fields)
    |> validate_length(:legal_name, min: 2)
    |> validate_inclusion(:document_type, ["cpf", "rg"])
    |> unique_constraint(:username)
  end
end
