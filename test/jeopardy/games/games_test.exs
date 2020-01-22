defmodule Jeopardy.GamesTest do
  use Jeopardy.DataCase

  alias Jeopardy.Games

  describe "games" do
    alias Jeopardy.Games.Game

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(@valid_attrs)
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "categories" do
    alias Jeopardy.Games.Category

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Games.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Games.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Games.create_category(@valid_attrs)
      assert category.title == "some title"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Games.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.title == "some updated title"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_category(category, @invalid_attrs)
      assert category == Games.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Games.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Games.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Games.change_category(category)
    end
  end

  describe "clues" do
    alias Jeopardy.Games.Clue

    @valid_attrs %{answer: "some answer", question: "some question", title: "some title", value: 42}
    @update_attrs %{answer: "some updated answer", question: "some updated question", title: "some updated title", value: 43}
    @invalid_attrs %{answer: nil, question: nil, title: nil, value: nil}

    def clue_fixture(attrs \\ %{}) do
      {:ok, clue} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_clue()

      clue
    end

    test "list_clues/0 returns all clues" do
      clue = clue_fixture()
      assert Games.list_clues() == [clue]
    end

    test "get_clue!/1 returns the clue with given id" do
      clue = clue_fixture()
      assert Games.get_clue!(clue.id) == clue
    end

    test "create_clue/1 with valid data creates a clue" do
      assert {:ok, %Clue{} = clue} = Games.create_clue(@valid_attrs)
      assert clue.answer == "some answer"
      assert clue.question == "some question"
      assert clue.title == "some title"
      assert clue.value == 42
    end

    test "create_clue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_clue(@invalid_attrs)
    end

    test "update_clue/2 with valid data updates the clue" do
      clue = clue_fixture()
      assert {:ok, clue} = Games.update_clue(clue, @update_attrs)
      assert %Clue{} = clue
      assert clue.answer == "some updated answer"
      assert clue.question == "some updated question"
      assert clue.title == "some updated title"
      assert clue.value == 43
    end

    test "update_clue/2 with invalid data returns error changeset" do
      clue = clue_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_clue(clue, @invalid_attrs)
      assert clue == Games.get_clue!(clue.id)
    end

    test "delete_clue/1 deletes the clue" do
      clue = clue_fixture()
      assert {:ok, %Clue{}} = Games.delete_clue(clue)
      assert_raise Ecto.NoResultsError, fn -> Games.get_clue!(clue.id) end
    end

    test "change_clue/1 returns a clue changeset" do
      clue = clue_fixture()
      assert %Ecto.Changeset{} = Games.change_clue(clue)
    end
  end

  describe "category_items" do
    alias Jeopardy.Games.Category_Item

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def category__item_fixture(attrs \\ %{}) do
      {:ok, category__item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_category__item()

      category__item
    end

    test "list_category_items/0 returns all category_items" do
      category__item = category__item_fixture()
      assert Games.list_category_items() == [category__item]
    end

    test "get_category__item!/1 returns the category__item with given id" do
      category__item = category__item_fixture()
      assert Games.get_category__item!(category__item.id) == category__item
    end

    test "create_category__item/1 with valid data creates a category__item" do
      assert {:ok, %Category_Item{} = category__item} = Games.create_category__item(@valid_attrs)
    end

    test "create_category__item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_category__item(@invalid_attrs)
    end

    test "update_category__item/2 with valid data updates the category__item" do
      category__item = category__item_fixture()
      assert {:ok, category__item} = Games.update_category__item(category__item, @update_attrs)
      assert %Category_Item{} = category__item
    end

    test "update_category__item/2 with invalid data returns error changeset" do
      category__item = category__item_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_category__item(category__item, @invalid_attrs)
      assert category__item == Games.get_category__item!(category__item.id)
    end

    test "delete_category__item/1 deletes the category__item" do
      category__item = category__item_fixture()
      assert {:ok, %Category_Item{}} = Games.delete_category__item(category__item)
      assert_raise Ecto.NoResultsError, fn -> Games.get_category__item!(category__item.id) end
    end

    test "change_category__item/1 returns a category__item changeset" do
      category__item = category__item_fixture()
      assert %Ecto.Changeset{} = Games.change_category__item(category__item)
    end
  end
end
