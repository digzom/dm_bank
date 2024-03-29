defmodule DmBank.UsersTest do
  use DmBank.DataCase

  alias DmBank.Users

  describe "users" do
    alias DmBank.Users.User

    import DmBank.Factory

    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Users.get_user!(user.id) == user
    end

    test "register_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "john@email.com",
        name: "John Doe",
        password: "123456",
        password_confirmation: "123456"
      }

      assert {:ok, %User{} = user} = Users.register_user(valid_attrs)
      assert user.email == "john@email.com"
      assert user.name == "John Doe"
      assert Pbkdf2.verify_pass("123456", user.password_hash)
    end

    test "register_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.register_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)

      update_attrs = %{
        name: "John"
      }

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.name == "John"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "authenticate_user/2 returns the user with valid password" do
      {:ok, user} = params_for(:user, password: "123456") |> Users.register_user()

      assert {:ok, %User{} = authenticated_user} = Users.authenticate_user(user.email, "123456")

      assert user.id == authenticated_user.id
    end

    test "authenticate_user/2 returns the user with wrong password" do
      {:ok, user} = params_for(:user, password: "123456") |> Users.register_user()

      assert {:error, :unauthorized} = Users.authenticate_user(user.email, "123")

      assert {:error, :unauthorized} = Users.authenticate_user("some_email@example.com", "123")
    end

    test "register_user_and_account/1 create an user and it account" do
      password = "123456"

      valid_params =
        :user
        |> params_for(password: password)
        |> Map.put(:password_confirmation, password)

      assert {:ok, %{user: _user, accounts: _account}} =
               DmBank.register_user_and_account(valid_params)
    end
  end
end
