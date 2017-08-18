defmodule SeiyuWatchWeb.Router do
  use SeiyuWatchWeb, :router

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

  scope "/", SeiyuWatchWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/seiyus", SeiyuController, only: [:index, :show, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SeiyuWatch do
  #   pipe_through :api
  # end
end
