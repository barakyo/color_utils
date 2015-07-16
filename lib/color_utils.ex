defmodule ColorUtils do

  @dec_to_hex_symbols %{
    0 => "0",
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "6",
    7 => "7",
    8 => "8",
    9 => "9",
    10 => "A",
    11 => "B",
    12 => "C",
    13 => "D",
    14 => "E",
    15 => "F"
  }

  @hex_to_dec_symbols %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "A" => 10,
    "B" => 11,
    "C" => 12,
    "D" => 13,
    "E" => 14,
    "F" => 15
  }


  defmacro __using__(_) do

  end

  def hex_to_rgb(hex) do
    corrected_string = cond do
      (String.at(hex, 0) == "#") -> String.slice(hex, 1..-1)
      true -> hex
    end
    hex_red = String.slice(corrected_string, 0..1)
    hex_green = String.slice(corrected_string, 2..3)
    hex_blue = String.slice(corrected_string, 4..5)
    %RGB{
      red: hex_to_decimal(hex_red),
      blue: hex_to_decimal(hex_blue),
      green: hex_to_decimal(hex_green)
    }
  end

  def rgb_to_hex(%RGB{} = rgb) do
    # get colors as hex
    blue = decimal_to_hex(rgb.blue)
    red = decimal_to_hex(rgb.red)
    green = decimal_to_hex(rgb.green)
    "#" <> red <> green <> blue
  end

  def hex_to_decimal(hex_value) do
    # Reverse string so that indices are coupled with the correct value to power
    # C8 -> 8C => (8 * 16^0) + (C * 16^1)
    hex_list = String.reverse(hex_value) |> String.codepoints() |> Enum.with_index()
    decimal_values = Enum.map(hex_list, fn({x, i} = hex_tuple) ->
      # Convert hex value to 0-15
      x_value = Map.get(@hex_to_dec_symbols, x)
      # Raise to power and return
      x_value * :math.pow(16, i)
    end)
    Enum.reduce(decimal_values, 0, fn(x,y) -> x+y end)
  end

  def decimal_to_binary(num) do
    decimal_to_binary(num, [])
  end

  def decimal_to_binary(num, remainders) when num > 0 do
    decimal_to_binary(div(num, 2), [rem(num, 2)] ++ remainders)
  end

  def decimal_to_binary(0, remainders) do
    remainders
  end

  def decimal_to_hex(num) do
    decimal_to_hex(num, "")
  end

  def decimal_to_hex(num, hex) when num > 0 do
    remainder = Map.get(@dec_to_hex_symbols, rem(num, 16))
    decimal_to_hex(div(num, 16), remainder <> hex)
  end

  def decimal_to_hex(0, hex) do
    hex
  end

end
