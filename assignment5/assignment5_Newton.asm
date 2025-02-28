#
# assignment5_Newton.asm
#
# Austin Nguyen
# 4/21/24
# approximating square roots
# subroutine involving Newton’s method for approximating the square root
#

	.text
	.globl main
main:	li	$v0, 4		# print prompt
	la	$a0, prompt
	syscall

	li	$v0, 5		# read int
	syscall

	mtc1	$v0, $f0	# move integer to coprocessor 1
	cvt.s.w	$f8, $f0	# convert entered integer to single precision float
	mov.s	$f12, $f8	# store it in $f12
	nop
	
	jal	squareroot	# call the squareroot subroutine

	li	$v0, 2		# display result
	mov.s	$f12, $f0
	syscall
	
	li	$v0, 10		# exit program
	syscall
#
# register use:
# $f2  ---  1.0
# $f3  ---  2.0
# $f4  ---  x : current approximation
# $f5  ---  1.0e-5 for accuracy limit
# $f6  ---  x': next approx.
# $f7  ---  temp
# $f12 ---  n
#
squareroot:
	li.s	$f2, 1.0	# constant 1.0
	li.s	$f3, 2.0	# constant 2.0
	li.s	$f4, 1.0	# x == first approx. (a guess, and 1.0 is close enough)
	li.s	$f5, 1.0e-5	# 5 figure accuracy
loop:	mov.s	$f6, $f12	# x' = n
	div.s	$f6, $f6, $f4	# x' = n/x
	add.s	$f6, $f4, $f6	# x' = x + n/x
	div.s	$f4, $f6, $f3	# x  = (1/2)(x + n/x)
	mul.s	$f7, $f4, $f4	# check: x^2
	div.s	$f7, $f12, $f7	# n/x^2
	sub.s	$f7, $f7, $f2	# n/x^2 - 1.0
	abs.s	$f7, $f7	# |n/x^2 - 1.0|
	c.lt.s  $f7, $f5	# |x^2 - n| < small ?
	bc1t	done		# yes: done
	nop
	j	loop		# next approximation
	nop
done:
	mov.s	$f0, $f4	# return result
	jr 	$ra
	nop

#
# DATA
#
	.data
n:	.float	1.0
prompt:	.asciiz	"Enter an integer for its square root\n"
# end of file