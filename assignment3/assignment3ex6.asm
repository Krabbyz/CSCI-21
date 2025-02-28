#
# assignment3ex6.asm
#
# Austin Nguyen
# 3/25/24
# assignment 3 exercise 6
# prints a array in order and reverse order, using ints inputed by a user
#

.data
array: 	.space 	40
prompt: .asciiz "Enter an integer: "
tab: 	.asciiz "	"
n: 	.asciiz "\n"

	.text
	.globl main
main:	la	$t0, array		# Load the base address of the array into $t0
	li	$t1, 10			# loop limit $t1 = 10
	li	$t2, 0			# loop counter $t2 = 0

read_loop:
	li	$v0, 4			# Print a prompt
	la	$a0, prompt		# Load the address of prompt 
	syscall				# Display the prompt
    
	li	$v0, 5			# Read int from user
	syscall	
    
	sw	$v0, 0($t0)		# Store the read integer into the array
	addiu	$t0, $t0, 4		# Move the base address to the next array element
	addiu	$t2, $t2, 1		# Increment the counter
	bne	$t2, $t1, read_loop	# If counter < 10 integers, loop
	nop

	la	$t0, array		# Load the base address of the array into $t0
	li	$t1, 10			# Set $t1 to 10
	li	$t2, 0			# Reset counter

print_loop:
	lw	$a0, 0($t0)		# Print int
	li	$v0, 1	
	syscall
    
	li	$v0, 4			# Print tab
	la	$a0, tab
	syscall	
    
	addiu	$t0, $t0, 4		# Move the base address to the next array element
	addiu	$t2, $t2, 1		# Increment the counter
	bne	$t2, $t1, print_loop	# If we've printed less than 10 integers, loop

	li	$v0, 4			# Print new line
	la	$a0, n
	syscall	

	la	$t3, array		# set $t3 to left of array
	la	$t4, array+36		# set $t4 to right of array
	li	$t1, 5			# set limit to 5
	li	$t2, 0			# reset counter

reverse_loop:
	lw	$t5, 0($t3)		# Load the left value
	lw	$t6, 0($t4)		# Load the right value
	sw	$t6, 0($t3)		# Swap the left and right values
	sw	$t5, 0($t4)
    
	addiu	$t3, $t3, 4		# Move the left pointer to the right
	addiu	$t4, $t4, -4		# Move the right pointer to the left
	addiu	$t2, 1
	
    	blt	$t2, $t1, reverse_loop
	nop
	
	la	$t0, array		# Reset array, counter and limit
	li	$t1, 10
	li	$t2, 0

	b	print_reverse

print_reverse:
	lw	$a0, 0($t0)		# Print int
	li	$v0, 1	
	syscall
    
	li	$v0, 4			# Print tab
	la	$a0, tab
	syscall	
    
	addiu	$t0, $t0, 4		# Move the base address to the next array element
	addiu	$t2, $t2, 1		# Increment the counter
	bne	$t2, $t1, print_reverse	# If we've printed less than 10 integers, loop

	li $v0, 10			# Exit syscall
	syscall