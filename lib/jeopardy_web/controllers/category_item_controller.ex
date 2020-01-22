defmodule JeopardyWeb.CategoryItemController do
  use JeopardyWeb, :controller

  alias Jeopardy.Games
  alias Jeopardy.Games.CategoryItem

  action_fallback JeopardyWeb.FallbackController

  def index(conn, _params) do
    category_items = Games.list_category_items()
    render(conn, "index.json", category_items: category_items)
  end

  def create(conn, %{"category__item" => category_item_params}) do
    with {:ok, %CategoryItem{} = category_item} <- Games.create_category_item(category_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", category_item_path(conn, :show, category_item))
      |> render("show.json", category_item: category_item)
    end
  end

  def show(conn, %{"id" => id}) do
    category_item = Games.get_category_item!(id)
    render(conn, "show.json", category_item: category_item)
  end

  def update(conn, %{"id" => id, "category_item" => category_item_params}) do
    category_item = Games.get_category_item!(id)

    with {:ok, %CategoryItem{} = category_item} <- Games.update_category_item(category_item, category_item_params) do
      render(conn, "show.json", category_item: category_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    category_item = Games.get_category_item!(id)
    with {:ok, %CategoryItem{}} <- Games.delete_category_item(category_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
