extern  vga_init, vga_shutdown


[segment code]

..start:
    mov     ax,data
    mov     ds,ax
    mov     es,ax
    mov     di,0
    mov     si,0

    call    vga_init
    cmp     al,0
    jne     .error_return

    call    vga_shutdown

    mov     ax,0x4C00
    int     21h

.error_return:
    mov     ah,9
    mov     dx,vga_init_failed_state
    int     21h

    mov     ax,0x4C01
    int     21h


[segment data]

vga_init_failed_state   db      'ERROR: VGA init failed.',13,10,'$'


[segment stack stack]
    resb    0xffff
