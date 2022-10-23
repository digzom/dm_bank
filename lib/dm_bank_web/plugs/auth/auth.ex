defmodule DmBankWeb.Auth do
  alias DmBank.Users.Guardian

  def encode_and_sign(user) do
    case Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {15, :minutes}) do
      {:ok, token, _claims} -> {:ok, token}
      error -> error
    end
  end
end
