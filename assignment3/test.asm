#
# assignment3ex5.asm
#
# Austin Nguyen
# 3/25/24
# assignment 3 exercise 5
# finds the smallest and largest number in an array of ints given by the user
#

.data
array: 	.space 	40  
prompt: .asciiz "Enter an integer: "
small:	.asciiz	"Smallest: "
large:	.asciiz	"\nLargest: "

	.text
	.globl main
main:
	la	$t0, array		# Load the base address of the array into $t0
	li	$t1, 10			# loop limit $t1 = 10
	li	$t2, 0			# loop counter $t2 = 0

read_loop:
	li	$v0, 4			# Print a prompt
	la	$a0, prompt			# Load the address of the prompt message
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
	li	$t2, 0			# reset counter $t2 = 0
	li	$t3, 0			# initialize 
	li	$t4, 0

second_loop:
	lw 	$t5, 0($t0)		# Load the word (integer) from the array into $a0
	nop
    	blt	$t5, $t3, smaller	# If int < smaller -> smaller = int
	nop
	bgt	$t5, $t4, larger	# If int > larger -> larger = int
	nop
	addiu	$t0, $t0, 4		# Move the base address to the next array element
	addiu	$t2, $t2, 1		# Increment the counter
	bne	$t2, $t1, second_loop 	# If we've printed less than 10 integers, loop
	nop
	b 	end

smaller:
	move	$t3, $t5		# smaller = int
	addiu	$t0, $t0, 4		# increment array
	addiu	$t2, $t2, 1		# increment counter
	bne	$t2, $t1, second_loop	# If we've printed less than 10 integers, loop
	nop
	b 	end
larger:
	move	$t4, $t5
	addiu	$t0, $t0, 4		# Move the base address to the next array element
	addiu	$t2, $t2, 1		# Increment the counter
	bne	$t2, $t1, second_loop	# If counter < 10, loop
	nop
	b 	end

end:	li	$v0, 4			# print smallest int and new line
	la	$a0, small
	syscall
	move	$a0, $t3
	li	$v0, 1
	syscall
	
	li	$v0, 4			# print largest int
	la	$a0, large
	syscall
	move	$a0, $t4
	li	$v0, 1
	syscall

	li	$v0, 10			# exit program
	syscall