# Odin bindings for RXI's kit
kit's repo: https://github.com/rxi/kit

# kit
![](https://user-images.githubusercontent.com/3920290/224488465-97efadf4-718d-4a9f-99c3-805821bdc376.gif)


A tiny library for making small games with big pixels

## Example
```odin
package kit_example

import "kit"

main :: proc() {
    ctx := kit.create("hi", 320, 200, {.SCALE2X})
    for kit.step(ctx, nil) {
        kit.draw_text(ctx, kit.WHITE, "Hello world!", 10, 10)
    }
    kit.destroy(ctx)
}
```

## Overview
- Small single header library: ~1.3k lines of C
- Software rendered images and bitmap fonts
- Keyboard and mouse input
- PNG Loading (borrowed from [tigr](https://github.com/erkkah/tigr))
- No dependencies
- Windows only

## Usage
Run `build.bat` in `./lib` to make binaries. See the [demo](demo).

## License
Public domain ⁠— no warranty implied; use at your own risk.

## Bindings Notes
`*_down`, `*_pressed`, and `*_released` take the `VK_*` constants found in [`core:sys/windows/key_codes.odin`](https://github.com/odin-lang/Odin/blob/master/core/sys/windows/key_codes.odin)