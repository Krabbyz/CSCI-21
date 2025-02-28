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
sort:	li	$t0, 0		# i = 0
	li	$t3, 4
	mul	$a1, $a1, $t3	# $a1 = $a1 * 4 = 40, for indexing
s_loop1:
	bge	$t0, $a1, s_loop1_end	# loop until i >= 40
	nop
	move	$t1, $t0	# min = i
	move	$t2, $t0	# j = i	
	nop
s_loop2:
	bge	$t2, $a1, s_loop2_end	# loop until j >= 40
	nop
	addu	$t6, $a0, $t2
	lw	$t4, 0($t6)	# a = array[j]
	nop
	addu	$t6, $a0, $t1
	lw	$t5, 0($t6)	# b = array[min]
	bge	$t4, $t5, endif	# if(a < b)
	nop
	move	$t1, $t2	# min = j
	addu	$t6, $a0, $t1
	lw	$t5, 0($t6)	# b = array[min]
endif:	addiu	$t2, 4		# increment j
	j 	s_loop2		# loop
	nop
s_loop2_end:
				# swap array[i] and array[min]
	addu	$t6, $a0, $t1
	lw	$t5, 0($t6)	# b = array[min]
	addu	$t6, $a0, $t0
	lw	$t3, 0($t6)	# temp = array[i]
	addu	$t6, $a0, $t0
	sw	$t5, 0($t6)	# array[i] = b
	addu	$t6, $a0, $t1
	sw	$t3, 0($t6)	# array[min] = temp
	addiu	$t0, 4		# increment i
	j 	s_loop1		# loop
	nop
s_loop1_end:
	jr	$ra		# end subroutine
	nop

# print subroutine. Passing in address of an array element
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