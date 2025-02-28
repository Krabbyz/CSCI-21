#
# finalproject.asm
#
# Austin Nguyen
# 5/13/24
# final project
# interrupt driven memory mapped IO
# memory-mapped I/O on, branch and load delays off
#
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
	
loop:	lw	$s3, var 		# loop until user terminates with 'q'
	bnez	$s3, end
	nop
	j	loop
	nop
end:	li	$v0, 10			# exit program
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
	nop


# data
	.data
source:	.asciiz	"aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789!?,.;:$&\n"
display:.space	100
var:	.word	0
index:	.word	0


# interrupt handler
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
	li	$t2, 0xFFFF0000		# load address of Receiver Control Register	
	xori	$t3, $t2, 0x2		# turn off interrupt enable bit
	sw	$t3, 0($t2)		# move new value to Receiver Control Register
	
	li 	$t1, 0xffff0008 	# Load the address of the Transmitter Control Register
   	lw 	$t2, 0($t1)             # Load the current value of the Transmitter Control Register        
  	ori 	$t2, $t2, 0x00000002    # Set bit 0
  	sw 	$t2, 0($t1)

	li	$t1, 0xffff0000		# base of memory-mapped IO area
	lw	$t4, 8($t1)		# extract transmitter control
	nop
	andi	$t4, $t4, 1		# mask off ready bit
	beqz	$t4, handleinput	# not set
	nop
	
	lw	$t2, index
	lb	$t3, display($t2)	# get char
	nop
	
	sw	$t3, 12($t1)		# display char
	addiu	$t2, $t2, 1		# next char
	
	bne	$t3, 10, updateindex	# not \n, update index
	nop
	li	$t2, 0			# is \n, reset and update index
	nop
updateindex:
	sw	$t2, index
	
handleinput:
	srl	$t1, $t0, 11		# check bit 11 of Cause Register
	andi	$t1, $t1, 0x1
	beqz	$t1, idone		# bit 11 is not on
	nop

	li	$t1, 0xFFFF0000		# extract char
	lw	$t2, 4($t1)

	beq	$t2, 's', sort		# check char
	nop
	beq	$t2, 't', toggle
	nop
	beq	$t2, 'a', replace
	nop
	beq	$t2, 'r', reverse
	nop
	beq	$t2, 'q', terminate
	nop

	j	idone
	nop

# 's', bubble sort
sort:	li	$t0, 0			# num elements counter
	la	$t2, display
sloop:	lb	$t1, 0($t2)		# loop to find num elements
	nop
	beq	$t1, 10, sloopend	# if \n, end loop
	nop
	addiu	$t0, $t0, 1		# increment counter
	addiu	$t2, $t2, 1		# next position in display
	j	sloop			# loop until \n
	nop
sloopend:
	addiu	$t1, $t0, -1
	li	$t3, 0			# i = 0
	nop
sloop1:	bge	$t3, $t0, idone		# i >= n, done
	nop
	la	$t2, display		# set/reset display address
	li	$t4, 0			# j = 0
	nop
sloop2:	bge	$t4, $t1, sendloop2	# j >= n-1, sendloop2
	nop
	lb	$t6, 0($t2)		
	lb	$t7, 1($t2)
	ble	$t6, $t7, sskip
	nop
	sb	$t6, 1($t2)		# swap if display[j] > display[j+1]
	sb	$t7, 0($t2)
sskip:	addiu	$t4, $t4, 1		# increment j
	addiu	$t2, $t2, 1		# next position in display
	j	sloop2			# loop
	nop
sendloop2:
	addiu	$t3, $t3, 1		# increment i
	j	sloop1
	nop

# 't' toggle alphabetical characters in display
toggle:	la	$t0, display		# load address of display in $t3
	li	$t1, 'A'		# lower bound for uppercase
	li	$t2, 'Z'		# upper bound for uppercase
	li	$t3, 'a'		# lower bound for lowercase
	li	$t4, 'z'		# upper bound for lowercase
tloop:	lb	$t5, 0($t0)		# load char from display
	nop
	beq	$t5, 10, idone		# exit when \n 
	nop
	blt	$t5, $t1, tendloop	
	nop
	bgt	$t5, $t2, tlowercase
	nop
	j	tuppercase		# jump to uppercase when 'A' <= $t5 <= 'Z' 
	nop
tlowercase:
	blt	$t5, $t3, tendloop	# jump when not in bounds
	nop
	bgt	$t5, $t4, tendloop
	nop
	addiu	$t5, $t5, -32		# toggle
	sb	$t5, 0($t0)
	j	tendloop
	nop
tuppercase:
	addiu	$t5, $t5, 32		# toggle
	sb	$t5, 0($t0)
	j	tendloop
	nop
tendloop:
	addiu	$t0, $t0, 1		# next position in display
	j	tloop
	nop

# 'a' replace display with source
replace:
	la	$t0, source		# load address of source in $t0
	la	$t1, display		# load address of display in $t1
rloop:	lb	$t2, 0($t0)		# load char from source into $t2
	nop
	beqz	$t2, idone		# exit when reaching \n
	nop
	sb	$t2, 0($t1)		# store char into display
	addiu	$t0, $t0, 1		# next char in source 
	addiu	$t1, $t1, 1		# next position in display
	j	rloop			# repeat until \n
	nop

# 'r' reverse display
reverse:
	la	$t0, display		# start of display
	la	$t1, display		# end of display
rvloop1:				# loop to find end of display
	lb	$t2, 0($t1)		
	nop
	beq	$t2, 10, rvloop1end	# \n found, end loop 
	nop
	addiu	$t1, $t1, 1
	j	rvloop1
	nop
rvloop1end:
	addiu	$t1, $t1, -1		# go to before \n
rvloop2:
	bgt	$t0, $t1, idone		# stop when start is greater than end
	nop
	lb	$t2, 0($t0)		# load char at start
	lb	$t3, 0($t1)		# load char at end
	sb	$t2, 0($t1)		# swap start and end
	sb	$t3, 0($t0)
	addiu	$t0, $t0, 1		# increment start
	addiu	$t1, $t1, -1		# decrement end
	j	rvloop2
	nop
	
# 'q' terminate program
terminate:
	li	$t0, 1
	sb	$t0, var

idone:	lw	$t0, savedat
	.set	noat
	move	$at, $t0
	.set 	at

	lw	$t7, t7
	lw	$t6, t6
	lw	$t5, t5	
	lw	$t4, t4
	lw	$t3, t3
	lw	$t2, t2	
	lw	$t1, t1
	lw	$t0, t0

	eret