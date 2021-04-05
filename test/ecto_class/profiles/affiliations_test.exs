defmodule EctoClass.Profiles.AffiliationsTest do
  use EctoClass.DataCase, assync: true

  alias EctoClass.Repo
  alias EctoClass.Profiles.Affiliations
  alias EctoClass.Profiles.Schemas.{Affiliation, Organization, User}

  setup do
    {:ok, affiliation: insert!(:affiliation, is_business_partner: true)}
  end

  describe "#{Affiliations}.create/1" do
    test "succeeds and creates an affiliation" do
      user = insert!(:user)
      org = insert!(:organization)

      assert {:ok, %Affiliation{}} =
               Affiliations.create(%{user_id: user.id, organization_id: org.id})
    end

    test "fails if params are invalid" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  {:user_id, {"can't be blank", _}},
                  {:organization_id, {"can't be blank", _}}
                ]
              }} = Affiliations.create(%{})
    end
  end

  describe "#{Affiliations}.update/1" do
    test "succeeds and updates an affiliation", %{affiliation: affiliation} do
      assert {:ok,
              %Affiliation{
                user_id: user_id,
                organization_id: org_id,
                is_business_partner: false
              }} = Affiliations.update(affiliation, %{is_business_partner: false})

      assert affiliation.user_id == user_id
      assert affiliation.organization_id == org_id
    end

    test "fails if params are invalid", %{affiliation: affiliation} do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  is_business_partner: {"is invalid", _}
                ]
              }} = Affiliations.update(affiliation, %{is_business_partner: 123})
    end
  end

  describe "#{Affiliations}.delete/1" do
    test "succeeds and deletes an affiliation", %{affiliation: affiliation} do
      assert {:ok, %Affiliation{}} = Affiliations.delete(affiliation)
      assert is_nil(Repo.get_by(Affiliation, user_id: affiliation.user_id))
    end
  end

  describe "#{Affiliations}.get_by/1" do
    test "returns an affiliation when it was found", %{affiliation: affiliation} do
      assert %Affiliation{} =
               Affiliations.get_by(is_business_partner: affiliation.is_business_partner)
    end

    test "returns nil when nothing was found" do
      assert is_nil(Affiliations.get_by(is_business_partner: false))
    end
  end

  describe "#{Affiliations}.exists?/1" do
    test "returns an affiliation when it was found", %{affiliation: affiliation} do
      assert Affiliations.exists?(is_business_partner: affiliation.is_business_partner)
    end

    test "returns false when nothing was found" do
      assert Affiliations.exists?(is_business_partner: false)
    end
  end

  describe "#{Affiliations}.all/1" do
    setup do
      {:ok, affiliation_list: insert_list!(:affiliation, 9)}
    end

    test "returns all affiliations when filters are empty" do
      assert 10 == length(Affiliations.all())
    end

    test "returns the affiliations filtered", %{affiliation: affiliation} do
      assert [%Affiliation{user_id: user_id, organization_id: org_id}] =
               Affiliations.all(is_business_partner: affiliation.is_business_partner)

      assert affiliation.user_id == user_id
      assert affiliation.organization_id == org_id
    end

    test "returns empty if nothing was found" do
      assert [] = Affiliations.all(user_id: Ecto.UUID.generate())
    end
  end

  describe "#{Affiliations}.one/1" do
    test "returns the affiliation filtered", %{affiliation: affiliation} do
      assert %Affiliation{user_id: user_id, organization_id: org_id} =
               Affiliations.one(is_business_partner: affiliation.is_business_partner)

      assert affiliation.user_id == user_id
      assert affiliation.organization_id == org_id
    end

    test "returns empty if nothing was found" do
      assert is_nil(Affiliations.one(is_business_partner: false))
    end
  end

  describe "#{Affiliations}.preload/1" do
    test "returns the affiliation with the affiliations preloaded", %{affiliation: affiliation} do
      assert %Affiliation{organization: %Organization{}, user: %User{}} =
               Affiliations.preload(affiliation, [:organization, :user])
    end

    test "returns empty if list if there's nothing to be preloaded" do
      assert is_nil(Affiliations.one(is_business_partner: false))
    end
  end

  describe "#{Affiliations}.count/1" do
    setup do
      {:ok, affiliation_list: insert_list!(:affiliation, 9)}
    end

    test "returns the count when filters are empty" do
      assert 10 == Affiliations.count()
    end

    test "returns the count of affiliations filtered", %{affiliation: affiliation} do
      assert 1 == Affiliations.count(is_business_partner: affiliation.is_business_partner)
    end
  end

  describe "#{Affiliations}.sort/1" do
    setup do
      future =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(120, :second)
        |> NaiveDateTime.truncate(:second)

      {:ok, affiliation2: insert!(:affiliation, inserted_at: future)}
    end

    test "returns the affiliations sorted asc", %{affiliation: affiliation} do
      assert [%Affiliation{user_id: user_id, organization_id: org_id} | _] =
               Affiliations.sort([], asc: :inserted_at)

      assert affiliation.user_id == user_id
      assert affiliation.organization_id == org_id
    end

    test "returns the affiliations sorted desc", %{affiliation: affiliation} do
      assert [%Affiliation{user_id: user_id, organization_id: org_id} | _] =
               Affiliations.sort([], desc: :inserted_at)

      assert affiliation.user_id != user_id
      assert affiliation.organization_id != org_id
    end
  end

  describe "#{Affiliations}.join_all/2" do
    test "returns all affiliations with the join fields loaded", %{affiliation: affiliation} do
      assert [
               %Affiliation{
                 user: %User{id: user_id},
                 organization: %Organization{id: org_id},
                 is_business_partner: true
               }
             ] = Affiliations.join_all()

      assert affiliation.user_id == user_id
      assert affiliation.organization_id == org_id
    end
  end
end
