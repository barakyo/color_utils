defmodule ColorUtils do
  use Bitwise

  alias ColorUtils.RGB
  alias ColorUtils.HSV
  alias ColorUtils.XYZ
  alias ColorUtils.LAB

  @moduledoc """
  Color Util Library for Elixir
  """

  @dec_to_hex_symbols %{
    0 => "0",
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "5",
    6 => "6",
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
  @analogous_color_deltas [-30, 30]
  @xyz_white_ref %XYZ{x: 95.047, y: 100.0, z: 108.883}
  @xyz_epsilon 0.008856
  @xyz_kappa 903.3
  @kl 1.0
  @k1 0.045
  @k2 0.015

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

  def distance(%RGB{} = rgb_1, %RGB{} = rgb_2) do
    # Convert colors to LAB
    lab_a = rgb_to_lab(rgb_1)
    lab_b = rgb_to_lab(rgb_2)

    delta_l = lab_a.l - lab_b.l
    delta_a = lab_a.a - lab_b.a
    delta_b = lab_a.b - lab_b.b

    c_1 = :math.sqrt(:math.pow(lab_a.a, 2) + :math.pow(lab_a.b, 2))
    c_2 = :math.sqrt(:math.pow(lab_b.a, 2) + :math.pow(lab_b.b, 2))
    delta_c = c_1 - c_2

    delta_h_distance = :math.pow(delta_a, 2) + :math.pow(delta_b, 2) - :math.pow(delta_c, 2)
    delta_h = case delta_h_distance > 0 do
      true -> :math.sqrt(delta_h_distance)
      false -> 0
    end

    { sl, kc, kh } = { 1.0, 1.0, 1.0 }
    sc = 1.0 + (@k1 * c_1)
    sh = 1.0 + (@k2 * c_1)

    delta_l_kl_sl = delta_l / (@kl * sl)
    delta_c_kc_sc = delta_c / (kc * sc)
    delta_h_kh_sh = delta_h / (kh * sh)

    i = :math.pow(delta_l_kl_sl, 2) + :math.pow(delta_c_kc_sc, 2) + :math.pow(delta_h_kh_sh, 2);
    case i > 0 do
      true -> :math.sqrt(i)
      false -> 0
    end
  end

  def rgb_to_hex(%RGB{} = rgb) do
    hex = (1 <<< 24) + (rgb.red <<< 16) + (rgb.green <<< 8) + rgb.blue
          |> Integer.to_string(16)
          |> String.slice(1..1500)

    "#" <> hex
  end

  defp pivot_rgb(n) do
    if n > 0.04045 do
      :math.pow(((n + 0.055) / 1.055), 2.4) * 100.0
    else
      (n / 12.92) * 100.0
    end
  end

  def rgb_to_xyz(%RGB{} = rgb) do
    pivoted = %RGB{
      red: pivot_rgb(rgb.red / 255.0),
      green: pivot_rgb(rgb.green / 255.0),
      blue: pivot_rgb(rgb.blue / 255.0)
    }
    %XYZ{
      x: pivoted.red * 0.4124 + pivoted.green * 0.3576 + pivoted.blue * 0.1805,
      y: pivoted.red * 0.2126 + pivoted.green * 0.7152 + pivoted.blue * 0.0722,
      z: pivoted.red * 0.0193 + pivoted.green * 0.1192 + pivoted.blue * 0.9505
    }
  end

  defp pivot_xyz(n) do
    if n > @xyz_epsilon do
      :math.pow(n, 1.0/3.0)
    else
      ((@xyz_kappa * n + 16) / 116)
    end
  end

  def rgb_to_lab(%RGB{} = rgb) do
    xyz = rgb_to_xyz(rgb)
    x = pivot_xyz(xyz.x / @xyz_white_ref.x)
    y = pivot_xyz(xyz.y / @xyz_white_ref.y)
    z = pivot_xyz(xyz.z / @xyz_white_ref.z)

    %LAB{
      l: max(0, (116 * y - 16)),
      a: 500 * (x - y),
      b: 200 * (y - z)
    }
  end

  def get_complementary_colors(%RGB{} = rgb) do
    rgb_to_hsv(rgb) |> get_complementary_colors |> Enum.map(&(hsv_to_rgb(&1)))
  end

  def get_complementary_colors(%HSV{} = hsv) do
    add_hue(@complimentary_color_deltas, hsv)
  end

  def get_triad_colors(%HSV{} = hsv) do
    add_hue(@triad_color_deltas, hsv)
  end

  def get_triad_colors(%RGB{} = rgb) do
    rgb_to_hsv(rgb) |> get_triad_colors |> Enum.map(&(hsv_to_rgb(&1)))
  end

  def get_analogous_colors(%HSV{} = hsv) do
    add_hue(@analogous_color_deltas, hsv)
  end

  def get_analogous_colors(%RGB{} = rgb) do
    rgb_to_hsv(rgb) |> get_analogous_colors |> Enum.map(&(hsv_to_rgb(&1)))
  end

  defp add_hue(%HSV{hue: hue} = hsv, degree) do
    cond do
      (degree + hue >= 360) -> %HSV{hsv | hue: hue + degree - 360}
      true -> %HSV{hsv | hue: hue + degree}
    end
  end

  defp add_hue(deltas, hsv) do
    Enum.map(deltas, &add_hue(hsv, &1))
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

  defp get_saturation(_c_delta, 0) do
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

end
