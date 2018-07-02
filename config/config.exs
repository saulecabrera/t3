# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :t3, T3Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c6epbZPAvsFP9Y+gVgOZDUNtla31l4ukH0AgdioQ37wqJRFMpFTLH5y8D0PjCqVK",
  render_errors: [view: T3Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: T3.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
