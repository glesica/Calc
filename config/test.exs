use Mix.Config

config :calc, Calc.Endpoint,
  http: [port: System.get_env("PORT") || 4001]
