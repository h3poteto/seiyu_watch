defmodule SeiyuWatch.AddSeiyuTest do
  use SeiyuWatch.TaskCase

  import Mock
  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.Workers.AddSeiyu

  describe "#save" do
    test "should save seiyu" do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough],
        get_response: fn _request ->
          response_category(%{
            page_id: 1_543_998,
            fullurl: "http://example.com",
            revision_id: 1,
            revision_hash: "hoge"
          })
        end do
        res = AddSeiyu.save("阿澄佳奈")
        assert res != {:failed, "阿澄佳奈"}
        assert Repo.get_by(SeiyuWatch.Seiyu, %{name: "阿澄佳奈"})
      end
    end
  end
end
