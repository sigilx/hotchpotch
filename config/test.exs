use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hotchpotch, Hotchpotch.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :hotchpotch, Hotchpotch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "bigfang",
  password: "",
  database: "hotchpotch_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
