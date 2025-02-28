#
# lab7.asm
#
# Austin Nguyen
# 5/12/24
# Lab 8
# polling
#
	.text
	.globl 	main
main:	la	$a0, source		# copy source to display
	la	$a1, display
	jal	replace
	nop

	li	$s3, 0			# index for display
	li	$s0, 0xffff0000		# base of memory-mapped IO area
loop:	lw	$s1, 0($s0)		
	nop
	andi	$s1, $s1, 1		# check ready bit
	beqz	$s1, checkdisplay	# not ready, go to check display
	nop
	lw	$s2, 4($s0)		# extract char
	nop
	beq	$s2, 's', sfound	# check char
	nop
	beq	$s2, 't', tfound
	nop
	beq	$s2, 'a', afound
	nop
	beq	$s2, 'r', rfound
	nop
	beq	$s2, 'q', qfound
	nop
	j	checkdisplay		# if not s,t,a,r,q, go to check display
	nop
sfound:	la	$a0, display		# s pressed, sort display then go to check display
	jal	sort
	nop
	j	checkdisplay
	nop
tfound:	la	$a0, display		# t pressed, toggle display then go to check display
	jal	toggle
	nop
	j	checkdisplay
	nop
afound:	la	$a0, source		# a pressed, replace display with source then go to check display
	la	$a1, display
	jal	replace
	nop
	j	checkdisplay
	nop
rfound:	la	$a0, display		# r pressed, reverse display then go to check display
	jal	reverse
	nop
	j	checkdisplay
	nop
qfound:	jal	terminate		# q pressed, terminate program
	nop
checkdisplay:
	lw	$s1, 8($s0)
	nop
	andi	$s1, $s1, 1		# check ready bit
	beqz	$s1, loop		# not ready, loop
	nop
	lb	$s2, display($s3)	# extract char from display
	nop
	beqz	$s2, nulfound		# if nul found, reset display index
	nop
	sw	$s2, 12($s0)		# write char to display
	addiu	$s3, $s3, 1		# increment display index
	j	loop			# loop
	nop
nulfound:
	li	$s3, 0			# reset display index
	j	loop			# loop
	nop

# 's', bubble sort subroutine. display in $a0
sort:	li	$t0, 0			# num elements counter
	move	$t2, $a0
sloop:	lb	$t5, 0($t2)		# loop to find num elements
	nop
	beq	$t5, 10, sloopend	# if \n, end loop
	nop
	addiu	$t0, $t0, 1		# increment counter
	addiu	$t2, $t2, 1		# next position in display
	j	sloop			# loop until \n
	nop
sloopend:
	addiu	$t1, $t0, -1
	li	$t3, 0			# i = 0
	nop
sloop1:	bge	$t3, $t0, sdone		# i >= n, done
	nop
	move	$t2, $a0		# set/reset display address
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
sdone:	jr	$ra
	nop

# 't', subroutine to toggle the case of every alphabetical char. display in $a0
toggle:	move	$t0, $a0		# load address of display in $t0
	li	$t1, 'A'		# lower bound for uppercase
	li	$t2, 'Z'		# upper bound for uppercase
	li	$t3, 'a'		# lower bound for lowercase
	li	$t4, 'z'		# upper bound for lowercase
tloop:	lb	$t5, 0($t0)		# load char from display
	nop
	beq	$t5, 10, tdone		# exit when \n 
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
tdone:	jr	$ra
	nop

# 'a', subroutine to replace display with source. source in $a0, display in $a1
replace:
	move	$t0, $a0		# load address of source in $t0
	move	$t1, $a1		# load address of display in $t1
rloop:	lb	$t2, 0($t0)		# load char from source into $t2
	nop
	beqz	$t2, rdone		# exit when reaching \n
	nop
	sb	$t2, 0($t1)		# store char into display
	addiu	$t0, $t0, 1		# next char in source 
	addiu	$t1, $t1, 1		# next position in display
	j	rloop			# repeat until \n
	nop
rdone:	jr 	$ra			
	nop

# 'r', subroutine to reverse the elements. display in $a0
reverse:
	move 	$t0, $a0		# load address of display in $t0
	li	$t1, 0			# counter
rvloop1:
	lb	$t2, 0($t0)		# load char from display into $t2
	nop
	beq	$t2, 10, rvloop1end	# end loop when \n
	nop
	addiu	$sp, $sp, -4		# push char onto stack
	sw	$t2, 0($sp)
	addiu	$t1, $t1, 1		# increment counter
	addiu	$t0, $t0, 1		# next char in display
	j	rvloop1			# repeat until \n
	nop
rvloop1end:
	move 	$t0, $a0		# reset address
rvloop2:
	beqz	$t1, rvdone		# end when counter = 0
	nop
	lw	$t3, 0($sp)		# pop into position in display
	addiu	$sp, $sp, 4
	sb	$t3, 0($t0)
	addiu	$t1, $t1, -1		# increment counter
	addiu	$t0, $t0, 1		# next position in display
	j 	rvloop2			# repeat until counter = 0
	nop
rvdone:	jr 	$ra
	nop

# 'q', exit program
terminate:
	li	$v0, 10			# exit program
	syscall

	.data
source:	.asciiz	"aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789!?,.;:$&\n"
display:
	.space	100