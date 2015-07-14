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

end
