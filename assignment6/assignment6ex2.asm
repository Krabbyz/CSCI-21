#
# assignment6ex2.asm
#
# Austin Nguyen
# 4/29/24
# Assignment 6, excercise 2
# prompt the user for a number, n. Get n factorial
#

	.text
	.globl main
main:	li	$v0, 4		# print prompt1
	la	$a0, p1
	syscall
	li	$v0, 5		# read int
	syscall
	move	$a0, $v0
	jal	fact		# call fact
	nop
	move 	$s0, $v0
	li	$v0, 4		# print prompt2
	la	$a0, p2
	syscall
	li	$v0, 1		# print n factorial
	move	$a0, $s0
	syscall
	li	$v0, 10		# exit program
	syscall

# factorial subroutine
# $a0 --- n
# $t0 --- 1
# $t1 --- n, to be pushed onto stack
# $t2 --- i
fact:	addiu	$sp, $sp, -4		# push $ra
	sw	$ra, 0($sp)
	
	li	$t0, 1
	bgt	$a0, $t0, recursive_case	# if n > 1, go to recursive case
	nop
	
					# base case (n <= 1)
	li	$v0, 1			# return 1
	j	epilog
	nop

recursive_case:
	move	$t1, $a0		# $t1 = n
	addiu	$sp, $sp, -4		# push $t1
	sw	$t1, ($sp)
	addiu	$a0, $a0, -1		# n = n-1
	jal	fact
	nop
	move	$t2, $v0		# i = fact(n-1)
	lw	$t1, ($sp)		# pop $t1
	addiu	$sp, $sp, 4
	mul	$v0, $t2, $t1		# return i * n

epilog:	lw	$ra, 0($sp)		# pop $ra
	addiu	$sp, $sp, 4
	jr	$ra
	nop

	.data
p1:	.asciiz	"Enter an int: \n"
p2:	.asciiz	"Factorial is: \n"