#
# lab3.asm
#
# Austin Nguyen
# 2/21/24
# lab 3
# testing or, and, xor, nor, not, sll, srl, sra on bit patterns
#
	.text
	.globl	main
main:	ori	$t0, $zero, 0x1234	# using or, and, xor, nor, not on 0x1234 and 0xFFFF
	ori	$t1, $zero, 0xFFFF
	or	$t2, $t0, $t1
	and	$t3, $t0, $t1
	xor	$t4, $t0, $t1
	nor	$t5, $t0, $t1
	not 	$t6, $t0
	not 	$t7, $t1
	
	xor	$t0, $t0, $t0		# clearing registers $t1, $t2
	xor	$t1, $t1, $t1
	ori	$t0, $zero, 0xFEDC	# using or, and, xor, nor, not on 0x1234 and 0xFFFF
	ori	$t1, $zero, 0x5678
	or	$t2, $t0, $t1
	and	$t3, $t0, $t1
	xor	$t4, $t0, $t1
	nor	$t5, $t0, $t1
	not 	$t6, $t0
	not 	$t7, $t1

	li	$t0, 0xFFFFFFFF		# using sll, srl, sra on 0xFFFFFFFF to move the pattern left or right 2, 3, 4 and 5 places
	sll	$t1, $t0, 2
	sll	$t2, $t0, 3
	sll	$t3, $t0, 4
	sll	$t4, $t0, 5
	srl	$t5, $t0, 2
	srl	$t6, $t0, 3
	srl	$t7, $t0, 4
	srl	$s0, $t0, 5
	sra	$s1, $t0, 2
	sra	$s2, $t0, 3
	sra	$s3, $t0, 4
	sra	$s4, $t0, 5

	li	$t0, 0x96969696		# using sll, srl, sra on 0x96969696 to move the pattern left or right 2, 3, 4 and 5 places
	sll	$t1, $t0, 2
	sll	$t2, $t0, 3
	sll	$t3, $t0, 4
	sll	$t4, $t0, 5
	srl	$t5, $t0, 2
	srl	$t6, $t0, 3
	srl	$t7, $t0, 4
	srl	$s0, $t0, 5
	sra	$s1, $t0, 2
	sra	$s2, $t0, 3
	sra	$s3, $t0, 4
	sra	$s4, $t0, 5

	li	$t0, 0x87654321		# using sll, srl, sra on 0x87654321 to move the pattern left or right 2, 3, 4 and 5 places
	sll	$t1, $t0, 2
	sll	$t2, $t0, 3
	sll	$t3, $t0, 4
	sll	$t4, $t0, 5
	srl	$t5, $t0, 2
	srl	$t6, $t0, 3
	srl	$t7, $t0, 4
	srl	$s0, $t0, 5
	sra	$s1, $t0, 2
	sra	$s2, $t0, 3
	sra	$s3, $t0, 4
	sra	$s4, $t0, 5

## End of File