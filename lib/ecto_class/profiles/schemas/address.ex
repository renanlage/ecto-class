defmodule EctoClass.Profiles.Schemas.Address do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :zip_code, :string
    field :street, :string
    field :district, :string
    field :number, :string
    field :reference, :string
  end

  def changeset(%__MODULE__{} = model, params) do
    model
    |> cast(params, [:zip_code, :street, :district, :number, :reference])
    |> validate_required([:street, :number])
  end
end
