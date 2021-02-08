defmodule YAMMWeb.MovementLive.Index do
  use YAMMWeb, :live_view

  alias YAMM.Money
  alias YAMM.Money.Movement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :movements, list_movements())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Movement")
    |> assign(:movement, Money.get_movement!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Movement")
    |> assign(:movement, %Movement{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Movements")
    |> assign(:movement, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    movement = Money.get_movement!(id)
    {:ok, _} = Money.delete_movement(movement)

    {:noreply, assign(socket, :movements, list_movements())}
  end

  defp list_movements do
    Money.list_movements()
  end
end
