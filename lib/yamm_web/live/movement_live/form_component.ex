defmodule YAMMWeb.MovementLive.FormComponent do
  use YAMMWeb, :live_component

  alias YAMM.Money

  @impl true
  def update(%{movement: movement} = assigns, socket) do
    changeset = Money.change_movement(movement)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"movement" => movement_params}, socket) do
    changeset =
      socket.assigns.movement
      |> Money.change_movement(movement_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"movement" => movement_params}, socket) do
    save_movement(socket, socket.assigns.action, movement_params)
  end

  defp save_movement(socket, :edit, movement_params) do
    case Money.update_movement(socket.assigns.movement, movement_params) do
      {:ok, _movement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movement updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_movement(socket, :new, movement_params) do
    case Money.create_movement(movement_params) do
      {:ok, _movement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movement created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
