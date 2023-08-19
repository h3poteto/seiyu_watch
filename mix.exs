defmodule SeiyuWatch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :seiyu_watch,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SeiyuWatch.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.0", override: true},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.2"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_view, "~> 2.0"},
      {:gettext, "~> 0.23"},
      {:cowboy, "~> 2.7"},
      {:timex, "~> 3.5"},
      {:httpoison, "~> 2.1.0"},
      {:poison, "~> 3.1"},
      {:quinn, "~> 1.0"},
      {:floki, "~> 0.34"},
      {:inflex, "~> 2.1"},
      {:quantum, "~> 3.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:arc, "~> 0.11.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws_sts, "~>2.1"},
      {:hackney, "~> 1.9"},
      {:configparser_ex, "~> 4.0"},
      {:mock, "~> 0.3", only: :test},
      {:scrivener, "~> 2.7"},
      {:scrivener_ecto, "~> 2.7"},
      {:scrivener_html, github: "mgwidmann/scrivener_html"},
      {:sweet_xml, "~> 0.7"},
      {:plug_cowboy, "~> 2.1"},
      {:rollbax, "~> 0.11"},
      {:jason, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
