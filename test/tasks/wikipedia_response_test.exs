defmodule SeiyuWatch.WikipediaResponseTest do
  use SeiyuWatch.TaskCase

  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.WikipediaResponse

  describe "#parse_categories" do
    test "response has categories" do
      assert response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) |> WikipediaResponse.parse_categories
    end
  end

  describe "#find_seiyu_category" do
    test "response has seiyu category" do
      assert response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) |> WikipediaResponse.parse_categories |> WikipediaResponse.find_seiyu_category
    end

    test "response do not have seiyu category" do
      category = [
        %{"ns" => 1, "title" => "category1"},
        %{"ns" => 2, "title" => "category2"}
      ]
      refute category |> WikipediaResponse.find_seiyu_category
    end
  end

  describe "#page_id" do
    test "response has page_id" do
      assert response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: 1, revision_hash: "hoge"}) |> WikipediaResponse.page_id == 1543998
    end
  end

  describe "#url" do
    test "response has wikipedia page url" do
      fullurl = "https://ja.wikipedia.org/wiki/%E9%98%BF%E6%BE%84%E4%BD%B3%E5%A5%88"
      assert response_category(%{page_id: 1543998, fullurl: fullurl, revision_id: 1, revision_hash: "hoge"}) |> WikipediaResponse.url == fullurl
    end
  end

  describe "#revision_id" do
    test "response has revision_id" do
      revision_id = 61356931
      revision_hash = "5a4ef6d81f07fc729910e02251a4daf89628cd45"
      assert response_category(%{page_id: 1543998, fullurl: "http://example.com", revision_id: revision_id, revision_hash: revision_hash}) |> WikipediaResponse.revision_id == {revision_id, revision_hash}
    end
  end

  describe "#parse_diff" do
    test "response has diff" do
      diff = "diff"
      from = 61096294
      to = 61114635
      assert response_diff(%{diff: diff, from: from, to: to}) |> WikipediaResponse.parse_diff == {:ok, diff, from, to}
    end
  end

  describe "#parse_content" do
    test "response has content" do
      content = "<table></table>"
      assert response_content(%{content: content}) |> WikipediaResponse.parse_content == content
    end
  end
end
