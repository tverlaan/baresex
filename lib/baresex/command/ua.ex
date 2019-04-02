defmodule Baresex.Command.UA do
  @moduledoc """
  UA commands
  """
  alias Baresex.Command

  def new(aor, token \\ nil) do
    Command.new("uanew")
    |> Command.add_params(aor)
    |> Command.add_token(token)
  end

  def delete(aor, token \\ nil) do
    Command.new("uadel")
    |> Command.add_params(aor)
    |> Command.add_token(token)
  end

  def select(aor, token \\ nil) do
    Command.new("uafind")
    |> Command.add_params(aor)
    |> Command.add_token(token)
  end
end
