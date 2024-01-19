defmodule Todolistapp.Repo do
  use Ecto.Repo,
    otp_app: :todolistapp,
    adapter: Ecto.Adapters.Postgres
end
