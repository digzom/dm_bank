defmodule DmBankWeb.SessionController do
  use DmBankWeb, :controller

  alias DmBank.UserAuth
  alias DmBank.UserAuth.Guardian
  alias DmBank.UserAuth.User

  action_fallback DmBankWeb.FallbackController

  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- UserAuth.authenticate_user(email, password),
         {:ok, token, _claims} <- encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user, token: token)
    end
  end

  defp encode_and_sign(user) do
    Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {15, :minutes})
  end
end
