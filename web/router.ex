defmodule SeiyuWatch.Router do
  use SeiyuWatch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SeiyuWatch do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/seiyus", SeiyuController, only: [:index, :new, :create, :delete]
    resources "/seiyu_appearances", SeiyuAppearanceController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SeiyuWatch do
  #   pipe_through :api
  # end
end
