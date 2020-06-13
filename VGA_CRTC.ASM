%include 'VGA_DEFS.INC'

CURSOR_START_IDX        equ     0x0A

CURSOR_DISABLED_BIT     equ     5
CURSOR_DISABLED_MASK    equ     (1 << CURSOR_DISABLED_BIT)
CURSOR_DISABLED_XMASK   equ     (CURSOR_DISABLED_MASK ^ 0xFF)


[segment code]

; Returns: AL = 1 if enabled, 0 if not
[global vga_get_cursor_state]
vga_get_cursor_state:
    mov         al,CURSOR_START_IDX
    call        vga_crtc_get

    and         al,CURSOR_DISABLED_MASK
    shr         al,CURSOR_DISABLED_BIT
    xor         al,1

    ret


; Input: AL = 1 to enable, 0 to disable
[global vga_set_cursor_state]
vga_set_cursor_state:
    mov         cl,al
    ; Invert the bit since the actual flag is 1 = disabled
    xor         cl,1
    ; Set the bit in the correct position
    shl         cl,CURSOR_DISABLED_BIT

    vga_read    VGA_CRTC_ADDR_PORT
    push        ax

    mov         al,CURSOR_START_IDX
    vga_write   VGA_CRTC_ADDR_PORT

    vga_read    VGA_CRTC_DATA_PORT
    and         al,CURSOR_DISABLED_XMASK
    or          al,cl
    vga_write   VGA_CRTC_DATA_PORT

    pop         ax
    vga_write   VGA_CRTC_ADDR_PORT

    ret


; Input: AH - Index
; Output: Result in AL
vga_crtc_get:
    mov         ch,al

    vga_read    VGA_CRTC_ADDR_PORT
    push        ax

    mov         al,ch
    vga_write   VGA_CRTC_ADDR_PORT

    vga_read    VGA_CRTC_DATA_PORT
    mov         cl,al

    pop         ax
    vga_write   VGA_CRTC_ADDR_PORT

    mov         ax,cx
    xor         ah,ah

    ret
