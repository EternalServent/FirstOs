org 0x7c00
bits 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop 

times 33 db 0

start:
    jmp 0:step2

step2:
    cli             ; clear interupts
    mov ax , 0x00 
    mov ds , ax 
    mov es , ax
    mov ss , ax 
    mov sp , 0x7c00
    sti             ; enable interupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax , cr0
    or eax , 0x1 
    mov cr0 , eax
    jmp CODE_SEG:load32
 

; GDT 
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code:
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 11001111b
    db 0

; offset 0x10 
gdt_data:
    dw 0xffff
    dw 0
    db 0
    db 0x92
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[bits 32]
load32:
    mov eax , 1
    mov ecx , 100 
    mov edi , 0x0100000
    call ata_lba_read
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx , eax
    shr eax , 24
    or  eax , 0xe0
    mov dx , 0x1f6
    out dx , al 

    mov eax , ecx
    mov dx , 0x1f2
    out dx , al

    mov eax , ebx
    mov dx , 0x1f3
    out dx , al 

    mov dx , 0x1f4
    mov eax , ebx
    shr eax , 8
    out dx , al 

    mov dx , 0x1f5 
    mov eax , ebx
    shr eax , 16
    out dx , al 

    mov dx , 0x1f7
    mov al , 0x20
    out dx , al

.next_sector:
    push ecx
.try_again:
    mov dx , 0x1f7
    in al , dx 
    test al , 8
    jz .try_again

    mov ecx , 256 
    mov dx , 0x1f0
    rep insw
    pop ecx
    loop .next_sector
    ret



times 510 - ($-$$) db 0
dw 0xaa55
