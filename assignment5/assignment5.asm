#
# assignment5.asm
#
# Austin Nguyen
# 4/21/24
# assignment 5
# Calculating distance between two points using the Pythagorean Theorem and Newton's method for approximating square roots
#
# register use:
# $f16  ---  x1
# $f17  ---  y1
# $f18  ---  x2
# $f19  ---  y2
# $f20  ---  temp
# $f21  ---  temp
#
	.text
	.globl main
main:	la	$a0, promptX1	# read x1
	jal	readFloat
	nop
	mov.s	$f16, $f0
	
	la	$a0, promptY1	# read y1
	jal	readFloat
	nop
	mov.s	$f17, $f0

	la	$a0, promptX2	# read x2
	jal	readFloat
	nop
	mov.s	$f18, $f0

	la	$a0, promptX2	# read y2
	jal	readFloat
	nop
	mov.s	$f19, $f0

	sub.s	$f20, $f18, $f16	# dx = x2 - x1
	sub.s	$f21, $f19, $f17	# dy = y2 - y1
	mul.s	$f20, $f20, $f20	# dx^2
	mul.s	$f21, $f21, $f21	# dy^2
	add.s	$f20, $f20, $f21	# dx^2 + dy^2
	
	mov.s	$f12, $f20	# sqrt(dx^2 + dy^2)
	jal	squareroot
	nop
	
	la	$a0, result	# print result text
	li	$v0, 4
	syscall
	mov.s	$f12, $f0	# print result
	li	$v0, 2
	syscall

	li	$v0, 10		# exit program
	syscall

readFloat:
	li	$v0, 4		# print prompt
	syscall
	li	$v0, 6		# read float
	syscall
	jr	$ra
	nop

#
# register use:
# $f2  ---  1.0
# $f3  ---  2.0
# $f4  ---  x : current approximation
# $f5  ---  1.0e-5 for accuracy limit
# $f6  ---  x': next approx.
# $f7  ---  temp
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
promptX1: .asciiz "Enter x-coordinate for Point 1: \n"
promptY1: .asciiz "Enter y-coordinate for Point 1: \n"
promptX2: .asciiz "Enter x-coordinate for Point 2: \n"
promptY2: .asciiz "Enter y-coordinate for Point 2: \n"
result:	.asciiz	"The distance between the points is: "
# end of file