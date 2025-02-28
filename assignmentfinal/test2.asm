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

	mfc0	$s0, $12		# turn on bits 0, 10, 11, 15 in Status Register
	ori	$s0, $s0, 0x8C01
	mtc0	$s0, $12		# move new value to Status Register

	li	$s1, 0xFFFF0000		# load address of Receiver Control Register	
	ori	$s2, $s1, 0x2		# turn on interrupt enable bit
	sw	$s2, 0($s1)		# move new value to Receiver Control Register

	la	$a0, display
	li	$v0, 4
	syscall
	
loop:	lw	$s3, var 		# loop until user terminates with 'q'
	bnez	$s3, end
	nop
	j	loop
	nop
end:	lb	$a0, index
	li	$v0, 1
	syscall
	li	$v0, 10			# exit program
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

	.kdata
savedat:.space	4
t0:	.word	0
t1:	.word	0
t2:	.word	0
t3:	.word	0
t4:	.word	0
t5:	.word	0
t6:	.word	0
t7:	.word	0
t8:	.word	0
t9:	.word	0
s0:	.word	0
a0:	.word	0
v0:	.word	0
index:	.word	0
	.ktext	0x80000180
interrupthandler:
	sw	$t0, t0			# save registers
	sw	$t1, t1
	sw	$t2, t2
	sw	$t3, t3
	sw	$t4, t4
	sw	$t5, t5
	sw	$t6, t6
	sw	$t7, t7
	sw	$t8, t8
	sw	$t9, t9
	sw	$s0, s0
	sw	$a0, a0
	sw	$v0, v0

	.set	noat
	move	$t0, $at
	.set	at
	sw	$t0, savedat

	mfc0	$t0, $13		# check for interrupt
	srl	$t1, $t0, 2
	andi	$t1, $t1, 0x1f
	bne	$t1, $zero, idone
	nop

handleoutput:
	li	$t1, 0xFFFF0000
	lw	$t2, index
	la	$t3, display
	nop
	addu	$t3, $t3, $t2
	lb	$t4, 0($t3)	# get char
	nop

	sw	$t4, 12($t1)		# display char
	addiu	$t2, $t2, 1		# next char
	
	bne	$t4, 10, updateindex	# not \n, update index
	nop
	li	$t2, 0			# is \n, reset and update index
	nop
updateindex:
	sw	$t2, index
	
idone:	lw	$t0, savedat
	.set	noat
	move	$at, $t0
	.set 	at
	
	lw	$a0, a0
	lw	$v0, v0
	lw	$s0, s0
	lw	$t9, t9
	lw	$t8, t8			# restore registers
	lw	$t7, t7
	lw	$t6, t6
	lw	$t5, t5	
	lw	$t4, t4
	lw	$t3, t3
	lw	$t2, t2	
	lw	$t1, t1
	lw	$t0, t0

	eret
