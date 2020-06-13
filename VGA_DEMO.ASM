extern vga_get_cursor_state, vga_set_cursor_state

[segment code]

..start:
    mov     ax,data
    mov     ds,ax

    call    vga_get_cursor_state
    push    ax
    call    print_cursor_msg

    mov     al,0
    call    vga_set_cursor_state
    call    vga_get_cursor_state
    call    print_cursor_msg

    pop     ax
    call    vga_set_cursor_state
    call    vga_get_cursor_state
    call    print_cursor_msg

    mov     ax,0x4C00
    int     0x21

print_cursor_msg:
    cmp     al,0
    je      .cursor_off
    mov     dx,cursor_on_msg
    jmp     .print_msg
.cursor_off:
    mov     dx,cursor_off_msg
.print_msg:
    mov     ah,9
    int     21h
    ret


[segment data]
cursor_off_msg  db  'Cursor is disabled.',0x0D,0x0A,'$'
cursor_on_msg   db  'Cursor is enabled.',0x0D,0x0A,'$'

[segment stack stack]
    resb    0xffff
