defmodule YAMMWeb.WalletLive.FormComponent do
  use YAMMWeb, :live_component

  alias YAMM.Money

  @impl true
  def update(%{wallet: wallet} = assigns, socket) do
    changeset = Money.change_wallet(wallet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"wallet" => wallet_params}, socket) do
    changeset =
      socket.assigns.wallet
      |> Money.change_wallet(wallet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"wallet" => wallet_params}, socket) do
    save_wallet(socket, socket.assigns.action, wallet_params)
  end

  defp save_wallet(socket, :edit, wallet_params) do
    case Money.update_wallet(socket.assigns.wallet, wallet_params) do
      {:ok, _wallet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wallet updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_wallet(socket, :new, wallet_params) do
    case Money.create_wallet(wallet_params) do
      {:ok, _wallet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wallet created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
