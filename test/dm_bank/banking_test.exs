defmodule DmBank.BankingTest do
  use DmBank.DataCase

  alias DmBank.Banking

  describe "account" do
    alias DmBank.Banking.Account
    alias DmBank.Users.User

    test "list_account/0 returns all account" do
      account = insert(:accounts)
      assert Banking.list_account() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = insert(:accounts)
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

    test "account_from_user/1 with valid user returns the account" do
      user = insert(:user)
      expected_account = insert(:accounts, user_id: user.id)
      assert %Account{} = actual = Banking.account_from_user(user)
      assert actual.id == expected_account.id
    end
  end

  describe "transactions" do
    alias DmBank.Banking.{Account, Transaction}

    test "create_transaction/2 with valid data creates a deposit transaction" do
      account = insert(:accounts)

      params = %{
        type: :deposit,
        amount: "100.0"
      }

      assert {:ok, %Transaction{} = transaction} = Banking.create_transaction(account, params)
      assert transaction.type == :deposit
      assert transaction.amount == Decimal.new("100.0")
      assert transaction.to_account_id == account.id
      assert transaction.from_account_id == nil
    end

    test "create_transaction/2 with valid withdraw data creates a withdraw transaction" do
      account = insert(:accounts)

      params = %{
        type: :withdraw,
        amount: "100.0"
      }

      assert {:ok, %Transaction{} = transaction} = Banking.create_transaction(account, params)
      assert transaction.type == :withdraw
      assert transaction.amount == Decimal.new("100.0")
      assert transaction.from_account_id == account.id
      assert transaction.to_account_id == nil
    end

    test "create_transaction/2 with to_account_id creates a deposit transaction to another account" do
      account = insert(:accounts)
      another_account = insert(:accounts)

      params = %{
        type: :deposit,
        amount: "100.0",
        to_account_id: another_account.id
      }

      assert {:ok, %Transaction{} = transaction} = Banking.create_transaction(account, params)
      assert transaction.to_account_id == another_account.id
    end

    test "create_transaction/2 with valid data updates the account current_balance" do
      account = insert(:accounts)

      params = %{
        type: :deposit,
        amount: "100.0"
      }

      Banking.create_transaction(account, params)
      account = Banking.get_account!(account.id)

      assert account.current_balance == Decimal.new("100.0")
    end

    test "create_transaction/2 with valid withdraw data update the account current_balance" do
      account = insert(:accounts, current_balance: Decimal.new("200.0"))

      params = %{
        type: :withdraw,
        amount: "100.0"
      }

      Banking.create_transaction(account, params)
      account = Banking.get_account!(account.id)

      assert account.current_balance == Decimal.new("100.0")
    end

    test "create_transaction/2 with valid withdraw data doesn't allow to withdraw with insuficient funds" do
      account = insert(:accounts, current_balance: Decimal.new("50.0"))

      params = %{
        type: :withdraw,
        amount: "100.0"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Banking.create_transaction(account, params)

      assert %{amount: ["insuficient funds"]} = errors_on(changeset)
    end

    test "create_transaction/2 with invalid to_account_id doesn't create the deposit" do
      account = insert(:accounts)

      params = %{
        type: :deposit,
        amount: "100.0",
        to_account_id: Ecto.UUID.generate()
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Banking.create_transaction(account, params)

      assert %{to_account: ["does not exist"]} = errors_on(changeset)
    end
  end
end
