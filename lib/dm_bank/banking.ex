defmodule DmBank.Banking do
  @moduledoc """
  The Banking context.
  """

  import Ecto.Query, warn: false
  alias DmBank.Repo
  alias DmBank.Users.User
  alias DmBank.Banking.Account

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
end
