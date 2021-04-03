defmodule EctoClass.Repo.Migrations.CreateOrganizationsTable do
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
  end
end
