defmodule YAMM.Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts("Connected to Slack!")
    IO.inspect(slack)
    IO.inspect(state)
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    if message.text == "Hi" do
      send_message("Hello to you too!", message.channel, slack)
    end

    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info(msg, slack, state) do
    IO.puts(msg)
    IO.puts(slack)
    IO.puts(state)
    {:ok, state}
  end
end
