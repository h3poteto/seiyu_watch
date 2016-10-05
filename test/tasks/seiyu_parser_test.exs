defmodule SeiyuWatch.SeiyuParserTest do
  use SeiyuWatch.TaskCase

  import Mock
  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.SeiyuParser

  describe "#save" do
    test "should save seiyu" do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough], [get_response: fn(_request) -> response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) end] do
        with_mock SeiyuWatch.SeiyuEvent, [after_create: fn(_create) -> :ok end] do
          res = SeiyuParser.save("阿澄佳奈")
          assert res != {:failed, "阿澄佳奈"}
          assert Repo.get_by(SeiyuWatch.Seiyu, %{name: "阿澄佳奈"})
        end
      end
    end

    test "should call after_create event" do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough], [get_response: fn(_request) -> response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) end] do
        with_mock SeiyuWatch.SeiyuEvent, [after_create: fn(_create) -> :ok end] do
          {:ok, task} = SeiyuParser.save("阿澄佳奈")
          assert Task.await(task) == :ok
        end
      end
    end
  end
end
