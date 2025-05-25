defmodule SeiyuWatch.GoogleResponseTest do
  use SeiyuWatch.TaskCase

  import SeiyuWatch.GoogleResponseHelpers
  alias SeiyuWatch.GoogleResponse

  describe "#parse_images" do
    test "response has images" do
      assert response() |> GoogleResponse.parse_images() |> Enum.count() == 2
    end
  end
end
