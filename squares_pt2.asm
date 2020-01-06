# Will Lambrecht & Matthew Rutigliano
# Lab 3
# ECEGR 2220 Microprocessor Design
# April 30th, 2019
# Squares Part 2
	
	.data
startInt: .word 0
endInt: .word 0
sum: .word 0
i: .word 0
prompt1: .asciiz	"Start Value: "
prompt2: .asciiz "End Value: "
ending:	.asciiz	"Final sum value: "
vect:	.space	100	#allocating uninitialized space, 100 bytes (=25 words, with 4bytes per word)

	.text
	.globl main
	
main: 

	li	$v0,4		#system call for print string
	la	$a0,prompt1
	syscall
	li	$v0,5		#system call for reading integer
	syscall
	add	$s1,$v0,$zero	#save startInt in $s1
	li	$v0,4		#system call for print string
	la	$a0,prompt2
	syscall
	li	$v0,5		#system call for reading integer
	syscall
	add	$s2,$v0,$zero	#save endInt in $s2
	
	la $t0, startInt	#save startInt in $a0
	sw $s1, 0($t0)
	lw $a0, 0($t0)

	la $t1, endInt		#save endInt in $a1
	sw $s2, 0($t1)
	lw $a1, 0($t1)

	addi $sp, $sp, -4	# save $sa on stack before call
	sw  $ra, 0($sp)
	
	jal squaresum
	
	li	$v0,4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	la $t0, sum			#Loads sum into $t0 for printing
	lw $t1, 0($t0)
	
	li	$v1,4		#system call for print string
	la	$a0,ending
	syscall
	li	$v0,1		#system call for printing int in ascii
	add	$a0,$t1,$zero
	syscall
	
	jr	$ra
	
squaresum:
	slt $t0, $a1, $a0			#Checks that startInt<endInt. If not, nothing is summed
	bne $t0, $zero, output
	
	add $v0, $zero, $zero		#clear $v0
	la $t2, i					#t2 points at i
	sw $a0, 0($t2)				#i = startInt
	addi $s2, $a1, 1			#$s2 = endInt + 1
	
	sigma:
		lw $s1, 0($t2)			# $s1 = i
		beq $s1, $s2, output	# branch if i = endInt + 1
		multu $s1, $s1			# square $s1
		mflo $t0				
		mfhi $t1
		add $t0, $t0, $t1		# add mflo and mfhi together
		add $s0, $s0, $t0		# $s0 is the sum
		lw $s1, 0($t2)			# $s1 = i
		addi $s1, $s1, 1		# i++
		sw $s1, 0($t2)			
		j sigma
		
	output:
		la $t0, sum
		sw $s0, 0($t0)
		lw $v0, 0($t0)
	jr $ra