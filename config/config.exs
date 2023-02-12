# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dm_bank,
  ecto_repos: [DmBank.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :dm_bank, DmBankWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: DmBankWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DmBank.PubSub,
  live_view: [signing_salt: "OCo8lRA7"]

config :dm_bank, DmBankWeb.UserAuth.Guardian,
  issuer: "max_bank",
  secret_key: "YcV8HeTLWprrfnIMB1zWVS0drFOUf3QXY3W7FKIqvJxAu+v2VoJomY7NLyk/dydA"

# the token should have a short life time for security reasons,
# no one keep a bank session of 40 minutes, for example.
config :guardian, Guardian.DB,
  repo: DmBank.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :dm_bank, DmBank.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
