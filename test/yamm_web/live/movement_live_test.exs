defmodule YAMMWeb.MovementLiveTest do
  use YAMMWeb.ConnCase

  import Phoenix.LiveViewTest

  alias YAMM.Money

  @create_attrs %{amount: "120.5", hash: "some hash"}
  @update_attrs %{amount: "456.7", hash: "some updated hash"}
  @invalid_attrs %{amount: nil, hash: nil}

  defp fixture(:movement) do
    {:ok, movement} = Money.create_movement(@create_attrs)
    movement
  end

  defp create_movement(_) do
    movement = fixture(:movement)
    %{movement: movement}
  end

  describe "Index" do
    setup [:create_movement]

    test "lists all movements", %{conn: conn, movement: movement} do
      {:ok, _index_live, html} = live(conn, Routes.movement_index_path(conn, :index))

      assert html =~ "Listing Movements"
      assert html =~ movement.hash
    end

    test "saves new movement", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.movement_index_path(conn, :index))

      assert index_live |> element("a", "New Movement") |> render_click() =~
               "New Movement"

      assert_patch(index_live, Routes.movement_index_path(conn, :new))

      assert index_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#movement-form", movement: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movement_index_path(conn, :index))

      assert html =~ "Movement created successfully"
      assert html =~ "some hash"
    end

    test "updates movement in listing", %{conn: conn, movement: movement} do
      {:ok, index_live, _html} = live(conn, Routes.movement_index_path(conn, :index))

      assert index_live |> element("#movement-#{movement.id} a", "Edit") |> render_click() =~
               "Edit Movement"

      assert_patch(index_live, Routes.movement_index_path(conn, :edit, movement))

      assert index_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#movement-form", movement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movement_index_path(conn, :index))

      assert html =~ "Movement updated successfully"
      assert html =~ "some updated hash"
    end

    test "deletes movement in listing", %{conn: conn, movement: movement} do
      {:ok, index_live, _html} = live(conn, Routes.movement_index_path(conn, :index))

      assert index_live |> element("#movement-#{movement.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#movement-#{movement.id}")
    end
  end

  describe "Show" do
    setup [:create_movement]

    test "displays movement", %{conn: conn, movement: movement} do
      {:ok, _show_live, html} = live(conn, Routes.movement_show_path(conn, :show, movement))

      assert html =~ "Show Movement"
      assert html =~ movement.hash
    end

    test "updates movement within modal", %{conn: conn, movement: movement} do
      {:ok, show_live, _html} = live(conn, Routes.movement_show_path(conn, :show, movement))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Movement"

      assert_patch(show_live, Routes.movement_show_path(conn, :edit, movement))

      assert show_live
             |> form("#movement-form", movement: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#movement-form", movement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.movement_show_path(conn, :show, movement))

      assert html =~ "Movement updated successfully"
      assert html =~ "some updated hash"
    end
  end
end
