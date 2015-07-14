defmodule ColorUtils do

  @hex_symbols = %{
    0 : '0',
    1 : '1',
    2 : '2',
    3 : '3',
    4 : '4',
    5 : '6',
    7 : '7',
    8 : '8',
    9 : '9',
    10 : 'A',
    11 : 'B',
    12 : 'C',
    13 : 'D',
    14 : 'E',
    15 : 'F'
  }

  defmacro __using__(_) do

  end

  # def rgb_to_hex(%RGB{} = rgb) do
  #   # Comment
  # end

  def decimal_to_binary(num) do
    decimal_to_binary(num, [])
  end

  def decimal_to_binary(num, remainders) when num > 0 do
    decimal_to_binary(div(num, 2), remainders ++ [rem(num, 2)])
  end

  def decimal_to_binary(0, remainders) do
    Enum.reverse(remainders)
  end

  def decimal_to_hex(num) do
    decimal_to_hex(num, "")
  end

  def decimal_to_hex(num, hex) when num > 0 do
    IO.inspect @hex_symbols
    remainder = Map.get(@hex_symbols, rem(num, 16))
    decimal_to_hex(div(num, 16), hex ++ remainder)
  end

  def decimal_to_hex(0, hex) do
    hex
  end

end
