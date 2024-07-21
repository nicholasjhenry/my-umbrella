defmodule MyUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_umbrella,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1", only: [:dev, :test], runtime: false},
      {:tz, "~> 0.3.0"}
    ]
  end

  defp aliases do
    [check: ["credo --strict", "dialyzer"]]
  end
end
