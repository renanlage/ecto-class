defmodule EctoClassTest do
  use EctoClass.DataCase, assync: true

  alias EctoClass.Profiles.Schemas.{Organization, User}

  describe "#{EctoClass}.signup/1" do
    test "succeeds and creates an user" do
      user = params_for(:user)
      org = params_for(:organization)

      assert {:ok, %{user: %User{}, organization: %Organization{}}} =
               EctoClass.signup(%{"user" => user, "organization" => org})
    end

    test "fails if params are invalid" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  {:organization, {"can't be blank", _}},
                  {:user, {"can't be blank", _}}
                ]
              }} = EctoClass.signup(%{})
    end
  end
end
