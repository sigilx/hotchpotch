defmodule HotchpotchWeb.Router do
  use HotchpotchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HotchpotchWeb.Auth, repo: Hotchpotch.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HotchpotchWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController
    resources "/boards", BoardController

    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", Hotchpotch do
  #   pipe_through :api
  # end
end
