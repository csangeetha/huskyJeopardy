defmodule JeopardyWeb.ClueControllerTest do
  use JeopardyWeb.ConnCase

  alias Jeopardy.Games
  alias Jeopardy.Games.Clue

  @create_attrs %{answer: "some answer", question: "some question", title: "some title", value: 42}
  @update_attrs %{answer: "some updated answer", question: "some updated question", title: "some updated title", value: 43}
  @invalid_attrs %{answer: nil, question: nil, title: nil, value: nil}

  def fixture(:clue) do
    {:ok, clue} = Games.create_clue(@create_attrs)
    clue
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clues", %{conn: conn} do
      conn = get conn, clue_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clue" do
    test "renders clue when data is valid", %{conn: conn} do
      conn = post conn, clue_path(conn, :create), clue: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, clue_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "answer" => "some answer",
        "question" => "some question",
        "title" => "some title",
        "value" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, clue_path(conn, :create), clue: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clue" do
    setup [:create_clue]

    test "renders clue when data is valid", %{conn: conn, clue: %Clue{id: id} = clue} do
      conn = put conn, clue_path(conn, :update, clue), clue: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, clue_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "answer" => "some updated answer",
        "question" => "some updated question",
        "title" => "some updated title",
        "value" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, clue: clue} do
      conn = put conn, clue_path(conn, :update, clue), clue: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clue" do
    setup [:create_clue]

    test "deletes chosen clue", %{conn: conn, clue: clue} do
      conn = delete conn, clue_path(conn, :delete, clue)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, clue_path(conn, :show, clue)
      end
    end
  end

  defp create_clue(_) do
    clue = fixture(:clue)
    {:ok, clue: clue}
  end
end
