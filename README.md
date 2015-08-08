ColorUtils
==========

[![Build Status](https://travis-ci.org/barakyo/color_utils.svg?branch=master)](https://travis-ci.org/barakyo/color_utils)

Color Util library for Elixir.

## Features ##
* Convert RGB to HEX
* Convert HEX to RGB
* Convert RGB to HSV
* Convert HSV to RGB
* Calculate complementary colors for a given HSV or RGB value.
* Calculate triadic colors for a given HSV or RGB value.
* Calculate analogous colors for a given HSV or RGB value.


## Usage ##

### Convert HEX to RGB ###

    iex(3)> ColorUtils.hex_to_rgb("#C8C8C8")
    %RGB{blue: 200.0, green: 200.0, red: 200.0}

### Convert RGB to HEX ###

    iex(3)> rgb = %RGB{red: 200, blue: 200, green: 200}
    %ColorUtils.RGB{blue: 200, green: 200, red: 200}
    iex(4)> hex = ColorUtils.rgb_to_hex(rgb)
    "#C8C8C8"

### Converting RGB to HSV ###

    iex(1)> rgb = %RGB{red: 200, blue: 200, green: 200}
    %RGB{blue: 200, green: 200, red: 200}
    iex(2)> hsv = ColorUtils.rgb_to_hsv(rgb)
    %HSV{hue: 0, saturation: 0.0, value: 78.4}

### Converting HSV to RGB ###

    iex(7)> ColorUtils.hsv_to_rgb(%HSV{hue: 23, saturation: 15, value: 71.0})
    %ColorUtils.RGB{blue: 153, green: 164, red: 181}

### Calculate Complementary Colors ###

    color = %RGB{red: 255, green: 0, blue: 0}
    iex(6)> ColorUtils.get_complementary_colors(color)
    [%RGB{blue: 127, green: 255, red: 0}, %RGB{blue: 255, green: 255, red: 0},
    %RGB{blue: 255, green: 127, red: 0}]

### Calculate Triadic Colors ###

    iex(8)> ColorUtils.get_triad_colors(%RGB{red: 255, green: 0, blue: 0})
    [%ColorUtils.RGB{blue: 127, green: 0, red: 255},
    %ColorUtils.RGB{blue: 0, green: 255, red: 127}]

### Calculate Analogous Colors ###

    iex(9)> ColorUtils.get_analogous_colors(%RGB{red: 255, green: 0, blue: 0})
    [%ColorUtils.RGB{blue: 127, green: 0, red: 255},
    %ColorUtils.RGB{blue: 0, green: 127, red: 255}]
