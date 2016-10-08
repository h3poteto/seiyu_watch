defmodule WikiParserTest do
  use SeiyuWatch.TaskCase

  import Mock
  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.WikiParser

  def seiyu(), do: Repo.insert! %SeiyuWatch.Seiyu{name: "阿澄佳奈"}

  describe "#update_wiki" do
    setup do
      {:ok, seiyu: seiyu()}
    end
    test "when seiyu does not have wikipedia record", %{seiyu: seiyu} do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough], [get_response: fn(_request) -> response_content(%{content: "content"}) end] do
        refute Repo.get_by(SeiyuWatch.Wikipedia, seiyu_id: seiyu.id)
        {:ok, _wikipedia} = WikiParser.update_wiki(seiyu.id)
        wiki = Repo.get_by(SeiyuWatch.Wikipedia, seiyu_id: seiyu.id)
        assert wiki.content == "content"
      end
    end

    test "when seiyu has wikipedia record", %{seiyu: seiyu} do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough], [get_response: fn(_request) -> response_content(%{content: "new content"}) end] do
        seiyu
        |> Ecto.build_assoc(:wikipedia)
        |> SeiyuWatch.Wikipedia.changeset(%{"content" => "content"})
        |> Repo.insert!
        {:ok, _wikipedia} = WikiParser.update_wiki(seiyu.id)
        wiki = Repo.get_by(SeiyuWatch.Wikipedia, seiyu_id: seiyu.id)
        assert wiki.content == "new content"
      end
    end
  end
end
