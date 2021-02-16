defmodule YAMM.Slack do
  def get_connect_ws(token) do
    {:ok, response} =
      Mojito.request(
        :post,
        "https://slack.com/api/apps.connections.open",
        [
          {"Content-type", "application/x-www-form-urlencoded"},
          {"Authorization", "Bearer #{token}"}
        ]
      )

    {:ok, %{"url" => ws}} = Jason.decode(response.body)
    ws
  end
end
