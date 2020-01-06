# Will Lambrecht & Matthew Rutigliano
# Lab 3
# ECEGR 2220 Microprocessor Design
# April 30th, 2019
# Squares Part 1

	.data
startInt: .word 1
endInt: .word 3
sum: .word 0
i: .word 0
vect:	.space	100	#allocating uninitialized space, 100 bytes (=25 words, with 4bytes per word)

	.text
	.globl main
	
main: 
	
	la $t0, startInt
	lw $s1, 0($t0)
	la $t2, i
	sw $s1, 0($t2)
	la $t1, endInt
	lw $s2, 0($t1)
	
	slt $t0, $s2, $s1			#Checks that startInt<endInt. If not, nothing is summed
	bne $t0, $zero, output
	
	addi $s2, $s2, 1
	
	
	sigma:
		lw $s1, 0($t2)
		beq $s1, $s2, output
		multu $s1, $s1
		mflo $t0
		mfhi $t1
		add $t0, $t0, $t1
		add $s0, $s0, $t0		# $s0 is the sum
		lw $s1, 0($t2)
		addi $s1, $s1, 1		# i++
		sw $s1, 0($t2)
		j sigma
		
	output:
		la $t0, sum
		sw $s0, 0($t0)
			
	jr	$ra