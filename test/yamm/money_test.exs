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

  describe "movements" do
    alias YAMM.Money.Movement

    @valid_attrs %{amount: "120.5", hash: "some hash"}
    @update_attrs %{amount: "456.7", hash: "some updated hash"}
    @invalid_attrs %{amount: nil, hash: nil}

    def movement_fixture(attrs \\ %{}) do
      {:ok, movement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Money.create_movement()

      movement
    end

    test "list_movements/0 returns all movements" do
      movement = movement_fixture()
      assert Money.list_movements() == [movement]
    end

    test "get_movement!/1 returns the movement with given id" do
      movement = movement_fixture()
      assert Money.get_movement!(movement.id) == movement
    end

    test "create_movement/1 with valid data creates a movement" do
      assert {:ok, %Movement{} = movement} = Money.create_movement(@valid_attrs)
      assert movement.amount == Decimal.new("120.5")
      assert movement.hash == "some hash"
    end

    test "create_movement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_movement(@invalid_attrs)
    end

    test "update_movement/2 with valid data updates the movement" do
      movement = movement_fixture()
      assert {:ok, %Movement{} = movement} = Money.update_movement(movement, @update_attrs)
      assert movement.amount == Decimal.new("456.7")
      assert movement.hash == "some updated hash"
    end

    test "update_movement/2 with invalid data returns error changeset" do
      movement = movement_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_movement(movement, @invalid_attrs)
      assert movement == Money.get_movement!(movement.id)
    end

    test "delete_movement/1 deletes the movement" do
      movement = movement_fixture()
      assert {:ok, %Movement{}} = Money.delete_movement(movement)
      assert_raise Ecto.NoResultsError, fn -> Money.get_movement!(movement.id) end
    end

    test "change_movement/1 returns a movement changeset" do
      movement = movement_fixture()
      assert %Ecto.Changeset{} = Money.change_movement(movement)
    end
  end
end
