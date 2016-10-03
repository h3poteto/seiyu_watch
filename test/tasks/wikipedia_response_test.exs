defmodule SeiyuWatch.WikipediaResponseTest do
  use SeiyuWatch.TaskCase

  alias SeiyuWatch.WikipediaResponse

  def response_category() do
    %{
      "batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"canonicalurl" => "https://ja.wikipedia.org/wiki/%E9%98%BF%E6%BE%84%E4%BD%B3%E5%A5%88",
                                    "categories" => [
                                      %{"ns" => 14, "title" => "Category:1983年生"},
                                      %{"ns" => 14, "title" => "Category:81プロデュース"},
                                      %{"ns" => 14,
                                        "title" => "Category:出典を必要とする記事/2015年2月"},
                                      %{"ns" => 14,
                                        "title" => "Category:出典を必要とする記述のある記事/2015年12月"},
                                      %{"ns" => 14,
                                        "title" => "Category:出典を必要とする記述のある記事/2015年6月"},
                                      %{"ns" => 14, "title" => "Category:存命人物"},
                                      %{"ns" => 14, "title" => "Category:日本の女性声優"},
                                      %{"ns" => 14, "title" => "Category:注意がある記事 (声優)"},
                                      %{"ns" => 14, "title" => "Category:福岡県出身の人物"}
                                    ],
                                    "contentmodel" => "wikitext",
                                    "editurl" => "https://ja.wikipedia.org/w/index.php?title=%E9%98%BF%E6%BE%84%E4%BD%B3%E5%A5%88&action=edit",
                                    "fullurl" => "https://ja.wikipedia.org/wiki/%E9%98%BF%E6%BE%84%E4%BD%B3%E5%A5%88",
                                    "lastrevid" => 61356931, "length" => 158534, "ns" => 0,
                                    "pageid" => 1543998, "pagelanguage" => "ja", "pagelanguagedir" => "ltr",
                                    "pagelanguagehtmlcode" => "ja",
                                    "revisions" => [
                                      %{"parentid" => 61347109,
                                        "revid" => 61356931,
                                        "sha1" => "5a4ef6d81f07fc729910e02251a4daf89628cd45"}
                                    ],
                                    "title" => "阿澄佳奈",
                                    "touched" => "2016-10-02T12:51:51Z"
                                   }
                    }
      }
    }
  end

  def response_diff() do
    %{"batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"ns" => 0,
                                    "pageid" => 1543998,
                                    "revisions" => [
                                      %{"diff" => %{
                                       "*" => "diff",
                                       "from" => 61096294,
                                       "to" => 61114635
                                     },
                                        "parentid" => 61018586,
                                        "revid" => 61096294,
                                        "sha1" => "69f33b2dc152d96c1dab5d3998a70ea1435d9823"
                                       }
                                    ],
                                    "title" => "阿澄佳奈"
                                   }
                    }
      }
    }
  end

  def response_content() do
    %{"batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"ns" => 0,
                                    "pageid" => 1543998,
                                    "revisions" => [
                                      %{"*" => "<table></table>",
                                        "parentid" => 61347109,
                                        "revid" => 61356931,
                                        "sha1" => "5a4ef6d81f07fc729910e02251a4daf89628cd45"
                                       }
                                    ],
                                    "title" => "阿澄佳奈"
                                   }
                    }
      }
    }
  end

  describe "#parse_categories" do
    test "response has categories" do
      assert response_category() |> WikipediaResponse.parse_categories
    end
  end

  describe "#find_seiyu_category" do
    test "response has seiyu category" do
      assert response_category() |> WikipediaResponse.parse_categories |> WikipediaResponse.find_seiyu_category
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
      assert response_category() |> WikipediaResponse.page_id == 1543998
    end
  end

  describe "#url" do
    test "response has wikipedia page url" do
      assert response_category() |> WikipediaResponse.url == "https://ja.wikipedia.org/wiki/%E9%98%BF%E6%BE%84%E4%BD%B3%E5%A5%88"
    end
  end

  describe "#revision_id" do
    test "response has revision_id" do
      assert response_category() |> WikipediaResponse.revision_id == {61356931, "5a4ef6d81f07fc729910e02251a4daf89628cd45"}
    end
  end

  describe "#parse_diff" do
    test "response has diff" do
      assert response_diff() |> WikipediaResponse.parse_diff == {:ok, "diff", 61096294, 61114635}
    end
  end

  describe "#parse_content" do
    test "response has content" do
      assert response_content() |> WikipediaResponse.parse_content == "<table></table>"
    end
  end
end
