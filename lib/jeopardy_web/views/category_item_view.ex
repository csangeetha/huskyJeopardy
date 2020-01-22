defmodule JeopardyWeb.CategoryItemView do
  use JeopardyWeb, :view
  alias JeopardyWeb.CategoryItemView

  def render("index.json", %{category_items: category_items}) do
    %{data: render_many(category_items, CategoryItemView, "category_item.json")}
  end

  def render("show.json", %{category_item: category_item}) do
    %{data: render_one(category_item, CategoryItemView, "category_item.json")}
  end

  def render("category_item.json", %{category_item: category_item}) do
    %{id: category_item.id}
  end
end
