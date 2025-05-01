defmodule Workspacefilter.Repo do
  use Ecto.Repo,
    otp_app: :workspacefilter,
    adapter: Ecto.Adapters.SQLite3
end
