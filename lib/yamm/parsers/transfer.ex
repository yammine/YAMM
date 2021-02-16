defmodule YAMM.Parsers.Transfer do
  import NimbleParsec

  def parse(input) do
    case transfer_info(input) do
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

  float =
    integer(min: 1)
    |> string(".")
    |> ascii_string([?0..?9], min: 1)
    |> reduce({Enum, :join, [""]})

  amount = choice([float, integer(min: 1)])

  defp to_result([amount, to]) do
    %{
      amount: amount,
      target: to
    }
  end

  # TODO: Find a fuzzier way to match on ignored sections
  defparsecp(
    :transfer_info,
    # This is YAMM bot's ID
    ignore(slack_user_id)
    |> ignore(string(" transfer "))
    # Amount being transferred
    |> concat(amount)
    |> ignore(string(" to "))
    # Target user ID for transfer
    |> concat(slack_user_id)
    # Everything after this is transfer annotation
    |> reduce({:to_result, []})
  )
end
