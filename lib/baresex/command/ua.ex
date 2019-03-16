defmodule Baresex.Command.UA do
  @moduledoc false
  alias Baresex.Command

  def new(aor, token \\ nil) do
    Command.new("uanew")
    |> Command.add_params(aor)
    |> Command.add_token(token)
  end

  def select(aor, token \\ nil) do
    Command.new("uafind")
    |> Command.add_params(aor)
    |> Command.add_token(token)
  end
end
