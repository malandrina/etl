defmodule Etl.Mixfile do
  use Mix.Project

  def project do
    [app: :etl,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: [main_module: Etl],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    Envy.auto_load
    [applications: [:logger, :postgrex]]
  end

  defp deps do
    [{:tds, "~> 0.5.4"}, {:postgrex, "~> 0.11.2"}, {:envy, "~> 1.0.0"}]
  end
end
