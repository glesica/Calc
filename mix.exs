defmodule Calc.Mixfile do
  use Mix.Project

  def project do
    [app: :calc,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Calc, []},
     applications: [:phoenix, :cowboy, :logger, :con_cache]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.7.2"},
     {:cowboy, "~> 1.0"},
     {:con_cache, "~>0.7.0"}]
  end
end
