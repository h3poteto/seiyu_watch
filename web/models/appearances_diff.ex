defmodule SeiyuWatch.AppearancesDiff do
  use SeiyuWatch.Web, :model
  alias SeiyuWatch.Repo

  schema "appearances_diffs" do
    field :add_html, :string
    field :sub_html, :string
    belongs_to :current_appearance, SeiyuWatch.SeiyuAppearance
    belongs_to :previous_appearance, SeiyuWatch.SeiyuAppearance

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:add_html, :sub_html, :current_appearance_id, :previous_appearance_id])
    |> assoc_constraint(:current_appearance)
    |> assoc_constraint(:previous_appearance)
    |> validate_required([:current_appearance_id, :previous_appearance_id])
  end

  def create(old_appearance, new_appearance) do
    new_app = new_appearance.wiki_appearances |> Floki.parse
    old_app = old_appearance.wiki_appearances |> Floki.parse
    add_diff = new_app -- old_app
    sub_diff = old_app -- new_app
    changeset(%SeiyuWatch.AppearancesDiff{},
      %{
        "add_html" => add_diff |> Floki.raw_html,
        "sub_html" => sub_diff |> Floki.raw_html,
        "current_appearance_id" => new_appearance.id,
        "previous_appearance_id" => old_appearance.id
      }
    )
    |> Repo.insert
  end
end
