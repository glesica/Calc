defmodule Calc.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", Calc do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/calc/", Calc do
    pipe_through :api

    get ":op/:right", CalcController, :unary
    get ":op/:left/:right", CalcController, :binary
  end

  scope "/mem/", Calc do
    pipe_through :api

    put ":slot", CalcController, :save
    get ":slot", CalcController, :load
  end

  # Other scopes may use custom stacks.
  # scope "/api", Calc do
  #   pipe_through :api
  # end
end
