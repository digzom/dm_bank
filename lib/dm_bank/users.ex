defmodule DmBank.Users do
  import Ecto.Query, warn: false
  alias DmBank.Repo
  alias DmBank.Users
  alias DmBank.Banking
  alias DmBank.Repo
  alias Ecto.Multi
  alias DmBank.Users.User

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.update_changeset(user, attrs)
  end

  def authenticate_user(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        # this function runs the password hash function anyway
        # the goal is to spend the same time verifying a user
        # that is nome registered and a user that it is, so we
        # do not give clues to hackers about the username exist
        Pbkdf2.no_user_verify()
        # the caller don't need to know if this user exist or not
        {:error, :unauthorized}

      user ->
        check_user_password(user, password)
    end
  end

  defp check_user_password(%{password_hash: password_hash} = user, password) do
    if Pbkdf2.verify_pass(password, password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end

  def register_user_and_account(user_params) do
    Multi.new()
    |> Multi.run(:user, fn _, _ -> Users.register_user(user_params) end)
    |> Multi.run(:account, fn _, %{user: user} -> Banking.create_account(user) end)
    |> Repo.transaction()
  end
end
