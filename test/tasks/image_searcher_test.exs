defmodule SeiyuWatch.ImageSearcherTest do
  use SeiyuWatch.TaskCase, async: false

  import Mock
  import SeiyuWatch.GoogleResponseHelpers

  def seiyu(), do: Repo.insert!(%SeiyuWatch.Seiyu{name: "阿澄佳奈"})

  setup do
    {:ok, seiyu: seiyu()}
  end

  describe "#save_image" do
    test "search and save image", %{seiyu: seiyu} do
      with_mocks([
        {SeiyuWatch.Workers.ImageSearcher, [:passthrough], [upload: fn _file, _seiyu -> :ok end]},
        {SeiyuWatch.GoogleResponse, [:passthrough], [get_response: fn _request -> response() end]}
      ]) do
        assert SeiyuWatch.Workers.ImageSearcher.save_image(seiyu.id) == :ok
      end
    end
  end
end
