defmodule SeiyuWatch.GoogleResponseHelpers do
  def response() do
    %{"context" => %{"title" => "Google"},
      "items" => [
        %{"displayLink" => "matome.naver.jp",
          "htmlSnippet" => "【声優】<b>阿澄佳奈</b>が演じたアニメ ...",
          "htmlTitle" => "声優】<b>阿澄佳奈</b>が演じたアニメキャラまとめ - NAVER まとめ",
          "image" => %{"byteSize" => 102894,
                       "contextLink" => "http://matome.naver.jp/odai/2138975335789336401",
                       "height" => 1272, "thumbnailHeight" => 150,
                       "thumbnailLink" => "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTzJd9MPnaimqpXnJ39kNx0kOZXdDYbNVnKn5AxyvEDd5mQAidH3s_FFSg",
                       "thumbnailWidth" => 110, "width" => 935},
          "kind" => "customsearch#result",
          "link" => "https://www.81produce.co.jp/dcms_media/image/asumi_kana.jpg",
          "mime" => "image/jpeg",
          "snippet" => "【声優】阿澄佳奈が演じたアニメ ...",
          "title" => "声優】阿澄佳奈が演じたアニメキャラまとめ - NAVER まとめ"},
        %{"displayLink" => "laughy.jp",
          "htmlSnippet" => "ラジオでも活躍する<b>阿澄佳奈</b>さん",
          "htmlTitle" => "妊娠】まだまだ新婚と言える<b>阿澄佳奈</b>だが、妊娠は？との声が多いのは ...",
          "image" => %{"byteSize" => 53309,
                       "contextLink" => "http://laughy.jp/1434093980911111649", "height" => 640,
                       "thumbnailHeight" => 137,
                       "thumbnailLink" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg6VUHzfEIv5hB5b6NAs_fntgG-eQhZEJIh6eL7ObrqA1oJ-TmJiyB4TUJ3A",
                       "thumbnailWidth" => 137, "width" => 640},
          "kind" => "customsearch#result",
          "link" => "http://img.laughy.jp/15772/default_eea4b03ca7e12a0376d2cd7f4add280a.jpg",
          "mime" => "image/jpeg",
          "snippet" => "ラジオでも活躍する阿澄佳奈さん",
          "title" => "妊娠】まだまだ新婚と言える阿澄佳奈だが、妊娠は？との声が多いのは ..."},
      ],
      "kind" => "customsearch#search",
      "queries" => %{
        "nextPage" => [
        %{"count" => 10,
          "cx" => "000136758670674945236:favbsqfd6_0", "inputEncoding" => "utf8",
          "outputEncoding" => "utf8", "safe" => "off",
          "searchTerms" => "阿澄佳奈", "searchType" => "image",
          "startIndex" => 11, "title" => "Google Custom Search - 阿澄佳奈",
          "totalResults" => "932000"}],
        "request" => [
          %{"count" => 10, "cx" => "000136758670674945236:favbsqfd6_0",
            "inputEncoding" => "utf8", "outputEncoding" => "utf8", "safe" => "off",
            "searchTerms" => "阿澄佳奈", "searchType" => "image",
            "startIndex" => 1, "title" => "Google Custom Search - 阿澄佳奈",
            "totalResults" => "932000"}]},
      "searchInformation" => %{
        "formattedSearchTime" => "0.40",
        "formattedTotalResults" => "932,000", "searchTime" => 0.397124,
        "totalResults" => "932000"},
      "url" => %{
        "template" => "https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&cref={cref?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json",
        "type" => "application/json"}}
  end
end
