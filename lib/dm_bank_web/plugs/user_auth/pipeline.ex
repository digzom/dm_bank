defmodule DmBankWeb.UserAuth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :dm_bank,
    error_handler: DmBankWeb.UserAuth.ErrorHandler,
    module: DmBankWeb.UserAuth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
