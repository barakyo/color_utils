defmodule ColorUtilsTest do
  use ExUnit.Case
  use ColorUtils

  test "the truth" do
    assert 1 + 1 == 2
  end

  # test "converting from rgb to hex" do
  #   rgb = %RGB{red: 200, blue: 200, green: 200}
  #   hex = ColorUtils.rgb_to_hex(rgb)
  #   assert hex == "#7B8499"
  # end

  test "decimal to binary" do
    binary_list = ColorUtils.decimal_to_binary(2)
    assert binary_list == [1, 0]
  end

  test "decimal to hex" do
    binary_list = ColorUtils.decimal_to_hex(20)
    assert binary_list == 14 
  end

  # test "conver to the number 5 from decimal to binary" do
  #   binary_list = ColorUtils.decimal_to_binary(5)
  #   assert binary_list == [1, 0, 1]
  # end
end
