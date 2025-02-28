#
# lab6.asm
#
# Austin Nguyen
# 4/24/24
# lab 6
# Taking a string and printing it without vowels by pushing/popping non-vowels onto/from stack
#
	.text
	.globl	main
main:	li	$v0, 4		# print prompt
	la	$a0, prompt	
	syscall			

	li	$v0, 8		# read string from user
	la	$a0, buffer	
	li	$a1, 128	
	syscall

	li	$v0, 4		# echo-print the string (it's not visible as entered)
	la	$a0, buffer	
	syscall

	addiu	$sp, $sp, -4	# push a NUL onto stack
	sw	$zero, ($sp)	
	li	$t1, 0		# index of first char in buffer

find_NUL_loop:	
	lb	$t0, buffer($t1)# get current char
	nop
	beqz	$t0, reverse_loop	# NUL byte = end of string
	nop
	addiu	$t1, $t1, 1	# increment the string index
	j	find_NUL_loop
	nop	

reverse_loop:
	beqz	$t1, pop_stack	# end of string
	nop
	lb	$t0, buffer($t1)
	li	$t2, 0		# index of vowels
vowel_check:
	lb	$t3, vowels($t2)	# current vowel
	beqz	$t3, push_char	# end of vowels string/not vowel
	nop
	beq	$t3, $t0, skip_char	# current = vowel
	nop
	addiu	$t2, $t2, 1	# next vowel
	j	vowel_check
	nop
push_char:
	addiu	$sp, $sp, -4	# push char into stack
	sw	$t0, ($sp)
skip_char:
	addiu	$t1, $t1, -1	# decrement string index
	j	reverse_loop
	nop

pop_stack:
	li	$t1, 0		# reset string index
pop_loop:
	lw	$t0, ($sp)	# pop stack
	addiu	$sp, $sp, 4
	sb	$t0, buffer($t1)
	beqz	$t0, done	# stack empty
	nop
	addiu	$t1, $t1, 1	# increment string index
	j 	pop_loop
	nop

done:	li	$v0, 4		# print buffer
	la	$a0, buffer
	syscall

	li	$v0, 10		# exit program
	syscall

#
# DATA
#
	.data
prompt:	.asciiz	"Enter a string\n"
vowels:	.asciiz	"aeiou"
buffer:	.space	128

## end of program