%include 'VGA_DEFS.INC'

SAVE_HARDWARE_STATE     equ     0001b
SAVE_BIOS_STATE         equ     0010b
SAVE_DAC_STATE          equ     0100b
SAVE_ALL_STATES         equ     (SAVE_HARDWARE_STATE | \
                                 SAVE_BIOS_STATE     | \
                                 SAVE_DAC_STATE)
SAVE_STATES_MAX_SIZE    equ     0x10


[segment data]

vga_esdi                dw      0x0000,VGA_MEM_SEGMENT

save_state_error        db      'ERROR: VGA save state is too large (max 1kb).',13,10,'$'
state_not_saved_error   db      'ERROR: Cannot restore VGA state; not saved.',13,10,'$'
state_saved             db      0
saved_state             resb    (SAVE_STATES_MAX_SIZE * 64)
saved_state_size        equ     ($ - saved_state)

active_color            resb    1
display_page            resb    1
screen_width            resb    1
video_mode              resb    1

bottom_right            resw    1
top_left                resw    1


[segment code]

[global vga_init]
vga_init:
    call        save_state
    cmp         al,FALSE
    jne         .do_init
    mov         al,0
    ret

.do_init:
    mov         byte [active_color], 07h

    mov         ah,0Fh
    int         10h
    mov         [display_page], bh
    mov         [screen_width], ah
    mov         [video_mode], al
    mov         byte [bottom_right+1], 18h
    mov         byte [bottom_right], ah

    call        vga_clear_screen
    xor         ax,ax
    call        vga_set_cursor_location
    ret


[global vga_shutdown]
vga_shutdown:
    call        restore_state
    ret


[global vga_clear_screen]
vga_clear_screen:
    push        di
    push        es

    les         di,[vga_esdi]
    mov         ah ,[active_color]
    mov         al,0x20
    mov         cx,07D0h
    rep         stosw

    pop         es
    pop         di
    ret


[global vga_set_active_color]
vga_set_active_color:
    beginfunc
    mov         al,[bp+4]
    mov         [active_color],al
    endfunc     2


[global vga_set_cursor_location]
vga_set_cursor_location:
    push        bx
    mov         dx,ax
    mov         ah,2
    xor         bh,bh
    int         10h
    pop         bx
    ret


save_state:
    push        bx

    mov         ax,0x1C00
    mov         cx,SAVE_ALL_STATES
    int         10h
    cmp         bx,SAVE_STATES_MAX_SIZE
    ja          .save_state_too_big

    push        es
    mov         ax,data
    mov         es,ax

    mov         ax,0x1C01
    mov         bx,saved_state
    mov         cx,SAVE_ALL_STATES
    int         10h

    mov         byte [state_saved],1
    mov         ax,1

    pop         es
    pop         bx
    ret

.save_state_too_big:
    push        data
    push        save_state_error
    call        print_msg
    mov         ax,0

    pop         bx
    ret


restore_state:
    cmp         byte [state_saved],1
    jne         .state_not_saved

    mov         ax,0x1C02
    mov         bx,saved_state
    mov         cx,SAVE_ALL_STATES
    int         10h
    ret

.state_not_saved:
    push        data
    push        state_not_saved_error
    call        print_msg
    mov         ax,0
    ret


print_msg:
    beginfunc

    push        ds
    lds         dx,[bp+4]
    mov         ah,9
    int         21h
    pop         ds

    endfunc     4
