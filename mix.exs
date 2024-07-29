defmodule MyUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_umbrella,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1", only: [:dev, :test], runtime: false},
      {:plug_cowboy, "~> 2.7"},
      {:tz, "~> 0.3.0"}
    ]
  end

  defp aliases do
    [
      check: ["credo --strict", "dialyzer"],
      server: ["run --eval MyUmbrellaWeb.Server.start"]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix]
    ]
  end
end
