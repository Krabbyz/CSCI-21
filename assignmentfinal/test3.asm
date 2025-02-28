	.text
	.globl 	main
main:	addiu	$sp, $sp, -4		# caller prolog, push source as argument
	la	$s0, source
	nop
	sw	$s0, 0($sp)
	addiu	$sp, $sp, -4		# push display as argument
	la	$s0, display	
	nop
	sw	$s0, 0($sp)
	jal	copy			# copy source to display
	nop
	addiu	$sp, $sp, 8		# deallocate space for parameters

	la	$a0, display
	li	$v0, 4
	syscall
	
	li	$t1, 0
	li	$t4, 0xFFFF0000
loop:	lw	$s1, 8($t4)
	nop
	andi	$s1, $s1, 1
	beqz	$t1, loop

	la	$a1, display
	addu	$a1, $a1, $t1
	lb	$t2, 0($a1)
	
	sw	$t2, 12($t4)

	la	$a0, nl
	li	$v0, 4
	syscall

	addiu	$t1, $t1, 1
	beq	$t1, 70, end
	nop
	j	loop
	nop

end:	li	$v0, 10
	syscall

# subroutine to copy source to diaply using a "real-world" calling convention
copy:	addiu	$sp, $sp, -4		# callee prolog, push return address
	sw	$ra, 0($sp)
	addiu	$sp, $sp, -4		# push callers frame pointer
	sw	$fp, 0($sp)
	addiu	$fp, $sp, 0
	move	$sp, $fp		# end of callee prolog
	lw	$t0, 12($fp)		# get source parameter
	lw	$t1, 8($fp)		# get display parameter
	lb	$t2, 0($t0)
base:	bne	$t2, 10, recursive	# skip if source byte is not \n
	nop
	sb	$t2, 0($t1)		# store \n in display and return
	j	epilog
	nop
recursive:
	sb	$t2, 0($t1)		# store source byte in display
	addiu	$t0, $t0, 1		# next position in source and display
	addiu	$t1, $t1, 1
	addiu	$sp, $sp, -4		# caller prolog, push next position in source as argument
	sw	$t0, 0($sp)
	addiu	$sp, $sp, -4		# push next position in display as argument
	sw	$t1, 0($sp)
	jal	copy
	nop
	addiu	$sp, $sp, 8		# deallocate space for parameters
epilog:	lw	$fp, 0($sp)		# pop frame pointer
	addiu	$sp, $sp, 4
	lw	$ra, 0($sp)		# pop return address
	addiu	$sp, $sp, 4
	jr	$ra

	.data
source:	.asciiz	"aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789!?,.;:$&\n"
nl:	.asciiz	"\n"
display:.space	100
var:	.word	0
index: 	.word	0