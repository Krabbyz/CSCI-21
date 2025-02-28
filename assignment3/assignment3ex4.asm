#
# assignment3ex4.asm
#
# Austin Nguyen
# 3/25/24
# assignment 3 exercise 4
# exchanges case of each letter in a string
#

	.data
prompt:	.asciiz	"Enter a string: "
string: .space	256
n:	.asciiz "\n"

	.text
	.globl	main
main:	li 	$v0, 4			# print prompt
	la 	$a0, prompt
	syscall

	li	$v0, 8			# read string from user
	la	$a0, string 
	li	$a1, 256
	syscall	

	li	$v0, 4			# print string
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
	beq	$t1, $t2, spacefound	# space found -> next character
	nop
	b	 checkuppercase		# not a space -> uppercase

# space found
spacefound:
	nop
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
        b	lowercase		# else lowercase

# set letter to uppercase
uppercase:
	nop
	addiu	$t1, $t1, -32		# subtract 32 to the byte in $t1 to make it uppercase
	sb	$t1, 0($t0)		# store the byte from $t1 back into the string
	addiu	$t0, $t0, 1		# move to the next character
	b	loop

lowercase:
	nop
	addiu	$t1, $t1, 32		# subtract 32 to the byte in $t1 to make it uppercase
	sb	$t1, 0($t0)		# store the byte from $t1 back into the string
	addiu	$t0, $t0, 1		# move to the next character
	b	loop

print:	nop
	li	$v0, 4			# print new string
	la	$a0, string
	syscall
	
	li	$v0, 10			# exit program
	syscall