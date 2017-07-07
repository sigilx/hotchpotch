defmodule Hotchpotch.Router do
  use Hotchpotch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Hotchpotch.Auth, repo: Hotchpotch.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Hotchpotch do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController
    resources "/boards", BoardController

    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hotchpotch do
  #   pipe_through :api
  # end
end
