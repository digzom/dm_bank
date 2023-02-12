import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dm_bank, DmBank.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "dm_bank_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dm_bank, DmBankWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gVdczK5w2gadgd/ugxJR75OnjBEAULZLdBnN5ofluOo53chj/qt0/4+yMuXTJkUX",
  server: false

config :pbkdf2_elixir, rouds: 1

# In test we don't send emails.
config :dm_bank, DmBank.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
