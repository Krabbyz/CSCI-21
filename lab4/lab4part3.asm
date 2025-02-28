#
# lab4part3.asm
#
# Austin Nguyen
# 3/24/24
# lab 4 part 3
# multiplication by shifting and adding
#

	.data
print1:	.asciiz	"Enter the first positive integer: "
print2:	.asciiz	"Enter the second positive integer: "
res1:	.asciiz	"Result from shifting and adding: "
res2:	.asciiz	"\nResult from using mult: "

	.text
	.globl	main
main:	li	$v0, 4			# prompt user for int 1
	la	$a0, print1	
	syscall
	li	$v0, 5			# read int 1
	syscall
	move	$t0, $v0
	li	$v0, 4			# prompt user for int 2
	la	$a0, print2	
	syscall
	li	$v0, 5			# read int 2
	syscall
	move	$t1, $v0

	li	$t2, 0			# initialize $t2/shift add result to 0

	mult	$t0, $t1		# multiply using mult
	mflo	$t3			# store in $t3

shiftadd:
	andi	$t4, $t1, 1		# check if int2 is odd
	beq	$t4, $zero, shift	# if not odd -> shift
	nop
	addu	$t2, $t0, $t2		# if odd -> add int1 to result and shift

shift:	sll	$t0, $t0, 1		# shift int1 left
	srl	$t1, $t1, 1		# shift int2 right
	bne	$t1, $zero, shiftadd	# go back to add if t1 != 0
	nop

	li	$v0, 4			# print result from shifting and adding
	la	$a0, res1
	syscall
	li 	$v0, 1
	move	$a0, $t2
	syscall

	li	$v0, 4			# print result from using mult
	la	$a0, res2
	syscall
	li 	$v0, 1
	move	$a0, $t3
	syscall

	li 	$v0, 10			# exit program
	syscall

