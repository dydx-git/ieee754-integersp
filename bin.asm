.data
msg1:	.asciiz "\nEnter decimal number: "
msg2:	.asciiz "The IEEE-754 Single Precision equivalent is: "
msg3:	.asciiz "\nThis may happen if you either entered 0 or a non-integer."
msg4:	.asciiz "\nWould you like to run the program again? Y or N? "
msg5:	.asciiz "\nProgram terminated =( Reload to run again"

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

	jal signDecider

	li $v0, 1
	add $a0, $a0, $zero	
	syscall					# displays the value of $a0

	jal zeroException

	add $a1, $zero, $s0     # $a1 = $s0

	jal lengthCalculator

	addi $s0, $s1, 127      # add 127 to the length of binary input in $s0
	add $a2, $zero, $s0     # which is the exponent so essentially
							# s0 = 127 + exp
	jal lengthCalculator

	add $s0, $zero, $a2		# $s0 = $a2
	li $t0, 128

	addi $v0, $zero, 1

	jal toBinary

	add $s0, $zero, $a1		# $s0 = $a1
	add $a2, $zero, $s0		# $a2 = $s0

	jal lengthCalculator

	addi $t0, $zero, 1		# $t0 = 1
	add $s0, $zero, $a2		# $s0 = $a2

	add $a1, $zero, $s1		# $a1 = $s1

	addi $s1, $s1, -1
	sll $t0, $t0, $s1		

	jal toBinary

	add $a3, $zero, 23
	sub $a1, $a3, $a1
	add $a0, $zero, $zero

	jal REP

	jal reRun
.end main


.globl zeroException
.ent zeroException
zeroException:
	bne $s0, $zero, zeroExceptionOut
	add $a0, $zero, $zero

	li $v0, 4
	la $a0, msg3
	syscall

	li $v0, 10
	syscall

zeroExceptionOut:	
	jr $ra

.end zeroException


.globl signDecider
.ent signDecider
signDecider:	
	slt $t0, $s0, $zero		# checks if the input is less than zero
	bne $t0, $zero, removeNegative 	
							# jumps to removeNegative if $t0 != 0 as input < 0 
	add $a0, $zero, $zero	# saves $a0 = 0

	jr $ra

removeNegative:	
	addi $t0, $zero, 2		# since $t0 = 1, hence $t0 = 3
	mult $s0, $t0			# multiplies input with 3
	mflo $t0				# saves product in $t0
	sub $s0, $s0, $t0		# this essentially makes a -ve into +ve

	addi $a0, $zero, 1		# saves $a0 = 1

	jr $ra
.end signDecider


.globl lengthCalculator
.ent lengthCalculator
lengthCalculator:	
	add $s1, $zero, $zero
	addi $t0, $zero, 2

lengthCalculatorLoop:	
	div $s0, $t0
	mflo $s0				# calculates length of the binary representation
	beq $s0, $zero, lengthCalculatorOut	
	addi $s1, $s1, 1		# of decimal input by dividing by 2 in a loop
	j lengthCalculatorLoop

lengthCalculatorOut:	
	jr $ra
.end lengthCalculator


.globl toBinary
.ent toBinary
toBinary:	
	and $s3, $t0, $s0		
	srl $s3, $s3, $s1
	add $a0, $s3, $zero	
	syscall			
	addi $s1, $s1, -1
	srl $t0, $t0, 1		
	beq $t0, $zero, toBinaryOut
	j toBinary

toBinaryOut:	
	jr $ra
.end toBinary


.globl REP
.ent REP
REP:	
	syscall
	addi $a1, $a1, -1
	beq $a1, $zero, REPL
	j REP

REPL:	
	jr $ra
.end REP

.globl reRun
.ent reRun
reRun:
	li $v0, 4
	la $a0, msg4
	syscall

	li $v0, 12
	syscall
	move $s0, $v0

	beq $s0, 121, main
	beq $s0, 089, main

	li $v0, 4
	la $a0, msg5
	syscall

	li $v0, 10
	syscall