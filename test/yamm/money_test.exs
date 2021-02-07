defmodule YAMM.MoneyTest do
  use YAMM.DataCase

  alias YAMM.Money

  describe "users" do
    alias YAMM.Money.User

    @valid_attrs %{slack_user_id: "some slack_user_id"}
    @update_attrs %{slack_user_id: "some updated slack_user_id"}
    @invalid_attrs %{slack_user_id: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Money.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Money.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Money.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Money.create_user(@valid_attrs)
      assert user.slack_user_id == "some slack_user_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Money.update_user(user, @update_attrs)
      assert user.slack_user_id == "some updated slack_user_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_user(user, @invalid_attrs)
      assert user == Money.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Money.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Money.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Money.change_user(user)
    end
  end

  describe "wallets" do
    alias YAMM.Money.Wallet

    @valid_attrs %{balance: "120.5"}
    @update_attrs %{balance: "456.7"}
    @invalid_attrs %{balance: nil}

    def wallet_fixture(attrs \\ %{}) do
      {:ok, wallet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Money.create_wallet()

      wallet
    end

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Money.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Money.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      assert {:ok, %Wallet{} = wallet} = Money.create_wallet(@valid_attrs)
      assert wallet.balance == Decimal.new("120.5")
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{} = wallet} = Money.update_wallet(wallet, @update_attrs)
      assert wallet.balance == Decimal.new("456.7")
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_wallet(wallet, @invalid_attrs)
      assert wallet == Money.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Money.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Money.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Money.change_wallet(wallet)
    end
  end
end
