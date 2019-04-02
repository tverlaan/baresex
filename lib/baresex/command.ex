defmodule Baresex.Command do
  @moduledoc """
  Command module
  """

  defstruct [:command, :params, :token]

  def new(command) do
    %__MODULE__{command: command}
  end

  def add_params(%__MODULE__{} = cmd, params) do
    %{cmd | params: params}
  end

  def add_token(%__MODULE__{} = cmd, token) do
    %{cmd | token: token}
  end
end

defimpl Jason.Encoder, for: Baresex.Command do
  def encode(struct, opts) do
    :maps.filter(&for_baresip?/2, struct)
    |> Jason.Encode.map(opts)
  end

  defp for_baresip?(:__struct__, _), do: false
  defp for_baresip?(_, nil), do: false
  defp for_baresip?(_, _), do: true
end
