defmodule EctoClass.Repo.Migrations.CreateTableOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :company_name, :string
      add :legal_name, :string, null: false
      add :document, :string, null: false
      add :document_type, :string, null: false, default: "cnpj"

      timestamps()
    end

    create index(:organizations, [:document])

    create table(:affiliations, primary_key: false) do
      add :is_business_partner, :boolean, default: false
      add :user_id, references(:users, type: :uuid), primary_key: true, null: false
      add :organization_id, references(:organizations, type: :uuid), primary_key: true, null: false

      timestamps()
    end
  end
end
