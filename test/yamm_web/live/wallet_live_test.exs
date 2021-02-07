defmodule YAMMWeb.WalletLiveTest do
  use YAMMWeb.ConnCase

  import Phoenix.LiveViewTest

  alias YAMM.Money

  @create_attrs %{balance: "120.5"}
  @update_attrs %{balance: "456.7"}
  @invalid_attrs %{balance: nil}

  defp fixture(:wallet) do
    {:ok, wallet} = Money.create_wallet(@create_attrs)
    wallet
  end

  defp create_wallet(_) do
    wallet = fixture(:wallet)
    %{wallet: wallet}
  end

  describe "Index" do
    setup [:create_wallet]

    test "lists all wallets", %{conn: conn, wallet: wallet} do
      {:ok, _index_live, html} = live(conn, Routes.wallet_index_path(conn, :index))

      assert html =~ "Listing Wallets"
    end

    test "saves new wallet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.wallet_index_path(conn, :index))

      assert index_live |> element("a", "New Wallet") |> render_click() =~
               "New Wallet"

      assert_patch(index_live, Routes.wallet_index_path(conn, :new))

      assert index_live
             |> form("#wallet-form", wallet: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#wallet-form", wallet: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.wallet_index_path(conn, :index))

      assert html =~ "Wallet created successfully"
    end

    test "updates wallet in listing", %{conn: conn, wallet: wallet} do
      {:ok, index_live, _html} = live(conn, Routes.wallet_index_path(conn, :index))

      assert index_live |> element("#wallet-#{wallet.id} a", "Edit") |> render_click() =~
               "Edit Wallet"

      assert_patch(index_live, Routes.wallet_index_path(conn, :edit, wallet))

      assert index_live
             |> form("#wallet-form", wallet: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#wallet-form", wallet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.wallet_index_path(conn, :index))

      assert html =~ "Wallet updated successfully"
    end

    test "deletes wallet in listing", %{conn: conn, wallet: wallet} do
      {:ok, index_live, _html} = live(conn, Routes.wallet_index_path(conn, :index))

      assert index_live |> element("#wallet-#{wallet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#wallet-#{wallet.id}")
    end
  end

  describe "Show" do
    setup [:create_wallet]

    test "displays wallet", %{conn: conn, wallet: wallet} do
      {:ok, _show_live, html} = live(conn, Routes.wallet_show_path(conn, :show, wallet))

      assert html =~ "Show Wallet"
    end

    test "updates wallet within modal", %{conn: conn, wallet: wallet} do
      {:ok, show_live, _html} = live(conn, Routes.wallet_show_path(conn, :show, wallet))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Wallet"

      assert_patch(show_live, Routes.wallet_show_path(conn, :edit, wallet))

      assert show_live
             |> form("#wallet-form", wallet: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#wallet-form", wallet: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.wallet_show_path(conn, :show, wallet))

      assert html =~ "Wallet updated successfully"
    end
  end
end
