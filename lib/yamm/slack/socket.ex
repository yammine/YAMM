defmodule YAMM.Slack.Socket do
  use WebSockex

  def start_link(opts \\ []) do
    options = Keyword.merge([name: __MODULE__], opts)

    url = YAMM.Slack.get_connect_ws(Application.get_env(:slack, :app_token))

    WebSockex.start_link(url, __MODULE__, [], options)
  end

  def handle_frame({:text, msg}, state) do
    {:ok, decoded} = Jason.decode(msg)

    msg_type = Map.get(decoded, "type")

    case msg_type do
      "events_api" ->
        # We have to ack things from the Events API
        :ok = YAMM.Slack.EventsAPI.process(decoded)
        {:ok, reply} = Jason.encode(%{"envelope_id" => Map.get(decoded, "envelope_id")})
        {:reply, {:text, reply}, state}

      # The first message after connecting. No need to ack / reply
      "hello" ->
        {:ok, state}

      "disconnect" ->
        {:close, state}
    end
  end
end
