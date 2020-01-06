	.data
begn:	.asciiz	"Velocity as integer m/sec:"
cont:	.asciiz "Angle as integer 0-90:"
time:	.asciiz	"Time of flight is:"
decpnt:	.asciiz	"."
fract:
	.word	0
	.word	1000
	.word	1250
	.word	1875
	.word	2500
	.word	3125
	.word	3750
	.word	4375
	.word	5000
	.word	5625
	.word	6250
	.word	6875
	.word	7500
	.word	8125
	.word	8750
	.word	9375
grav:	.word	0x009d
sine:	.word	0x0000,0x0001,0x0002,0x0003,0x0004,0x0005,0x0007,0x0008
	.word	0x0008,0x0009,0x000a,0x000b,0x000c,0x000d,0x000d,0x000e
	.word	0x000e,0x000f,0x000f,0x0010,0x0010,0x0010,0x0010,0x0010
vect:	.space	100	#allocating uninitialized space, 100 bytes (=25 words, with 4bytes per word)
	.text
	.globl	main		# global so the operating system can find it.
main:	addi	$sp, $sp, -4	# save $sa on stack before call
	sw 	$ra, 0($sp)	
	addi	$a0, $zero, 12	# the 1st of the two parameter
	addi	$a1, $zero, 9	# the 2nd of the two parameter
	jal	fixed		# the call to the function
	lw	$ra, 0($sp)	# restore $ra
	addi	$sp, $sp, 4

	jr	$ra
#----------------------------------------------------------------
# time = velocity*sin(angle)*2/g
# range = time*velocity*cos(angle)
	.globl	fixed
fixed:
	li	$v0,4		#system call for print string
	la	$a0,begn
	syscall
	li	$v0,5		#system call for reading integer
	syscall
	add	$t2,$v0,$zero	#save velocity in $t2
	sll	$t2,$t2,4	#adjust for 4 bits of fractional
	li	$v0,4		#system call for print string
	la	$a0,cont
	syscall
	li	$v0,5		#system call for reading integer
	syscall
	add	$t3,$v0,$zero	#save angle in $t3
	sll	$t3,$t3,4	#adjust for 4 bits of fractional
# time = velocity*sin(angle)*2/g
	la	$t4,sine
	srl	$t3,$t3,2	#divide angle by 4 to round off
	sll	$t3,$t3,2	#mult by 4 to be an index
	add	$t6,$t4,$t3
	lw	$t5,0($t6)	#sine(angle) in $t6
	mult	$t2,$t5		#(HI,LO) = velocity*sine(angle)
	mflo	$t7		#move to $t7, least 8 bits fractional
	sll	$t7,$t7,1	#$t7=velocity*sine(angle)*2
	la	$t0,grav
	lw	$t0,0($t0)	#$t0=gravity=9.8
	divu	$t7,$t0		#time in HI
	mfhi	$t7		#$t7=time, least 4 bits fractional
	ori	$t1,$t7,0x0000000f	#fractional part of time
	sll	$t1,$t1,2	#mult by 4 to act as index
	srl	$t7,$t7,4	#integer part of time
	li	$v0,4		#system call for print string
	la	$a0,time
	syscall
	li	$v0,1		#system call for printing int in ascii
	add	$a0,$t7,$zero
	syscall
	li	$v0,4		#system call for print string
	la	$a0,decpnt
	syscall
	li	$v0,1		#system call for printing int in ascii
	la	$t0,fract
	add	$t0,$t0,$t3
	lw	$a0,0($t0)	#$a0 has representation of fractional part
	syscall

	jr	$ra
#-----------------------------------------------------------------