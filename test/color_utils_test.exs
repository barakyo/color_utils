defmodule ColorUtilsTest do
  use ExUnit.Case
  use ColorUtils

  test "converting from rgb to hex" do
    rgb = %RGB{red: 200, blue: 200, green: 200}
    hex = ColorUtils.rgb_to_hex(rgb)
    assert hex == "#C8C8C8"
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
  end
end
