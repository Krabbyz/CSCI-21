#
# lab4part1.asm
#
# Austin Nguyen
# 3/13/24
# lab 4 part 1
# while loop, do while, for loop, if, if else
#

	.text
	.globl	main
main:	li	$t0, 0			# while loop
	li	$t1, 0
	li	$t2, 10
loop:	bge	$t0, $t2, end
	addu	$t1, $t1, $t0
	addiu	$t0, 1
	blt	$t0, $t2, loop2
	nop
end:

	li	$t0, 0			# do while loop
	li	$t1, 0
loop2:	addu	$t1, $t1, $t0
	addiu	$t0, 1
	blt	$t0, $t2, loop2
	nop

	li	$t0, 0			# for loop
	li	$t1, 0
loop3:	bge	$t0, $t2, end2
	addu	$t1, $t1, $t0
	addiu	$t0, 1
	blt	$t0, $t2, loop3
	nop
end2:

	li	$t0, 0			# if
	li	$t1, 0
	bgt	$t0, $t1, endifelse
	nop
	li	$t1, 10
endifelse:	

	li	$t0, 0			# if else
	li	$t1, 0
	bgt	$t0, $t1, else2
	nop
	li	$t1, 10
	beqz	$zero, endifelse2
	nop
else2:	li	$t0, 20
endifelse2:
	
	li 	$v0, 10
	syscall

