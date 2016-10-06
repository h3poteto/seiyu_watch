defmodule SeiyuWatch.WikipediaResponseHelpers do
  def response_category(%{page_id: page_id, fullurl: fullurl, revision_id: revision_id, revision_hash: revision_hash}) do
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
                                    "fullurl" => fullurl,
                                    "lastrevid" => 61356931, "length" => 158534, "ns" => 0,
                                    "pageid" => page_id, "pagelanguage" => "ja", "pagelanguagedir" => "ltr",
                                    "pagelanguagehtmlcode" => "ja",
                                    "revisions" => [
                                      %{"parentid" => 61347109,
                                        "revid" => revision_id,
                                        "sha1" => revision_hash}
                                    ],
                                    "title" => "阿澄佳奈",
                                    "touched" => "2016-10-02T12:51:51Z"
                                   }
                    }
      }
    }
  end

  def response_diff(%{diff: diff, from: from, to: to}) do
    %{"batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"ns" => 0,
                                    "pageid" => 1543998,
                                    "revisions" => [
                                      %{"diff" => %{
                                       "*" => diff,
                                       "from" => from,
                                       "to" => to
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

  def response_content(%{content: content}) do
    %{"batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"ns" => 0,
                                    "pageid" => 1543998,
                                    "revisions" => [
                                      %{"*" => content,
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

  def response_page(%{revid: revid}) do
    %{"batchcomplete" => "",
      "query" => %{
        "pages" => %{"1543998" => %{"ns" => 0,
                                    "pageid" => 1543998,
                                    "revisions" => [
                                      %{"parentid" => 61347109,
                                        "revid" => revid,
                                        "sha1" => "5a4ef6d81f07fc729910e02251a4daf89628cd45"}
                                    ],
                                    "title" => "阿澄佳奈"
                                   }
                    }
      }
    }
  end
end
