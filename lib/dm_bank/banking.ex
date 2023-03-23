defmodule DmBank.Banking do
  @moduledoc """
  The Banking context.
  """

  import Ecto.Query, warn: false
  alias DmBank.Repo
  alias DmBank.Users.User
  alias Ecto.Multi
  alias DmBank.Banking.{Transaction, Account}

  @spec list_account() :: list()
  def list_account do
    Repo.all(Account)
  end

  @spec get_account!(id :: String.t()) :: map()
  def get_account!(id), do: Repo.get!(Account, id)

  @spec create_account(user :: User.__struct__()) :: {:ok, struct()}
  def create_account(%User{id: user_id}) do
    %Account{user_id: user_id}
    |> Account.changeset(%{})
    |> Repo.insert()
  end

  @spec account_from_user(user :: User.__struct__()) :: {:ok, struct()}
  def account_from_user(%User{id: user_id}) do
    Account
    |> from(where: [user_id: ^user_id])
    |> Repo.one()
  end

  @spec create_transaction(account :: %Account{}, params :: map()) ::
          {:ok, map()} | {:error, map()}
  def create_transaction(%Account{id: id}, params) do
    transaction = %Transaction{to_account_id: id, from_account_id: id}

    Multi.new()
    |> Multi.insert(:transaction, Transaction.changeset(transaction, params))
    |> Multi.update_all(
      :balance,
      fn %{transaction: transaction} ->
        increment_balance(transaction)
      end,
      []
    )
    |> Repo.transaction()
    |> normalize_response()
  end

  defp increment_balance(%{type: :deposit} = transaction) do
    increment_balance(transaction.to_account_id, transaction.amount)
  end

  defp increment_balance(%{type: :withdraw} = transaction) do
    amount = Decimal.negate(transaction.amount)
    increment_balance(transaction.from_account_id, amount)
  end

  defp increment_balance(account_id, amount) do
    Account
    |> from()
    |> where([a], a.id == ^account_id)
    |> select([a], a.current_balance)
    |> update([a], inc: [current_balance: ^amount])
  end

  defp normalize_response(response) do
    case response do
      {:ok, %{transaction: transaction}} -> {:ok, transaction}
      {:error, :transaction, changeset, _} -> {:error, changeset}
      {:error, _, reason, _} -> {:error, reason}
    end
  end
end
