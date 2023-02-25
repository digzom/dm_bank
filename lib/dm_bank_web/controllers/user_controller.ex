defmodule DmBankWeb.UserController do
  use DmBankWeb, :controller

  alias DmBank.Users
  alias DmBank.Users.User
  alias DmBank

  action_fallback DmBankWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %{user: %User{} = user}} <- DmBank.register_user_and_account(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
