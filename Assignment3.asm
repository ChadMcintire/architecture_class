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
name:			.asciiz "Name: Chad McIntire"
title:			.asciiz "\nTitle: CS 2810 - Loops in MIPS Assembly"
description: 		.ascii  "\nDescription: This program is intended to get 2 inputs" 
           	        .asciiz " from the user and use them to give a sum, difference, product, ..."
lbl:   			.asciiz "\nThe string entered is: ->"
byteLoaderMessage: 	.asciiz "\nByte 1 is: "
userStringprompt: 	.asciiz "\nKindly enter a string: "

userString: 		.space  64 

.text              # Executable code follows
main:
# Include your code here

	li $v0, 4
	la $a0, userStringprompt
	syscall

#li $s1,0 #counter is 0
	li $v0, 8
	li $a1, 64
	la $a0, userString
	la $t0, userString
	syscall


	li $v0, 4
	la $a0, lbl
	syscall

	la $a0, userString
	syscall

	li $v0, 4
	la $a0, byteLoaderMessage
	syscall

	li $t1, 0    # $t1 is the counter. set it to 0 
    
    	li $s0, 33
countChr:  
    	lb $t2, 0($t0)  # Load the first byte from address in $t0  
#    	la $t3, ($t2)
    
    	move $a0, $t2
    	la $v0, 11
    	syscall
    
    	blt $t2, $s0, end
    	#beqz $t2, end   # if $t2 == 0 then go to label end  
    	#li	$t9,	'\n'		# or if p* is '\n' char at end of string
    	#beq	$t2, $t9, end
    	
    	add $t0, $t0, 1      # else increment the address  
    	add $t1, $t1, 1 # and increment the counter of course  
    	
    	j countChr      # finally loop  
   


end:

	li $v0, 4
	la $a0, userStringprompt
	syscall
    	
    	move $a0, $t1
    	la $v0, 1
    	syscall

	li $v0, 10
	syscall