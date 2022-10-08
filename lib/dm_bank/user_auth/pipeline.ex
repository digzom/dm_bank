defmodule DmBank.UserAuth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :dm_bank,
    error_handler: DmBank.UserAuth.ErrorHandler,
    module: DmBank.UserAuth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
