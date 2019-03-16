defmodule Baresex.MixProject do
  use Mix.Project

  def project do
    [
      app: :baresex,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:socket, "~> 0.3"},
      {:jason, "~> 1.0"}
    ]
  end
end
