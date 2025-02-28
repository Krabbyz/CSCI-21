#
# assignment3ex1.asm
#
# Austin Nguyen
# 3/24/24
# assignment 3 exercise 1
# converts all characters in a string to lowercase
#

	.data
string:	.asciiz	"ABCDEFG"
n:	.asciiz "\n"

	.text
	.globl	main
main:	li	$v0, 4			# print string
	la	$a0, string
	syscall
	la	$a0, n			# print new line
	syscall
	la	$t0, string		# load address of string into $t0

loop:	lb	$t1, 0($t0)		# load single byte of string into $t1
	nop
	beqz	$t1, print		# if end of string -> print
	addiu	$t1, $t1, 0x20		# add 32 to the byte to make it lowercase
	sb	$t1, 0($t0)		# store the byte from $t1 back into the string
	addiu	$t0, $t0, 1		# move to the next character
	b	loop			# repeat loop until end of string

print:	li	$v0, 4			# print new string
	la	$a0, string
	syscall

	li	$v0, 10			# exit program
	syscall