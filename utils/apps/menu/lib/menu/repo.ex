defmodule Menu.Repo do
  use Ecto.Repo,
    otp_app: :menu,
    adapter: Ecto.Adapters.Postgres
end
