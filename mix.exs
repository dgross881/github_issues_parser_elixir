defmodule GithubIssues.Mixfile do
  use Mix.Project

  def project do
    [app: :github_issues,
     version: "0.1.0",
     elixir: "~> 1.3",
     source_url: "https://github.com/dgross881/github_issues_parser_elixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0"},
      {:ex_doc, "~> 0.12"},
      {:earmark, "~> 1.0.1" }
    ]
  end

  def escript do
    [ main_module: GithubIssues ]
  end
end
