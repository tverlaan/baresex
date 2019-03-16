defmodule Baresex.Command.Call do
  @moduledoc false
  alias Baresex.Command

  def accept(token \\ nil) do
    Command.new("accept")
    |> Command.add_token(token)
  end

  def hangup(token \\ nil) do
    Command.new("hangup")
    |> Command.add_token(token)
  end

  def dial(dest, token \\ nil) do
    Command.new("dial")
    |> Command.add_params(dest)
    |> Command.add_token(token)
  end

  def dtmf(code, token \\ nil) do
    Command.new("sndcode")
    |> Command.add_params(code)
    |> Command.add_token(token)
  end
end
