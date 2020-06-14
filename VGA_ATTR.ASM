%include 'VGA_DEFS.INC'

PALETTE_IDX             equ     0x00
MODE_CTRL_IDX           equ     0x10
OVERSCAN_COLOR_IDX      equ     0x11
COLOR_PLANE_ENABLE_IDX  equ     0x12
HORIZ_PIXEL_PAN_IDX     equ     0x13
COLOR_SELECT_IDX        equ     0x14

MODE_LGE_BIT            equ     2
MODE_LGE_MASK           equ     (1 << MODE_LGE_BIT)
MODE_LGE_XMASK          equ     (MODE_LGE_MASK ^ 0xFF)

MODE_BLINK_BIT          equ     3
MODE_BLINK_MASK         equ     (1 << MODE_BLINK_BIT)
MODE_BLINK_XMASK        equ     (MODE_BLINK_MASK ^ 0xFF)


; Output - AL=Blink State (1=ON, 0=OFF)
[global vga_get_blink]
vga_get_blink:
    mov         al,MODE_CTRL_IDX
    call        vga_attr_get
    and         al,MODE_BLINK_MASK
    shr         al,MODE_BLINK_BIT
    ret


; Output - AL=Line Graphics Enable (1=ON, 0=OFF)
[global vga_get_line_graphics]
vga_get_line_graphics:
    mov         al,MODE_CTRL_IDX
    call        vga_attr_get
    and         al,MODE_LGE_MASK
    shr         al,MODE_LGE_BIT
    ret


[global vga_set_blink]
vga_set_blink:
    mov         cl,al
    shl         cl,MODE_BLINK_BIT
    mov         ch,MODE_BLINK_XMASK
    mov         al,MODE_CTRL_IDX
    call        vga_attr_set
    ret


[global vga_set_line_graphics]
vga_set_line_graphics:
    mov         cl,al
    shl         cl,MODE_LGE_BIT
    mov         ch,MODE_LGE_XMASK
    mov         al,MODE_CTRL_IDX
    call        vga_attr_set
    ret

; With the attribute controller registers, the index and data write
; ports are the same and an internal flip-flop tracks which will be
; written to next. We don't know what state it's in currently so we
; need to reset it by reading from the Input Status #1 port first.
;
; This is necessary for both get and set routines since we need to write
; to the index port.

; Input: AL=Index
; Output: AL=Value
vga_attr_get:
    mov         cl,al

    vga_read    VGA_ATTRIB_ADDR_READ_PORT
    push        ax

    vga_read    VGA_INPUT_STATUS_1_PORT

    mov         al,cl
    vga_write   VGA_ATTRIB_ADDR_WRITE_PORT

    vga_read    VGA_ATTRIB_DATA_READ_PORT
    mov         cl,al

    vga_read    VGA_INPUT_STATUS_1_PORT
    pop         ax
    vga_write   VGA_ATTRIB_ADDR_WRITE_PORT

    mov         al,cl
    xor         ah,ah
    ret

; Input: AL=Index, CH=XMask, CL=Value
vga_attr_set:
    beginfunc   3

    mov         [bp-3],al
    mov         [bp-2],cx

    ; Save current value of index port
    vga_read    VGA_ATTRIB_ADDR_READ_PORT
    push        ax

    ; Read Input Status #1 port to reset the index/data write bit.
    ; The value returned is not important and can be ignored.
    vga_read    VGA_INPUT_STATUS_1_PORT

    ; Set the register index we want to read/write
    mov         al,[bp-3]   ; register index
    vga_write   VGA_ATTRIB_ADDR_WRITE_PORT

    ; Grab the current value of the register
    vga_read    VGA_ATTRIB_DATA_READ_PORT
    mov         cx,[bp-2]
    and         al,ch       ; mask out the bits being modified
    or          al,cl       ; set the values in those bits
    vga_write   VGA_ATTRIB_DATA_WRITE_PORT

    ; Restore index port value
    pop         ax
    vga_write   VGA_ATTRIB_ADDR_WRITE_PORT

    endfunc
