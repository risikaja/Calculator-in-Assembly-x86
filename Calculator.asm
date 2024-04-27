org 100h

.model small
.data

msg:     db 0dh, 0ah, "1-Add", 0dh, 0ah, "2-Multiply", 0dh, 0ah, "3-Subtract", 0dh, 0ah, "4-Divide", 0Dh, 0Ah, '$'
msg1:    db 0dh, 0ah, "Choose an option between 1-4:", 0Dh, 0Ah, '$'
msg2:    db 0dh, 0ah, "Enter First Number : $"
msg3:    db 0dh, 0ah, "Enter Second Number : $"
msg5:    db 0dh, 0ah, "Result is : $"

.code

start:
    mov ah, 9
    mov dx, offset msg
    int 21h

    mov ah, 9
    mov dx, offset msg1
    int 21h

    mov ah, 0
    int 16h
    cmp al, 31h
    je Addition
    cmp al, 32h
    je Multiply
    cmp al, 33h
    je Subtract
    cmp al, 34h
    je Divide
    jmp ChoiceError

Addition:
    mov ah, 9
    mov dx, offset msg2
    int 21h
    mov cx, 0
    call InputNo
    push dx
    mov ah, 9
    mov dx, offset msg3
    int 21h
    mov cx, 0
    call InputNo
    pop bx
    add dx, bx
    push dx
    mov ah, 9
    mov dx, offset msg5
    int 21h
    mov cx, 10000
    pop dx
    call View
    jmp exit

InputNo:
    mov ah, 0
    int 16h
    mov dx, 0
    mov bx, 1
    cmp al, 0dh
    je FormNo
    sub ax, 30h
    call ViewNo
    mov ah, 0
    push ax
    inc cx
    jmp InputNo

FormNo:
    pop ax
    push dx
    mul bx
    pop dx
    add dx, ax
    mov ax, bx
    mov bx, 10
    push dx
    mul bx
    pop dx
    mov bx, ax
    dec cx
    cmp cx, 0
    jne FormNo
    ret

View:
    mov ax, dx
    mov dx, 0
    div cx
    call ViewNo
    mov bx, dx
    mov dx, 0
    mov ax, cx
    mov cx, 10
    div cx
    mov dx, bx
    mov cx, ax
    cmp ax, 0
    jne View
    ret

ViewNo:
    push ax
    push dx
    mov dx, ax
    add dl, 30h
    mov ah, 2
    int 21h
    pop dx
    pop ax
    ret

exit:
    mov ah, 4Ch
    int 21h

Multiply:
    mov ah, 9
    mov dx, offset msg2
    int 21h
    mov cx, 0
    call InputNo
    push dx
    mov ah, 9
    mov dx, offset msg3
    int 21h
    mov cx, 0
    call InputNo
    pop bx
    mov ax, dx
    mul bx
    mov dx, ax
    push dx
    mov ah, 9
    mov dx, offset msg5
    int 21h
    mov cx, 10000
    pop dx
    call View
    jmp exit

Subtract:
    mov ah, 9
    mov dx, offset msg2
    int 21h
    mov cx, 0
    call InputNo
    push dx
    mov ah, 9
    mov dx, offset msg3
    int 21h
    mov cx, 0
    call InputNo
    pop bx
    sub bx, dx      
    mov dx, bx      
    push dx
    mov ah, 9
    mov dx, offset msg5
    int 21h
    mov cx, 10000
    pop dx
    call View
    jmp exit


Divide:
    mov ah, 9
    mov dx, offset msg2
    int 21h
    mov cx, 0
    call InputNo
    push dx
    mov ah, 9
    mov dx, offset msg3
    int 21h
    mov cx, 0
    call InputNo
    pop bx
    mov ax, bx
    mov cx, dx
    mov dx, 0
    mov bx, 0
    div cx
    mov bx, dx
    mov dx, ax
    push bx
    push dx
    mov ah, 9
    mov dx, offset msg5
    int 21h
    mov cx, 10000
    pop dx
    call View
    pop bx
    cmp bx, 0
    je exit
    jmp exit

ChoiceError:
    jmp start
