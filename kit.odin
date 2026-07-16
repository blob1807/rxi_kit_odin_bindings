// kit v0.3 | public domain - no warranty implied; use at your own risk
package rxi_kit_bindings

import "core:c"
import win "core:sys/windows"


KIT_DEBUG :: #config(KIT_DEBUG, ODIN_DEBUG)

foreign import lib {
    "./lib/kit_debug.lib" when KIT_DEBUG else "./lib/kit.lib",
    "system:gdi32.lib",
    "system:user32.lib",
    "system:winmm.lib",
    "system:opengl32.lib",
}


Create_Flags :: bit_set[Create_Flag; i32]
Create_Flag  :: enum i32 {
    SCALE2X    = 0,
    SCALE3X    = 1,
    SCALE4X    = 2,
    HIDECURSOR = 3,
    FPS30      = 4,
    FPS144     = 5,
    FPSINF     = 6,
}

Color :: struct #raw_union { using p : struct { b, g, r, a: u8 }, w: u32 }
Rect  :: struct { x, y, w, h: i32 }
Image :: struct { pixels: [^]Color, w, h: i32 }
Glyph :: struct { rect: Rect, xadv: i32 }
Font  :: struct { image: ^Image, glyphs: [256]Glyph }

Input_States  :: bit_set[Input_State; u8]
Input_State :: enum u8 {
    DOWN     = 0,
    PRESSED  = 1,
    RELEASED = 2,
}

Context :: struct {
    wants_quit:  bool,
    hide_cursor: bool,

    // input
    char_buf:    [32]rune,
    key_state:   [256]Input_States,
    mouse_state: [16]Input_States,
    mouse_pos:   struct { x, y: i32 },
    mouse_delta: struct { x, y: i32 },

    // time
    step_time: f64,
    prev_time: f64,

    // graphics
    clip:   Rect,
    font:   ^Font,
    screen: ^Image,

    // windows
    win_w: i32, 
    win_h: i32,
    hwnd:  win.HWND,
    hdc:   win.HDC,
}


rgba  :: #force_inline proc "contextless" (#any_int R, G, B, A: u8) -> Color { 
    return {p = {r=R, g=G, b=B, a=A}}
}
rgb   :: #force_inline proc "contextless" (#any_int R, G, B: u8) -> Color {
    return {p = {r=R, g=G, b=B, a=0xff}}
}
alpha :: #force_inline proc "contextless" (#any_int A: u8) -> Color {
    return {p = {r=0xff, g=0xff, b=0xff, a=A}}
}

BIG_RECT  :: Rect{0, 0, 0xffffff, 0xffffff}
WHITE := Color{p={r=0xff, g=0xff, b=0xff, a=0xff}}
BLACK := Color{p={r=0,    g=0,    b=0,    a=0xff}}



@(default_calling_convention="c", link_prefix="kit_")
foreign lib {
    create    :: proc(title: cstring, w, h: i32, flags: Create_Flags) -> ^Context ---
    destroy   :: proc(ctx: ^Context) ---
    step      :: proc(ctx: ^Context, dt: ^f64) -> bool ---
    read_file :: proc(filename: cstring, len: ^i32) -> [^]byte ---

    create_image    :: proc(w, h: i32) -> ^Image ---
    load_image_file :: proc(filename: cstring) -> ^Image ---
    load_image_mem  :: proc(data: rawptr, #any_int len: i32)-> ^Image ---
    destroy_image   :: proc(img: ^Image) ---

    load_font_file :: proc(filename: cstring) -> ^Font ---
    load_font_mem  :: proc(data: rawptr, #any_int len: i32) -> ^Font ---
    destroy_font   :: proc(font: ^Font) ---
    text_width     :: proc(font: ^Font, text: cstring) -> i32 ---

    get_char       :: proc(ctx: ^Context) -> rune ---
    key_down       :: proc(ctx: ^Context, key: i32) -> bool ---
    key_pressed    :: proc(ctx: ^Context, key: i32) -> bool ---
    key_released   :: proc(ctx: ^Context, key: i32) -> bool ---
    mouse_pos      :: proc(ctx: ^Context, x, y: ^i32) ---
    mouse_delta    :: proc(ctx: ^Context, x, y: ^i32) ---
    mouse_down     :: proc(ctx: ^Context, button: i32) -> bool ---
    mouse_pressed  :: proc(ctx: ^Context, button: i32) -> bool ---
    mouse_released :: proc(ctx: ^Context, button: i32) -> bool ---

    clear       :: proc(ctx: ^Context, color: Color) ---
    set_clip    :: proc(ctx: ^Context, rect: Rect) ---
    draw_point  :: proc(ctx: ^Context, color: Color, x, y: i32) ---
    draw_rect   :: proc(ctx: ^Context, color: Color, rect: Rect) ---
    draw_line   :: proc(ctx: ^Context, color: Color, x1, y1, x2, y2: i32) ---
    draw_image  :: proc(ctx: ^Context, img: ^Image, x, y: i32) ---
    draw_image2 :: proc(ctx: ^Context, color: Color, img: ^Image, x, y: i32, src: Rect) ---
    draw_image3 :: proc(ctx: ^Context, mul_color, add_color: Color, img: ^Image, dst, src: Rect) ---
    draw_text   :: proc(ctx: ^Context, color: Color, text: cstring, x, y: i32) -> i32 ---
    draw_text2  :: proc(ctx: ^Context, color: Color, font: ^Font, text: cstring, x, y: i32) -> i32 ---
}
