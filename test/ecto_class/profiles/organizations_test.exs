defmodule EctoClass.Profiles.OrganizationsTest do
  use EctoClass.DataCase, assync: true

  alias EctoClass.Profiles.Organizations
  alias EctoClass.Profiles.Schemas.{Organization, User}

  setup do
    {:ok, org: insert!(:organization)}
  end

  describe "#{Organizations}.create/1" do
    test "succeeds and creates an organization" do
      params = params_for(:organization)
      assert {:ok, %Organization{}} = Organizations.create(params)
    end

    test "fails if params are invalid" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  legal_name: {"can't be blank", _},
                  document: {"can't be blank", _}
                ]
              }} = Organizations.create(%{})
    end
  end

  describe "#{Organizations}.update/1" do
    test "succeeds and updates an organization", %{org: org} do
      assert {:ok, %Organization{id: id}} =
               Organizations.update(org, %{legal_name: "Updated Name"})

      assert org.id == id
    end

    test "fails if params are invalid", %{org: org} do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  legal_name: {"is invalid", _}
                ]
              }} = Organizations.update(org, %{legal_name: 123})
    end
  end

  describe "#{Organizations}.delete/1" do
    test "succeeds and deletes an organization", %{org: org} do
      assert {:ok, %Organization{}} = Organizations.delete(org)
      assert is_nil(Repo.get(Organization, org.id))
    end
  end

  describe "#{Organizations}.get_by/1" do
    test "returns an organization when it was found", %{org: org} do
      assert %Organization{} = Organizations.get_by(document: org.document)
    end

    test "returns nil when nothing was found" do
      assert is_nil(Organizations.get_by(document: "wrong_document"))
    end
  end

  describe "#{Organizations}.get/1" do
    test "returns an organization when it was found", %{org: org} do
      assert %Organization{} = Organizations.get(org.id)
    end

    test "returns nil when nothing was found" do
      assert is_nil(Organizations.get(Ecto.UUID.generate()))
    end
  end

  describe "#{Organizations}.exists?/1" do
    test "returns an organization when it was found", %{org: org} do
      assert Organizations.exists?(document: org.document)
    end

    test "returns false when nothing was found" do
      assert Organizations.exists?(document: "wrong_document")
    end
  end

  describe "#{Organizations}.all/1" do
    setup do
      {:ok, org_list: insert_list!(:organization, 9)}
    end

    test "returns all organizations when filters are empty" do
      assert 10 == length(Organizations.all())
    end

    test "returns the organizations filtered", %{org: org} do
      assert [%Organization{id: id}] = Organizations.all(document: org.document)
      assert org.id == id
    end

    test "returns empty if nothing was found" do
      assert [] = Organizations.all(document: "wrong_document")
    end
  end

  describe "#{Organizations}.one/1" do
    test "returns the organization filtered", %{org: org} do
      assert %Organization{id: id} = Organizations.one(document: org.document)
      assert org.id == id
    end

    test "returns empty if nothing was found" do
      assert is_nil(Organizations.one(document: "wrong_document"))
    end
  end

  describe "#{Organizations}.preload/1" do
    test "returns the organization with the users preloaded", %{org: org} do
      insert!(:affiliation, organization: org)
      assert %Organization{users: [%User{}]} = Organizations.preload(org, [:users])
    end

    test "returns empty if list if there's nothing to be preloaded" do
      assert is_nil(Organizations.one(document: "wrong_document"))
    end
  end

  describe "#{Organizations}.count/1" do
    setup do
      {:ok, org_list: insert_list!(:organization, 9)}
    end

    test "returns the count when filters are empty" do
      assert 10 == Organizations.count()
    end

    test "returns the count of organizations filtered", %{org: org} do
      assert 1 == Organizations.count(document: org.document)
    end
  end

  describe "#{Organizations}.sort/1" do
    setup do
      future =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(120, :second)
        |> NaiveDateTime.truncate(:second)

      {:ok, org2: insert!(:organization, inserted_at: future)}
    end

    test "returns the organizations sorted asc", %{org: org} do
      assert [%Organization{id: id} | _] = Organizations.sort([], asc: :inserted_at)
      assert org.id == id
    end

    test "returns the organizations sorted desc", %{org: org} do
      assert [%Organization{id: id} | _] = Organizations.sort([], desc: :inserted_at)
      assert org.id != id
    end
  end
end
