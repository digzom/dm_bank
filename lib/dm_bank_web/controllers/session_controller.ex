defmodule DmBankWeb.SessionController do
  use DmBankWeb, :controller

  alias DmBank.Users
  alias DmBank.Users.User
  alias DmBankWeb.Auth

  action_fallback DmBankWeb.FallbackController

  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- Users.authenticate_user(email, password),
         {:ok, token} <- Auth.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, token: token)
    else
      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> render("invalid_credentials.json")

      error ->
        error
    end
  end
end
