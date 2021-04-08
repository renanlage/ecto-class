defmodule EctoClass.Profiles.UsersTest do
  use EctoClass.DataCase, assync: true

  alias EctoClass.Profiles.Users
  alias EctoClass.Profiles.Schemas.{Organization, User}

  setup do
    {:ok, user: insert!(:user)}
  end

  describe "#{Users}.create/1" do
    test "succeeds and creates an user" do
      params = params_for(:user)
      assert {:ok, %User{}} = Users.create(params)
    end

    test "fails if params are invalid" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  {:username, {"can't be blank", _}},
                  {:document, {"can't be blank", _}},
                  {:legal_name, {"can't be blank", _}}
                ]
              }} = Users.create(%{})
    end
  end

  describe "#{Users}.update/1" do
    test "succeeds and updates an user", %{user: user} do
      assert {:ok, %User{id: id}} = Users.update(user, %{legal_name: "Updated Name"})
      assert user.id == id
    end

    test "fails if params are invalid", %{user: user} do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  legal_name: {"is invalid", _}
                ]
              }} = Users.update(user, %{legal_name: 123})
    end
  end

  describe "#{Users}.delete/1" do
    test "succeeds and deletes an user", %{user: user} do
      assert {:ok, %User{}} = Users.delete(user)
      assert is_nil(Repo.get(Organization, user.id))
    end
  end

  describe "#{Users}.get_by/1" do
    test "returns an user when it was found", %{user: user} do
      assert %User{} = Users.get_by(document: user.document)
    end

    test "returns nil when nothing was found" do
      assert is_nil(Users.get_by(document: "wrong_document"))
    end
  end

  describe "#{Users}.get/1" do
    test "returns an user when it was found", %{user: user} do
      assert %User{} = Users.get(user.id)
    end

    test "returns nil when nothing was found" do
      assert is_nil(Users.get(Ecto.UUID.generate()))
    end
  end

  describe "#{Users}.exists?/1" do
    test "returns an user when it was found", %{user: user} do
      assert Users.exists?(document: user.document)
    end

    test "returns false when nothing was found" do
      assert Users.exists?(document: "wrong_document")
    end
  end

  describe "#{Users}.all/1" do
    setup do
      {:ok, user_list: insert_list!(:user, 9)}
    end

    test "returns all users when filters are empty" do
      assert 10 == length(Users.all())
    end

    test "returns the users filtered", %{user: user} do
      assert [%User{id: id}] = Users.all(document: user.document)
      assert user.id == id
    end

    test "returns empty if nothing was found" do
      assert [] = Users.all(document: "wrong_document")
    end
  end

  describe "#{Users}.one/1" do
    test "returns the user filtered", %{user: user} do
      assert %User{id: id} = Users.one(document: user.document)
      assert user.id == id
    end

    test "returns empty if nothing was found" do
      assert is_nil(Users.one(document: "wrong_document"))
    end
  end

  describe "#{Users}.preload/1" do
    test "returns the user with the users preloaded", %{user: user} do
      insert!(:affiliation, user: user)
      assert %User{organizations: [%Organization{}]} = Users.preload(user, [:organizations])
    end

    test "returns empty if list if there's nothing to be preloaded" do
      assert is_nil(Users.one(document: "wrong_document"))
    end
  end

  describe "#{Users}.count/1" do
    setup do
      {:ok, user_list: insert_list!(:user, 9)}
    end

    test "returns the count when filters are empty" do
      assert 10 == Users.count()
    end

    test "returns the count of users filtered", %{user: user} do
      assert 1 == Users.count(document: user.document)
    end
  end

  describe "#{Users}.sort/1" do
    setup do
      future =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(120, :second)
        |> NaiveDateTime.truncate(:second)

      {:ok, user2: insert!(:user, inserted_at: future)}
    end

    test "returns the users sorted asc", %{user: user} do
      assert [%User{id: id} | _] = Users.sort([], asc: :inserted_at)
      assert user.id == id
    end

    test "returns the users sorted desc", %{user: user} do
      assert [%User{id: id} | _] = Users.sort([], desc: :inserted_at)
      assert user.id != id
    end
  end
end
