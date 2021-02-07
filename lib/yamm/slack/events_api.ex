defmodule YAMM.Slack.EventsAPI do
  def process(event) do
    IO.inspect(event)
    type = get_in(event, ["payload", "event", "type"])
    channel = get_in(event, ["payload", "event", "channel"])

    ts =
      get_in(event, ["payload", "event", "thread_ts"]) ||
        get_in(event, ["payload", "event", "ts"])

    token = Application.get_env(:slack, :web_token)

    case type do
      "app_mention" ->
        Mojito.request(
          :post,
          "https://slack.com/api/chat.postMessage",
          [
            {"Content-type", "application/json"},
            {"Authorization", "Bearer #{token}"}
          ],
          Jason.encode!(%{
            channel: channel,
            text: "eyyyyyy",
            thread_ts: ts,
            icon_emoji: ":sweet_potato:"
          })
        )

      _ ->
        nil
    end

    :ok
  end
end
