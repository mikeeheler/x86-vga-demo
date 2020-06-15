%include 'MACROS.MAC'

%ifndef VGA_DEFS_INC
%define VGA_DEFS_INC


%macro vga_read 1
    mov     dx,%1
    in      al,dx
%endmacro

%macro vga_write 1
    mov     dx,%1
    out     dx,al
%endmacro


FALSE                           equ     0
TRUE                            equ     1

VGA_MEM_SEGMENT                 equ     0xB800

VGA_ATTRIB_ADDR_READ_PORT       equ     0x03C0
VGA_ATTRIB_ADDR_WRITE_PORT      equ     0x03C0
VGA_ATTRIB_DATA_READ_PORT       equ     0x03C1
VGA_ATTRIB_DATA_WRITE_PORT      equ     0x03C0
VGA_CRTC_ADDR_PORT              equ     0x03D4
VGA_CRTC_DATA_PORT              equ     0x03D5
VGA_DAC_STATE_READ_PORT         equ     0x03C7
VGA_DAC_ADDR_READ_MODE_PORT     equ     0x03C7
VGA_DAC_ADDR_WRITE_MODE_PORT    equ     0x03C8
VGA_DAC_DATA_PORT               equ     0x03C9
VGA_FEATURE_CTRL_READ_PORT      equ     0x03CA
VGA_FEATURE_CTRL_WRITE_PORT     equ     0x03DA
VGA_GRAPHICS_ADDR_PORT          equ     0x03CE
VGA_GRAPHICS_DATA_PORT          equ     0x03CF
VGA_INPUT_STATUS_0_PORT         equ     0x03C2
VGA_INPUT_STATUS_1_PORT         equ     0x03DA
VGA_MISC_OUTPUT_READ_PORT       equ     0x03CC
VGA_MISC_OUTPUT_WRITE_PORT      equ     0x03C2
VGA_SEQ_ADDR_PORT               equ     0x03C4
VGA_SEQ_DATA_PORT               equ     0x03C5

%endif
