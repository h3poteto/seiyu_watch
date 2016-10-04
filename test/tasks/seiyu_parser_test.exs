defmodule SeiyuWatch.SeiyuParserTest do
  use SeiyuWatch.TaskCase

  import Mock
  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.SeiyuParser

  describe "#save" do
    test "should save seiyu" do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough], [get_response: fn(_request) -> response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) end] do
        assert SeiyuParser.save("阿澄佳奈") == {:ok, "阿澄佳奈"}
      end
    end
  end
end
