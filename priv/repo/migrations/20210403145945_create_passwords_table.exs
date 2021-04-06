defmodule EctoClass.Repo.Migrations.CreatePasswordsTable do
  use Ecto.Migration

  def change do
    create table(:passwords, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :password_hash, :string, null: false
      add :algorithm, :string, null: false, default: "argon2"
      add :salt, :integer, null: false, default: 11

      # Relations
      add :user_id, references(:users, type: :uuid), null: false

      timestamps()
    end

    create index(:passwords, [:user_id])
  end
end
