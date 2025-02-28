#
# assignment3ex3.asm
#
# Austin Nguyen
# 3/25/24
# assignment 3 exercise 3
# converts first letter of each word in a string to uppercase, ignore already uppercase letters
#

	.data
string:	.asciiz	"in a  Hole in the   Ground there Lived a hobbit"
n:	.asciiz "\n"

	.text
	.globl	main
main:	li	$v0, 4			# print string
	la	$a0, string
	syscall
	la	$a0, n			# print new line
	syscall
	la	$t0, string		# load address of string into $t0
	li	$t2, 32			# load $t2 with blank space for later comparison
	li	$t3, 1			# flag for first letter of word
	
# loop through string
loop:	lb	$t1, 0($t0)		# load single byte of string into $t1
	nop
	beqz	$t1, print		# if end of string -> print
	nop
	beq	$t1, $t2, spacefound	# space found -> turn flag on
	nop
	bne	$t3, $zero, checkuppercase	# first letter of word -> uppercase
	nop
	addiu	$t0, $t0, 1		# move to the next character
	b	loop

# set flag to 1
spacefound:
	nop
	li	$t3, 1			# set flag to 1
	addiu	$t0, $t0, 1		# move to the next character
	b	loop

# check if already uppercase
checkuppercase:
        nop
        li      $t4, 65                 # lower bound for uppercase letters
        li      $t5, 90                 # upper bound for uppercase letters
        blt     $t1, $t4, uppercase     # if $t1 is less than 'A', go to uppercase
        nop
        bgt     $t1, $t5, uppercase     # if $t1 is greater than 'Z', go to uppercase
        nop
        li      $t3, 0                  # letter is already uppercase, update flag
        addiu   $t0, $t0, 1             # move to the next character
        b       loop

# set letter to uppercase
uppercase:
	nop
	addiu	$t1, $t1, -32		# subtract 32 to the byte in $t1 to make it uppercase
	sb	$t1, 0($t0)		# store the byte from $t1 back into the string
	li	$t3, 0			# reset flag
	addiu	$t0, $t0, 1		# move to the next character
	b	loop

print:	nop
	li	$v0, 4			# print new string
	la	$a0, string
	syscall
	
	li	$v0, 10			# exit program
	syscall