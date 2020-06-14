%include 'VGA_DEFS.INC'


[segment local private]

active_color    resb    1
display_page    resb    1
screen_width    resb    1
video_mode      resb    1

bottom_right    resw    1
top_left        resw    1


[segment data]

vga_esdi        dw      0,VGA_MEM_SEGMENT


[segment code]

[global _vga_init]
_vga_init:
    mov     byte [active_color], 07h

    mov     ah,0Fh
    int     10h
    mov     [display_page], bh
    mov     [screen_width], ah
    mov     [video_mode], al
    mov     byte [bottom_right+1], 18h
    mov     byte [bottom_right], ah
    ret


[global _vga_clear_screen]
_vga_clear_screen:
    push    di
    push    es

    les     di,[vga_esdi]
    mov     ah ,[active_color]
    mov     al,0x20
    mov     cx,07D0h
    rep     stosw

    pop     es
    pop     di
    ret


[global _vga_set_active_color]
_vga_set_active_color:
    beginfunc
    mov     al,[bp+4]
    mov     [active_color],al
    endfunc 2
