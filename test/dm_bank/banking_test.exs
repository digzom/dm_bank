defmodule DmBank.BankingTest do
  use DmBank.DataCase

  alias DmBank.Banking

  describe "account" do
    alias DmBank.Banking.Account

    import DmBank.BankingFixtures

    @invalid_attrs %{current_balance: nil}

    test "list_account/0 returns all account" do
      account = account_fixture()
      assert Banking.list_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Banking.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{current_balance: "120.5"}

      assert {:ok, %Account{} = account} = Banking.create_account(valid_attrs)
      assert account.current_balance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Banking.create_account(@invalid_attrs)
    end
  end
end
