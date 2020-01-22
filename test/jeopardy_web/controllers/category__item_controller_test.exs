defmodule JeopardyWeb.Category_ItemControllerTest do
  use JeopardyWeb.ConnCase

  alias Jeopardy.Games
  alias Jeopardy.Games.Category_Item

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:category__item) do
    {:ok, category__item} = Games.create_category__item(@create_attrs)
    category__item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all category_items", %{conn: conn} do
      conn = get conn, category__item_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create category__item" do
    test "renders category__item when data is valid", %{conn: conn} do
      conn = post conn, category__item_path(conn, :create), category__item: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, category__item_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, category__item_path(conn, :create), category__item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update category__item" do
    setup [:create_category__item]

    test "renders category__item when data is valid", %{conn: conn, category__item: %Category_Item{id: id} = category__item} do
      conn = put conn, category__item_path(conn, :update, category__item), category__item: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, category__item_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, category__item: category__item} do
      conn = put conn, category__item_path(conn, :update, category__item), category__item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete category__item" do
    setup [:create_category__item]

    test "deletes chosen category__item", %{conn: conn, category__item: category__item} do
      conn = delete conn, category__item_path(conn, :delete, category__item)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, category__item_path(conn, :show, category__item)
      end
    end
  end

  defp create_category__item(_) do
    category__item = fixture(:category__item)
    {:ok, category__item: category__item}
  end
end
