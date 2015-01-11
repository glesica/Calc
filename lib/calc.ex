defmodule Calc do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Create the ets table for storing memory values
    :ets.new :mem, [:public, :named_table]

    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Calc.Worker, [arg1, arg2, arg3])
      worker(ConCache, [[
        ttl_check: :timer.seconds(1),
        ttl: :timer.seconds(5),
        touch_on_read: true     
      ], [name: :calc_cache]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Calc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Calc.Endpoint.config_change(changed, removed)
    :ok
  end
end
