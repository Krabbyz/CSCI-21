.data
    prompt: .asciiz "Enter a positive number (n): "

.text
.globl main

# Prompt user for input
main:	li	$v0, 6		# read float
	syscall

	mov.s	$f12, $f0
	
	li $v0, 2
    	syscall

    # Exit program
    li $v0, 10
    syscall