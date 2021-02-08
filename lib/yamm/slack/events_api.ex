defmodule YAMM.Slack.EventsAPI do
  alias YAMM.Money.User

  @token Application.get_env(:slack, :web_token)

  def process(event) do
    context = extract_context(event)

    case context.type do
      "app_mention" ->
        process_app_mention(event, context)

      _ ->
        nil
    end

    :ok
  end

  def process_app_mention(_event, context) do
    user = fetch_internal_user(context.user)

    reply =
      case parse_text(context.text) do
        :balance_request ->
          balance =
            user
            |> YAMM.Money.get_balances()
            |> Enum.reduce(Decimal.new(0), fn wallet, acc ->
              Decimal.add(acc, wallet.balance)
            end)

          "Your total balance is: #{balance}"

        :grant_credit ->
          YAMM.Money.credit_user(user, Decimal.new("1.0"))
          "You've been granted 1.0 $YAMM!"

        :generic_reply ->
          "Hey what's up? This is my generic reply."
      end

    post_message(reply, context)
  end

  defp parse_text(text) do
    cond do
      String.contains?(text, "my balance") ->
        :balance_request

      String.contains?(text, "give me money") ->
        :grant_credit

      true ->
        :generic_reply
    end
  end

  defp post_message(text, context) do
    Mojito.request(
      :post,
      "https://slack.com/api/chat.postMessage",
      [
        {"Content-type", "application/json"},
        {"Authorization", "Bearer #{@token}"}
      ],
      Jason.encode!(%{
        channel: context.channel,
        text: text,
        thread_ts: context.ts
      })
    )
  end

  defp fetch_internal_user(slack_user_id) do
    case YAMM.Money.get_user_by_slack_id(slack_user_id) do
      %User{} = fetched ->
        fetched

      nil ->
        {:ok, %{user: created}} = YAMM.Money.create_user(%{slack_user_id: slack_user_id})
        created
    end
  end

  defp extract_context(event) do
    %{
      type: get_in(event, ["payload", "event", "type"]),
      channel: get_in(event, ["payload", "event", "channel"]),
      user: get_in(event, ["payload", "event", "user"]),
      text: get_in(event, ["payload", "event", "text"]),
      ts:
        get_in(event, ["payload", "event", "thread_ts"]) ||
          get_in(event, ["payload", "event", "ts"])
    }
  end
end
