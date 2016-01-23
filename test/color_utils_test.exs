defmodule ColorUtilsTest do
  use ExUnit.Case, async: true
  alias ColorUtils.RGB
  alias ColorUtils.HSV

  test "converting from rgb to hex" do
    rgb = %RGB{red: 200, blue: 200, green: 200}
    hex = ColorUtils.rgb_to_hex(rgb)
    assert hex == "#C8C8C8"
  end

  test "converting rgb to xyz" do
    rgb = %RGB{red: 215.0, green: 15.0, blue: 15.0}
    xyz = ColorUtils.rgb_to_xyz(rgb)
    assert xyz.x == 28.281379314464917
    assert xyz.y == 14.8232102214694
    assert xyz.z == 1.8225076802216795 
  end

  test "converting from hex to rgb" do
    rgb = ColorUtils.hex_to_rgb("#C8C8C8")
    assert rgb.blue == 200
    assert rgb.red == 200
    assert rgb.green == 200
  end

  test "decimal to binary" do
    binary_list = ColorUtils.decimal_to_binary(2)
    assert binary_list == [1, 0]
  end

  test "decimal to hex" do
    hex_20 = ColorUtils.decimal_to_hex(20)
    assert hex_20 == "14"
    hex_255 = ColorUtils.decimal_to_hex(255)
    assert hex_255 == "FF"
  end

  test "rgb to hsv" do
    rgb = %RGB{red: 200, blue: 200, green: 200}
    actual_hsv = ColorUtils.rgb_to_hsv(rgb)
    expected_hsv = %HSV{hue: 0, saturation: 0.0, value: 78.4}
    assert actual_hsv == expected_hsv
    expected_hsv_2 = %HSV{hue: 210, value: 100.0, saturation: 100.0}
    rgb_2 = %RGB{red: 0, green: 127, blue: 255}
    actual_hsv_2 = ColorUtils.rgb_to_hsv(rgb_2)
    assert actual_hsv_2 == expected_hsv_2
  end

  test "hsv to rgb" do
    hsv = %HSV{hue: 0, saturation: 0, value: 78.4}
    expected_rgb = %RGB{red: 199, blue: 199, green: 199}
    actual_rgb = ColorUtils.hsv_to_rgb(hsv)
    assert actual_rgb == expected_rgb
    hsv_2 = %HSV{hue: 23, saturation: 15, value: 71.0}
    expected_rgb_2 = %RGB{red: 181, blue: 153, green: 164}
    actual_rgb_2 = ColorUtils.hsv_to_rgb(hsv_2)
    assert actual_rgb_2 == expected_rgb_2
    hsv_3 = %HSV{hue: 189, saturation: 60, value: 95}
    expected_rgb_3 = %RGB{red: 96, green: 220, blue: 242}
    actual_rgb_3 = ColorUtils.hsv_to_rgb(hsv_3)
    assert actual_rgb_3 == expected_rgb_3
    expected_rgb_4 = %RGB{red: 0, green: 127, blue: 255}
    hsv_4 = %HSV{hue: 210, saturation: 100, value: 100}
    actual_rgb_4 = ColorUtils.hsv_to_rgb(hsv_4)
    assert actual_rgb_4 == expected_rgb_4
  end

  test "get complementary colors" do
    color = %HSV{hue: 0, saturation: 100, value: 100}
    complementary_colors = ColorUtils.get_complementary_colors(color)
    assert length(complementary_colors) == 3
    [first, second, third] = complementary_colors
    assert [first.hue, second.hue, third.hue] == [150, 180, 210]
    color_2 = %HSV{hue: 225, saturation: 100, value: 100}
    complementary_colors_2 = ColorUtils.get_complementary_colors(color_2)
    assert length(complementary_colors_2) == 3
    [first, second, third] = complementary_colors_2
    assert [first.hue, second.hue, third.hue] == [15, 45, 75]
  end

  test "get complementary colors as rgb" do
    color = %RGB{red: 255, green: 0, blue: 0}
    [first, second, third] = ColorUtils.get_complementary_colors(color)
    expected_first = %RGB{red: 0, green: 255, blue: 127}
    expected_second = %RGB{red: 0, green: 255, blue: 255}
    expected_third = %RGB{red: 0, green: 127, blue: 255}
    assert first == expected_first
    assert second == expected_second
    assert third == expected_third
  end

  test "get triad colors" do
    color = %HSV{hue: 0, saturation: 100, value: 100}
    triad_colors = ColorUtils.get_triad_colors(color)
    assert length(triad_colors) == 2
    [first, second] = triad_colors
    assert abs(first.hue - color.hue)  == 90
    assert abs(second.hue - color.hue)  == 90
  end

  test "get triad colors as rgb" do
    color = %RGB{red: 255, green: 0, blue: 0}
    triad_colors = ColorUtils.get_triad_colors(color)
    assert length(triad_colors) == 2
    [first, second] = triad_colors
    assert first.red == 255
    assert first.green == 0
    assert first.blue == 127
    assert second.red == 127
    assert second.green == 255
    assert second.blue == 0
  end

  test "get analogous colors" do
    color = %HSV{hue: 0, saturation: 100, value: 100}
    analogous_colors = ColorUtils.get_analogous_colors(color)
    [first, second] = analogous_colors
    assert abs(first.hue - color.hue) == 30
    assert abs(second.hue - color.hue) == 30
  end

  test "get analogous colors as rgb" do
    color = %RGB{red: 255, green: 0, blue: 0}
    analogous_colors = ColorUtils.get_analogous_colors(color)
    [first, second] = analogous_colors
    assert first.red == 255
    assert first.green == 0
    assert first.blue == 127
    assert second.red == 255
    assert second.green == 127
    assert second.blue == 0
  end
end
