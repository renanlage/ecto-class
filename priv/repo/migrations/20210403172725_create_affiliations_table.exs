defmodule EctoClass.Repo.Migrations.CreateAffiliationsTable do
  use Ecto.Migration

  def change do
    create table(:affiliations, primary_key: false) do
      add :user_id, :uuid, primary_key: true
      add :organization_id, :uuid, primary_key: true
      add :is_business_partner, :boolean, null: false, default: false
      add :is_business_partner_checked_at, :utc_datetime, null: false, default: fragment("now()")

      timestamps()
    end
  end
end
