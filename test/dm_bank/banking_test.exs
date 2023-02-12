defmodule DmBank.BankingTest do
  use DmBank.DataCase

  alias DmBank.Banking

  describe "account" do
    alias DmBank.Banking.Account
    alias DmBank.Users.User

    @invalid_attrs %{current_balance: nil}

    test "list_account/0 returns all account" do
      account = insert(:account)
      assert Banking.list_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = insert(:account)
      assert Banking.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      user = insert(:user)

      assert {:ok, %Account{} = account} = Banking.create_account(user)
      assert account.current_balance == Decimal.new("0.0")
      assert account.user_id == user.id
    end

    test "create_account/1 with invalid data returns error changeset" do
      fake_user = %User{id: "51f90174-a21a-40ad-afc7-6c6abe116ebe"}
      assert {:error, %Ecto.Changeset{} = changeset} = Banking.create_account(fake_user)
      assert errors_on(changeset) == %{user: ["does not exist"]}
    end
  end
end
