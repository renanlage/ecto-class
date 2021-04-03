defmodule EctoClass do
  @moduledoc """
  Exemple postgress and Ecto application.

  EctoClass is an application created for Stones Elixir Formation Program
  students in order to serve as an exemple of an application running
  a postgress database with Ecto.
  """

  alias EctoClass.Profiles.{Affiliations, Organizations, Users}

  # User Profile function delegations
  defdelegate create_user(params), to: Users, as: :create
  defdelegate update_user(user, params), to: Users, as: :update
  defdelegate delete_user(user), to: Users, as: :delete
  defdelegate get_user_by(filters), to: Users, as: :get_by
  defdelegate get_user(user_id), to: Users, as: :get
  defdelegate list_users, to: Users, as: :list
  defdelegate list_users(filters), to: Users, as: :list

  # Organization Profile function delegations
  defdelegate create_organization(params), to: Organizations, as: :create
  defdelegate update_organization(organization, params), to: Organizations, as: :update
  defdelegate delete_organization(organization), to: Organizations, as: :delete
  defdelegate get_organization_by(filters), to: Organizations, as: :get_by
  defdelegate get_organization(organization_id), to: Organizations, as: :get
  defdelegate list_organizations, to: Organizations, as: :list
  defdelegate list_organizations(filters), to: Organizations, as: :list

  # Affiliation Profile function delegations
  defdelegate create_affiliation(params), to: Affiliations, as: :create
  defdelegate update_affiliation(affiliation, params), to: Affiliations, as: :update
  defdelegate delete_affiliation(affiliation), to: Affiliations, as: :delete
  defdelegate get_affiliation_by(filters), to: Affiliations, as: :get_by
  defdelegate get_affiliation(affiliation_id), to: Affiliations, as: :get
  defdelegate list_affiliations, to: Affiliations, as: :list
  defdelegate list_affiliations(filters), to: Affiliations, as: :list
end
