defmodule ColorUtils.Mixfile do
  use Mix.Project

  def project do
    [app: :color_utils,
     version: "0.2.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     description: description,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    A Color Util library for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "test"],
      maintainers: ["Barak Karavani"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/barakyo/color_utils"}
    ]
  end
end
