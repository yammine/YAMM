defmodule YAMM.Parsers.Balances do
  import NimbleParsec

  def parse(input) do
    case parse_balance_for(input) do
      {:ok, [result], _, _, _, _} ->
        {:ok, result}

      error ->
        # TODO: Properly return this later
        {:error, error}
    end
  end

  slack_user_id =
    ignore(string("<@"))
    |> ascii_string([?A..?Z, ?0..?9], min: 1)
    |> ignore(string(">"))

  defp to_result([target]) do
    %{target: target}
  end

  defparsecp(
    :parse_balance_for,
    ignore(slack_user_id)
    |> ignore(string(" balance for "))
    |> concat(slack_user_id)
    |> reduce({:to_result, []})
  )
end
