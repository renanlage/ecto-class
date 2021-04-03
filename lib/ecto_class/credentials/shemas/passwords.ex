defmodule EctoClass.Credentials.Schemas.Password do
  @moduledoc """
  Database schema representation of an user passwords table.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoClass.Profiles.Schemas.User

  @typedoc "An ecto struct representation of users table"
  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          user: User.t() | Ecto.Association.NotLoaded.t(),
          user_id: Ecto.UUID.t(),
          password: String.t() | nil,
          password_hash: String.t(),
          algorithm: String.t(),
          salt: integer(),
          inserted_at: Datetime.t(),
          updated_at: Datetime.t()
        }

  # Default module arguments
  @default_algorithm "argon2"
  @default_salt 16

  # Fields used on casting and validations
  @acceptable_algorithms ~w(argon2 bcrypt pbkdf2)
  @required_fields [:password, :user_id]
  @optional_fields [:algorithm, :salt]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "passwords" do
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true
    field :algorithm, :string, default: @default_algorithm
    field :salt, :integer, default: @default_salt

    # Relations
    belongs_to :user, User

    timestamps()
  end

  @doc "Generates an `%Ecto.Changeset{}` to update the given model on database."
  @spec changeset(model :: __MODULE__.t(), params :: map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = model, params) when is_map(params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_inclusion(:algorithm, @acceptable_algorithms)
    |> validate_length(:password, min: 6)
    |> hash_password()
  end

  defp hash_password(
         %Ecto.Changeset{
           valid?: true,
           changes: %{password: password} = changes
         } = changeset
       )
       when is_binary(password) do
    # Getting configs from changes or defaults
    algorithm = Map.get(changes, :algorithm, @default_algorithm)
    salt = Map.get(changes, :salt, @default_salt)

    password_hash =
      case algorithm do
        "argon2" -> Argon2.hash_pwd_salt(password, salt_len: salt)
        "bcrypt" -> Bcrypt.hash_pwd_salt(password, salt_len: salt)
        "pbkdf2" -> Pbkdf2.hash_pwd_salt(password, salt_len: salt)
      end

    put_change(changeset, :password_hash, password_hash)
  end

  defp hash_password(%Ecto.Changeset{} = changeset), do: changeset
end
