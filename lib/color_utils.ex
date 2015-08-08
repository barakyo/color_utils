defmodule ColorUtils do
  alias ColorUtils.RGB
  alias ColorUtils.HSV
  @moduledoc """
  Color Util Library for Elixir
  """

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

  @complimentary_color_deltas [150, 180, 210]
  @triad_color_deltas [-90, 90]

  # Remove leading `"#"` if it exists
  def hex_to_rgb(<<"#", hex::binary>>) do
    hex_to_rgb(hex)
  end

  def hex_to_rgb(<<hex_red::binary-size(2), hex_green::binary-size(2), hex_blue::binary-size(2)>>) do
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

  def get_complementary_colors(%RGB{} = rgb) do
    rgb_to_hsv(rgb) |> get_complementary_colors |> Enum.map(&(hsv_to_rgb(&1)))
  end

  def get_complementary_colors(%HSV{} = hsv) do
    Enum.map(@complimentary_color_deltas, fn(degree) ->
      add_hue(hsv, degree)
    end)
  end

  def get_triad_colors(%HSV{} = hsv) do
    Enum.map(@triad_color_deltas, &(add_hue(hsv, &1)))
  end

  def get_triad_colors(%RGB{} = rgb) do
    rgb_to_hsv(rgb) |> get_triad_colors |> Enum.map(&(hsv_to_rgb(&1)))
  end

  defp add_hue(%HSV{hue: hue} = hsv, degree) do
    cond do
      (degree + hue >= 360) -> %HSV{hsv | hue: hue + degree - 360}
      true -> %HSV{hsv | hue: hue + degree}
    end
  end

  def rgb_to_hsv(%RGB{red: red, green: green, blue: blue} = _rgb) do
    # Convert rgb values to be from 0..1 rather than 0..255
    rgb_values = %RGB{red: red/255, green: green/255, blue: blue/255}
    rgb_values_list = [rgb_values.red, rgb_values.green, rgb_values.blue]
    # Calculate c_delta using the max and min of the values
    c_max = Enum.max(rgb_values_list)
    c_min = Enum.min(rgb_values_list)
    c_delta = c_max - c_min
    hue = get_hue(rgb_values, c_delta, c_max) |> trunc()
    saturation = get_saturation(c_delta, c_max)
    # Return hsv where value is a %
    %HSV{hue: hue, saturation: saturation, value: Float.round((c_max * 100), 1)}
  end

  def hsv_to_rgb(%HSV{hue: hue, saturation: saturation, value: value} = _hsv) do
    h = hue / 60
    i = Float.floor(h) |> trunc()
    f = h - i
    sat_dec = saturation / 100
    p = value * (1 - sat_dec)
    q = value * (1 - sat_dec * f)
    t = value * (1 - sat_dec * (1 - f))
    p_rgb = get_rgb_color(p)
    v_rgb = get_rgb_color(value)
    t_rgb = get_rgb_color(t)
    q_rgb = get_rgb_color(q)
    case i do
      0 -> %RGB{red: v_rgb, green: t_rgb, blue: p_rgb}
      1 -> %RGB{red: q_rgb, green: v_rgb, blue: p_rgb}
      2 -> %RGB{red: p_rgb, green: v_rgb, blue: t_rgb}
      3 -> %RGB{red: p_rgb, green: q_rgb, blue: v_rgb}
      4 -> %RGB{red: t_rgb, green: p_rgb, blue: v_rgb}
      _ -> %RGB{red: v_rgb, green: p_rgb, blue: q_rgb}
    end
  end

  defp get_rgb_color (color) do
      (color * 255) / 100 |> trunc()
  end

  defp get_hue(%RGB{red: red, green: green, blue: blue} = _rgb_values,
    c_delta, c_max) do
    60 * cond do
      (c_delta == 0) -> 0
      (c_max == red) ->
        val = ((green - blue) / c_delta) |> trunc()
        rem(val, 6)
      (c_max == green) ->
        ((blue - red) / c_delta) + 2
      (c_max == blue) ->
        ((red - green) / c_delta) + 4
    end
  end

  defp get_saturation(c_delta, 0) do
    0
  end

  defp get_saturation(c_delta, c_max) do
    (c_delta / c_max) * 100
  end

  def hex_to_decimal(hex_value) do
    # Reverse string so that indices are coupled with the correct value to power
    # C8 -> 8C => (8 * 16^0) + (C * 16^1)
    hex_list = String.reverse(hex_value) |> String.codepoints() |> Enum.with_index()
    decimal_values = Enum.map(hex_list, fn({x, i} = _hex_tuple) ->
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

  defp decimal_to_binary(0, remainders) do
    remainders
  end

  defp decimal_to_binary(num, remainders) when num > 0 do
    decimal_to_binary(div(num, 2), [rem(num, 2)] ++ remainders)
  end

  def decimal_to_hex(num) do
    decimal_to_hex(num, "")
  end

  defp decimal_to_hex(0, hex) do
    hex
  end

  defp decimal_to_hex(num, hex) when num > 0 do
    remainder = Map.get(@dec_to_hex_symbols, rem(num, 16))
    decimal_to_hex(div(num, 16), remainder <> hex)
  end

end
