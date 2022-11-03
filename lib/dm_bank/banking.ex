defmodule DmBank.Banking do
  @moduledoc """
  The Banking context.
  """

  import Ecto.Query, warn: false
  alias DmBank.Repo
  alias DmBank.Users.User

  alias DmBank.Banking.Account

  def list_account do
    Repo.all(Account)
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def create_account(%User{id: user_id}) do
    %Account{user_id: user_id}
    |> Repo.insert()
  end
end
