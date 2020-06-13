%include 'VGA_DEFS.INC'

; Attribute Register Ports
INPUT_STATUS    equ     0x03DA
ADDR_REG_R      equ     0x03C0
ADDR_REG_W      equ     0x03C0
DATA_REG_R      equ     0x03C1
DATA_REG_W      equ     0x03C0

; Attribute Register Indices
ATTR_MODE_IDX   equ     0x10



; Input: bit mask in AL
; Output: attribute mode register masked
vga_get_cursor_start:
    mov         cx,ax

    vga_read    ADDR_REG_R
    push        ax
    
    vga_read    INPUT_STATUS
    
    mov         al,ATTR_MODE_IDX
    vga_write   ADDR_REG_W
    
    vga_read    DATA_REG_R
    mov         ch,al
    and         ch,cl
    
    vga_read    INPUT_STATUS
    
    pop         ax
    vga_write   ADDR_REG_W
    
    mov         al,cl
    ret


[global vga_get_attr]
vga_get_attr:
    ret

; Input: mask in AH, value in AL
[global vga_set_attr]
vga_set_attr:
    mov         cx,ax

    vga_read    ADDR_REG_R
    push        ax

    vga_read    INPUT_STATUS

    mov         al,ATTR_MODE_IDX
    vga_write   ADDR_REG_W

    vga_read    DATA_REG_R
    xor         ch,0xFF
    and         al,ch
    or          al,cl
    vga_write   DATA_REG_W

    pop         ax
    vga_write   ADDR_REG_W

    ret
