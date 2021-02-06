# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :yamm,
  namespace: YAMM,
  ecto_repos: [YAMM.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :yamm, YAMMWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fOv3ltBhZXa6xNUZi7mdT78SEBz7XYBrwkE3M66HA+iyG69VaFDVYxRNfzBBa8gd",
  render_errors: [view: YAMMWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: YAMM.PubSub,
  live_view: [signing_salt: "xcPhx/RE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
