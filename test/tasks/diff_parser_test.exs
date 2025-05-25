defmodule SeiyuWatch.DiffParserTest do
  use SeiyuWatch.TaskCase

  import Mock
  import SeiyuWatch.WikipediaResponseHelpers
  alias SeiyuWatch.Workers.DiffParser

  def seiyu(), do: Repo.insert!(%SeiyuWatch.Seiyu{name: "阿澄佳奈"})

  describe "#wiki_page_request" do
    setup do
      {:ok, seiyu: seiyu()}
    end

    test "get request does not have reivision hash when seiyu has no differences", %{seiyu: seiyu} do
      assert SeiyuWatch.Seiyu
             |> Repo.get!(seiyu.id)
             |> Repo.preload(:differences)
             |> DiffParser.wikipedia_page_request() =~ "rvdiffto=prev"
    end

    test "get request has revision hash when seiyu has differences", %{seiyu: seiyu} do
      with_mock SeiyuWatch.WikipediaResponse, [:passthrough],
        get_response: fn _request -> response_page(%{revid: 345_678}) end do
        {:ok, prev_diff} =
          seiyu
          |> Ecto.build_assoc(:differences)
          |> SeiyuWatch.Difference.changeset(%{
            wiki_diff: "some diff",
            from: 123_456,
            to: 234_567
          })
          |> Repo.insert()

        differences =
          SeiyuWatch.Seiyu
          |> Repo.get!(seiyu.id)
          |> Repo.preload(:differences)

        refute differences
               |> DiffParser.wikipedia_page_request() =~ "rvdiffto=prev"

        assert differences
               |> DiffParser.wikipedia_page_request() =~ "rvstartid=#{prev_diff.to}"

        assert differences
               |> DiffParser.wikipedia_page_request() =~ "rvendid=#{prev_diff.to}"
      end
    end
  end

  describe "#update_diff" do
    setup do
      seiyu = seiyu() |> Repo.preload(:differences)
      current_revision_request = DiffParser.wikipedia_current_revision_request(seiyu.wiki_page_id)
      page_request = DiffParser.wikipedia_page_request(seiyu)

      %{
        seiyu: seiyu,
        current_revision_request: current_revision_request,
        page_request: page_request
      }
    end

    test "when seiyu has no differences", %{
      seiyu: seiyu,
      current_revision_request: current_revision_request,
      page_request: page_request
    } do
      with_mocks([
        {SeiyuWatch.WikipediaResponse, [:passthrough],
         [
           get_response: fn ^current_revision_request -> response_page(%{revid: 345_678}) end,
           get_response: fn ^page_request ->
             response_diff(%{diff: "some diff", from: 234_567, to: 345_678})
           end
         ]}
      ]) do
        {res, _} = DiffParser.update_diff(seiyu.id, -7)
        assert res == :ok
      end
    end
  end
end
