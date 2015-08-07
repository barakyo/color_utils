ColorUtils
==========

Color Util library for Elixir.

## Features ##
* Convert RGB to HEX
* Convert HEX to RGB
* Convert RGB to HSV
* Convert HSV to RGB
* Calculate complementary colors for a given HSV or RGB value.
* Calcluate triadic colors for a given HSV or RGB value.


## Usage ##

Please see tests for extensive usage.

### Convert HEX to RGB ###

    iex(3)> ColorUtils.hex_to_rgb("#C8C8C8")
    %RGB{blue: 200.0, green: 200.0, red: 200.0}

### Converting RGB to HSV ###

    iex(1)> rgb = %RGB{red: 200, blue: 200, green: 200}
    %RGB{blue: 200, green: 200, red: 200}
    iex(2)> hsv = ColorUtils.rgb_to_hsv(rgb)
    %HSV{hue: 0, saturation: 0.0, value: 78.4}

## Calculate Complementary Colors ##

    color = %RGB{red: 255, green: 0, blue: 0}
    iex(6)> ColorUtils.get_complementary_colors(color)
    [%RGB{blue: 127, green: 255, red: 0}, %RGB{blue: 255, green: 255, red: 0},
    %RGB{blue: 255, green: 127, red: 0}]
