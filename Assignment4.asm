#####################################################################
# Program #1: <File Name>     Programmer: <YOUR NAME>
# Due Date: <Due Date>    Course: CS2810
# Date Last Modified: <Date of Last Modification>
#####################################################################
# Functional Description:
# <Give a short English description of your program.  For example:
#  This program accepts an integer value and computes and displays
#  the Fibonacci number for that integer value. >
#####################################################################
# Pseudocode:
#  <Insert an algorithmic description of your program using 
#   pseudocode.  Your pseudocod should use register names as 
#   variables and should resemble a higher level language or a
#   sequence of English statements describing the computations >
# ****Here is an example that you should delete from your file****
#     cout << "Please enter N to compute Fibonacci(N): " 
#     cin >> v0
#     if v0 < 0 stop
#     s0 = v0
#     let t0 = 0
#     let t2 = 1
#     for (t1 = 1; t1 <= s0; t1++) {
#         t3 = t0;
#         t0 = t0 + t2
#         t2 = t3;
#     }
#     cout << "Fibonnacci number " << s0 << " is " << t0
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: The value N for Fibonacci(N)
# $t0: Contains Fibonacci(N) at each loop iteration
# $t1: Loop counter
# $t2: Fibonacci(N-2)
# $t3: Used to temporarily store Fibonacci(N-1)
# $a0: Used to pass addresses and values to syscalls
#     <HERE YOU DECLARE ANY ADDITIONAL REGISTERS USED>
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
promptfloat:  .asciiz "\nPlease enter a float value: "
promptint:    .asciiz "\nPlease enter an integer value: "
raised:       .asciiz " raised to "
oneval:       .asciiz " 1 "
intzero:      .asciiz "Anything times 0 is 0"
continue1:    .asciiz "Continue and enter other values? (y or Y for yes): "
	.text              # Executable code follows
main:
# Include your code here
	li $v0, 4
	la $a0, promptfloat
	syscall	

	li $v0, 6
	syscall
	
	li $v0, 2
	mov.s $f12, $f0
	mov.s $f1, $f0
	syscall
	
	li $v0, 4
	la $a0, promptint
	syscall	
	
	li $v0, 5
	syscall
	move $a0, $v0
	move $t1, $v0
#	li $v0, 1
#	syscall
	
	li $t0, 0
	mov.s $f2, $f1
	abs $t2, $t1
	
	beqz $t2, ifexpzero
		
	jal exp
	
	j continue
	 
	
ifexpzero: li $v0, 2
	mov.s $f12, $f1
	syscall
	
	li $v0, 4
	la $a0, raised
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	addi $a0, $zero, 32
	li $v0, 11
	syscall
	
	addi $a0, $zero, 61
	li $v0, 11
	syscall
	
	li $v0, 4
	la $a0, oneval
	syscall
	
	j continue
	
ifintzero:
	li $v0, 4
	la $a0, intzero
	syscall
	
exp:  
        mul.s $f0, $f1, $f1
        addi $t0, $t0, 1
        seq $t4, $t0, $t2
        beqz $t4, exp
	jr $ra
        
        

negative:

continue: li $v0, 4
	  la $a0, continue1
	  syscall
    
end:	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM
