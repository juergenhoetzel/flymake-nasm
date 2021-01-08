global _start
section .data

message: db 'hello, world!', 10
section .text
_start:
	mov     rax, 1
	mov     rdi, 1
	mov     rsi, message
	mov     rdx, 14

	syscall                  ; this instruction invokes a system call
	mov raxx, 60
	xor rdi, rdi
	syscall
