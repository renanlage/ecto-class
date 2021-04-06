defmodule EctoClass.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string, null: false
      add :email_verified, :boolean, default: false
      add :social_name, :string
      add :legal_name, :string, null: false
      add :document, :string, null: false
      add :document_type, :string, null: false, default: "cpf"

      # Jsonb fields
      add :phones, {:array, :jsonb}
      add :address, :jsonb

      timestamps()
    end

    create unique_index(:users, [:username])
    create index(:users, [:document])
    create index(:users, [:address], using: "GIN")
  end
end
