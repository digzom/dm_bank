defmodule DmBank.UserAuthTest do
  use DmBank.DataCase

  alias DmBank.UserAuth

  describe "users" do
    alias DmBank.UserAuth.User

    import DmBank.UserAuthFixtures

    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserAuth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserAuth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "john@email.com", name: "John Doe", password_hash: ""}

      assert {:ok, %User{} = user} = UserAuth.create_user(valid_attrs)
      assert user.email == "john@email.com"
      assert user.name == "John Doe"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserAuth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "john_doe@email.com",
        name: "John"
      }

      assert {:ok, %User{} = user} = UserAuth.update_user(user, update_attrs)
      assert user.email == "john_doe@email.com"
      assert user.name == "John"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserAuth.update_user(user, @invalid_attrs)
      assert user == UserAuth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserAuth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserAuth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserAuth.change_user(user)
    end
  end
end
