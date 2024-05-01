//Backuping files a folder

; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

mov dx, offset filepath
mov ah, 39h
int 21h   

copy:  
    mov bx, counter    
    mov di,[dest+bx]
    mov si,[source+bx] 
    
    mov cx,8d
    move:
        inc si  
        mov al,[si]
        loop move
    inc si    
            
        
    copy1:
        inc di
        mov al,[di]
        cmp al,'$'
        loopne copy1
    
    mov al,[si]
    mov [di],al    
    copy_name:
        inc si
        inc di
        mov al,[si]
        mov [di],al
        cmp al,'.'
        loopne copy_name
    
    mov bx, offset ext  
    mov [bx],al
    copy_ext:   
        inc si
        inc bx 
        mov al,[si]
        mov [bx],al
        cmp al,0  
        loopne copy_ext
        
                                 
        
    mov [di],'-'
    inc di    
         
    mov ah,2Ah
    int 21h 
     
    ;date 
    ;year
    mov ax,cx
    mov bl,100
    div bl 
    mov bh,ah
    aam 
    mov bl,al
    mov al,ah
    add al,48d
    stosb 
    mov al,bl
    add al,48d
    stosb   
    mov al,bh
    aam 
    mov bl,al
    mov al,ah
    add al,48d
    stosb 
    mov al,bl
    add al,48d
    stosb
         
    ;month
    mov al,dh
    aam
    mov cl,al   
    mov al,ah
    add al,48d
    stosb
    mov al,cl
    add al,48d
    stosb
              
    ;day
    mov al,dl
    aam
    mov cl,al  
    mov al,ah
    add al,48d
    stosb
    mov al,cl
    add al,48d
    stosb
    
    
    ;time    
    mov ah,2Ch
    int 21h    
    mov ah,0
    mov al,ch
    aam
    mov cl,al 
    mov al,ah
    add al,48d
    stosb
    mov al,cl
    add al,48d
    stosb
            
    mov ah,2Ch
    int 21h    
    mov ah,0
    mov al,cl
    aam
    mov cl,al 
    mov al,ah
    add al,48d
    stosb
    mov al,cl
    add al,48d
    stosb
        
    mov ah,2Ch
    int 21h    
    mov ah,0
    mov al,dh
    aam
    mov cl,al 
    mov al,ah
    add al,48d
    stosb
    mov al,cl
    add al,48d
    stosb 
    
    ;extension 
    mov bx,offset ext
    mov al,[bx]  
    mov [di],al
    extension: 
        inc bx 
        inc di
        mov al,[bx]  
        mov [di],al
        cmp al,0
        loopne extension
             
 
    mov al,000h
    stosb
    
    
    ;create a file in destination
    mov ah, 3Ch 
    mov bx, counter
    mov dx, [dest+bx]
    mov cl,0
    int 21h   
    mov fhandle, ax
    ;close the empty dest file
    mov ah, 3Eh
    mov bx, fhandle
    int 21h  
        
      
    ; open the file to copy
    mov ah, 3Dh  
    mov bx, counter
    mov dx, [source+bx]
    mov al, 2
    int 21h
    mov fhandle, ax 
    ;copying(reading)
    mov ah, 3Fh
    lea dx, buffer
    mov cx, 1000
    mov bx, fhandle
    int 21h 
    ;close the source file
    mov ah, 3Eh
    mov bx, fhandle
    int 21h  
    
    
    ;open the dest file to paste 
    mov ah, 3Dh 
    mov bx, counter
    mov dx, [dest+bx]
    mov al, 2
    int 21h
    mov fhandle, ax 
    ;pasting(writing) 
    mov ah, 40h
    mov bx, fhandle
    lea dx, buffer
    mov cx, 1000 
    int 21h
    ;close the copied dest file       
    mov ah, 3Eh
    mov bx, fhandle
    int 21h     
    
    mov ax, counter   
    sub counter, 2
    cmp ax, 0
    jne copy

ret

source dw offset s1, offset s2, offset s3, offset s4 
s1 db "C:\mydir\add.asm",0   
s2 db "C:\mydir\stack.txt",0    
s3 db "C:\mydir\sample.txt",0
s4 db 0


dest dw offset d1, offset d2, offset d3, offset d4       
d1 dw "C:\Backup\$",0
d2 dw "C:\Backup\$",0
d3 dw "C:\Backup\$",0 
d4 dw 0 

filepath DB "C:\Backup", 0 	
str db 20,?,20 DUP(?)     
Buffer db 1000 DUP(?)
fhandle dw ?  
counter dw 4  ;0,2,4  
ext db 4 DUP(?)