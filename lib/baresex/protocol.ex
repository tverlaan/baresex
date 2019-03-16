defmodule Baresex.Protocol do
  @moduledoc false

  @doc """
    iex> Baresex.Protocol.encode(%{foo: :a})
    "11:{\\"foo\\":\\"a\\"},"
  """
  def encode(map) when is_map(map) do
    map
    |> Jason.encode!()
    |> ns_encode()
  end

  def decode(""), do: {%{}, ""}

  def decode(bin) when is_binary(bin) do
    {event, tail} = ns_decode(bin)
    {Jason.decode!(event), tail}
  end

  @doc """
    iex> Baresex.Protocol.ns_decode(":,")
    {nil, ":,"}

    iex> Baresex.Protocol.ns_decode("0:,")
    {"", ""}

    iex> Baresex.Protocol.ns_decode("1")
    {nil, "1"}

    iex> Baresex.Protocol.ns_decode("1:")
    {nil, "1:"}

    iex> Baresex.Protocol.ns_decode("1:a")
    {nil, "1:a"}

    iex> Baresex.Protocol.ns_decode("1:a,")
    {"a", ""}

    iex> Baresex.Protocol.ns_decode("1:a,b")
    {"a", "b"}
  """
  def ns_decode(bin) when is_binary(bin) do
    bin
    |> split_netstring()
    |> length_netstring()
    |> parse_netstring()
  end

  defp ns_encode(str) when is_binary(str) do
    "#{byte_size(str)}:#{str},"
  end

  defp split_netstring(bin) do
    case String.split(bin, ":", parts: 2) do
      ["", _] ->
        {nil, bin}

      [len, tail] ->
        {len, tail}

      _ ->
        {nil, bin}
    end
  end

  defp length_netstring({nil, bin}), do: {nil, bin}

  defp length_netstring({l, bin}) do
    case Integer.parse(l) do
      {len, ""} ->
        {len, bin}

      _ ->
        {nil, bin}
    end
  end

  defp parse_netstring({nil, bin}), do: {nil, bin}

  defp parse_netstring({len, bin}) do
    do_parse_netstring(bin, byte_size(bin), len)
  end

  defp do_parse_netstring(bin, len, msglen) when len > msglen + 1 do
    msg = binary_part(bin, 0, msglen)
    rest = binary_part(bin, msglen + 1, len - (msglen + 1))
    {msg, rest}
  end

  defp do_parse_netstring(bin, len, msglen) when len == msglen + 1 do
    {binary_part(bin, 0, msglen), ""}
  end

  defp do_parse_netstring(bin, _, msglen) do
    {nil, "#{msglen}:" <> bin}
  end
end
