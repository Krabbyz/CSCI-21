#
# assignment1-1.asm
#
# Austin Nguyen
# 2/19/24
# assignment 1, exercise 1
# using ori once to create a single bit, creates 0xA5A5A5A5 and puts it into register $t1
#
	.text
	.globl	main
main:	ori	$t0, $zero, 0x01
	sll	$t1, $t0, 2
	or	$t1, $t1, $t0
	sll	$t1, $t1, 3
	or	$t1, $t1, $t0
	sll	$t1, $t1, 2
	or	$t1, $t1, $t0
	sll	$t0, $t1, 8
	or	$t1, $t1, $t0
	sll	$t0, $t1, 16
	or	$t1, $t1, $t0

## End of File