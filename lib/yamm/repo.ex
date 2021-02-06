defmodule YAMM.Repo do
  use Ecto.Repo,
    otp_app: :yamm,
    adapter: Ecto.Adapters.Postgres
end
