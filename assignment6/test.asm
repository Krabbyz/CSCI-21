#
# assignment6ex1.asm
#
# Austin Nguyen
# 4/28/24
# Assignment 6, excercise 1
# sort an array of 10 ints provided by the user
#

	.text
	.globl main
main:	li	$s0, 0		# array index
	li	$s1, 10		# loop counter
prompt_loop:	
	beqz	$s1, sort_array	# loop 10 times
	nop
	la	$a0, prompt	# call prompt subroutine
	jal	prompt_sub
	nop
	sw	$v0, array($s0)	# store int into array
	addiu	$s0, $s0, 4	# increment array index
	addiu	$s1, $s1, -1	# decrement counter
	j	prompt_loop	# loop
	nop
sort_array:
	la	$a0, array	# call sort subroutine
	li	$a1, 10
	jal	sort
	nop
	li	$s1, 10		# reset loop counter
	la	$s2, array	# address of array
print_loop:	
	beqz	$s1, end	# loop 10 times
	nop
	move 	$a0, $s2	# call print subroutine
	jal	print		
	nop
	addiu	$s1, $s1, -1	# decrement counter
	addiu	$s2, $s2, 4	# increment array
	j	print_loop	# loop
	nop
end:	li	$v0, 10
	syscall

# prompt user for int. Passing in prompt message and returning int
# $a0 --- prompt address
prompt_sub:
	li	$v0, 4		# print prompt
	syscall	
	li	$v0, 5		# read int
	syscall
	jr	$ra		# end subroutine
	nop

# selection sort subroutine. Passing in base of array and number of elements
# $a0 --- array base
# $a1 --- num elements
# $t0 --- i
# $t1 --- min index
# $t2 --- j
# $t3 --- temp
# $t4 --- a
# $t5 --- b
# $t6 --- base+offset
sort:
	# Initialize loop variables
    li $t0, 0          # i = 0 (outer loop index)
    li $t1, 1          # j = 1 (inner loop index)

outer_loop:
    # Load array[i] into $t2
    lw $t2, 0($a0)     # array[i]

    inner_loop:
        # Load array[j] into $t3
        lw $t3, 0($a0)  # array[j]

        # Compare array[j] with array[i]
        ble $t3, $t2, skip_swap

        # Swap array[i] and array[j]
        sw $t3, 0($a0)  # array[i]
        sw $t2, 0($a0)  # array[j]

    skip_swap:
        # Increment inner loop index (j)
        addi $t1, $t1, 1
        addi $a0, $a0, 4  # Move to next element in the array

        # Check if inner loop is done
        bne $t1, $a1, inner_loop
	nop

    # Increment outer loop index (i)
    addi $t0, $t0, 1
	li	$t8, -4
	mul	$t7, $a1, $t8
    addu $a0, $a0, $t7  # Reset array pointer to the beginning

    # Check if outer loop is done
    bne $t0, $a1, outer_loop
	nop

    jr $ra  # Return
	nop

# print subroutine. Passing in address of an array element
# $a0 --- array element address
print:	lw	$t0, 0($a0)
	li	$v0, 1		# print int
	move	$a0, $t0
	syscall
	li	$v0, 4		# print tab
	la	$a0, tab
	syscall
	jr	$ra		# end subroutine
	nop

#
# DATA
#
	.data
array:	.space	40
prompt:	.asciiz	"Enter an integer: \n"
tab:	.asciiz	"	"