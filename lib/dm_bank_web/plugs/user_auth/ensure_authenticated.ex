defmodule DmBankWeb.UserAuth.EnsureAuthenticated do
  use Guardian.Plug.Pipeline,
    otp_app: :dm_bank,
    error_handler: DmBankWeb.UserAuth.ErrorHandler,
    module: DmBankWeb.UserAuth.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
