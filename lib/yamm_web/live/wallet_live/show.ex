defmodule YAMMWeb.WalletLive.Show do
  use YAMMWeb, :live_view

  alias YAMM.Money

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:wallet, Money.get_wallet!(id))}
  end

  defp page_title(:show), do: "Show Wallet"
  defp page_title(:edit), do: "Edit Wallet"
end
