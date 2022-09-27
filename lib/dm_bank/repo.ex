defmodule DmBank.Repo do
  use Ecto.Repo,
    otp_app: :dm_bank,
    adapter: Ecto.Adapters.Postgres
end
