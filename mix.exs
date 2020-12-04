defmodule SeiyuWatch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :seiyu_watch,
      version: "0.0.1",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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
      {:phoenix, "~> 1.4.17"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.6.0"},
      {:mariaex, "~> 0.8.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10.5"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13"},
      {:cowboy, "~> 1.1"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.1"},
      {:httpoison, "~> 1.7.0"},
      {:poison, "~> 3.1"},
      {:quinn, "~> 1.0"},
      {:floki, "~> 0.18"},
      {:inflex, "~> 2.1"},
      {:quantum, "~> 2.4.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:arc, "~> 0.11.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws_sts, "~>2.1"},
      {:hackney, "~> 1.9"},
      {:configparser_ex, "~> 4.0"},
      {:mock, "~> 0.3", only: :test},
      {:exrm, "~> 1.0.8", only: :prod},
      {:scrivener, "~> 2.3"},
      {:scrivener_ecto, "~> 1.2"},
      {:scrivener_html, "~> 1.8"},
      {:sweet_xml, "~> 0.6"},
      {:plug_cowboy, "~> 1.0"},
      {:rollbax, "~> 0.11"}
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
