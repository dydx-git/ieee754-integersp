.data
	msg1:	.asciiz "Enter decimal number: "
	msg2:	.asciiz "The IEEE-754 Single Precision equivalent is: "

.text

.globl main
.ent main
main:	
	addi $v0, $zero, 4
	la $a0, msg1
	syscall					# prints msg1 to console

	addi $v0, $zero, 5
	syscall					# takes integer input 
	add $s0, $zero, $v0		# saves input in $s0

	addi $v0, $zero, 4
	la $a0, msg2
	syscall					# prints msg2 to console

	jal SIGN

	li $v0, 1
	add $a0, $a0, $zero	
	syscall					# displays the value of $a0

	jal ZEXCP

	add $s7, $zero, $s0		# $s7 = $s0

	jal LEN

	addi $s0, $s1, 127		# add 127 to the length of binary input in $s0
	add $s2, $zero, $s0		# which is the exponent so essentially
							# $s0 = 127 + exp
	jal LEN

	add $s0, $zero, $s2		# $s0 = $s2
	li $t0, 128

	addi $v0, $zero, 1

	jal BIN

	add $s0, $zero, $s7
	add $s2, $zero, $s0

	jal LEN

	addi $t0, $zero, 1
	add $s0, $zero, $s2

	add $s7, $zero, $s1

	addi $s1, $s1, -1
	sll $t0, $t0, $s1

	jal BIN

	add $s6, $zero, 23
	sub $s7, $s6, $s7
	add $a0, $zero, $zero

	jal REP

	addi $v0, $zero, 10
	syscall
.end main


.globl ZEXCP
.ent ZEXCP
ZEXCP:
	bne $s0, $zero, ZEXCPL
	add $a0, $zero, $zero

	li $v0, 10
	syscall
	
ZEXCPL:	
	jr $ra

.end ZEXCP


.globl SIGN
.ent SIGN
SIGN:	
	slt $t0, $s0, $zero		# checks if the input is less than zero
	bne $t0, $zero, NEG 	# jumps to NEG if $t0 != 0 as input < 0 

	add $a0, $zero, $zero	# saves $a0 = 0

	jr $ra

NEG:	
	addi $t0, $zero, 2		# since $t0 = 1, hence $t0 = 3
	mult $s0, $t0			# multiplies input with 3
	mflo $t0				# saves product in $t0
	sub $s0, $s0, $t0		# this essentially makes a -ve into +ve

	addi $a0, $zero, 1		# saves $a0 = 1

	jr $ra
.end SIGN


.globl LEN
.ent LEN
LEN:	
	add $s1, $zero, $zero	# initializes $s1 = 0
	addi $t0, $zero, 2		

LLOOP:	
	div $s0, $t0			
	mflo $s0				# storing division quotient in $s0
	beq $s0, $zero, LENL	# this block of code essentially calculates
	addi $s1, $s1, 1		# the length of converted binary number
	j LLOOP					# using a loop

LENL:	
	jr $ra
.end LEN


.globl BIN
.ent BIN
BIN:	
	li $s3, 1
	add $a0, $s3, $zero
	syscall
	addi $s1, $s1, -1
	srl $t0, $t0, 1
	beq $t0, $zero, BINL
	j BIN

BINL:	jr $ra
.end BIN


.globl REP
.ent REP
REP:	syscall
	addi $s7, $s7, -1
	beq $s7, $zero, REPL
	j REP

REPL:	jr $ra
.end REP