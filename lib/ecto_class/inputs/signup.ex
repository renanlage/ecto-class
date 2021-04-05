defmodule EctoClass.Inputs.Signup do
  @moduledoc """
  Input for creating an user and organization
  """

  use Ecto.Schema

  import Ecto.Changeset

  @user_required_fields [:username, :document, :legal_name]
  @organization_required_fields [:legal_name, :document]

  embedded_schema do
    field :is_business_partner, :boolean, default: false

    embeds_one :user, User do
      field :username, :string
      field :legal_name, :string
      field :document, :string
      field :document_type, :string, default: "cpf"
    end

    embeds_one :organization, Organization do
      field :legal_name, :string
      field :document, :string
      field :document_type, :string, default: "cnpj"
    end
  end

  @doc false
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:is_business_partner])
    |> cast_embed(:user, with: &changeset_user/2, required: true)
    |> cast_embed(:organization, with: &changeset_organization/2, required: true)
  end

  defp changeset_user(model, params) do
    model
    |> cast(params, @user_required_fields)
    |> validate_required(@user_required_fields)
  end

  defp changeset_organization(model, params) do
    model
    |> cast(params, @organization_required_fields)
    |> validate_required(@organization_required_fields)
  end
end
