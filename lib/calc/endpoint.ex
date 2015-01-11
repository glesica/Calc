defmodule Calc.Endpoint do
  use Phoenix.Endpoint, otp_app: :calc

  plug Plug.Static,
    at: "/", from: :calc

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_calc_key",
    signing_salt: "BqAuxvmV",
    encryption_salt: "YvvKpPPH"

  plug :router, Calc.Router
end
