#####################################################################
# Program #1: Assignment1.asm     Programmer: Chad McIntire
# Due Date: 01/22/2020    Course: CS2810
# Date Last Modified: 01/09/2020
#####################################################################
# Functional Description:
# The programs purpose is to get two inputs from a user,
# Then this input is used to calculate 
# 
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
name:		.asciiz "Name: Chad McIntire"
title:		.asciiz "\nTitle: CS 2810 - Assignement 1 (introduction)"
description: 	.asciiz "\nDescription: This program is intended to get 2 inputs from the user and use them to give a sum, difference, product, ..."
prompt1:  	.asciiz "\n\nPlease enter a value: "
prompt2:  	.asciiz "\nPlease enter a value 2: "
prompt3:  	.asciiz "\nThe values you selected are: "
addition:  	.asciiz "\nThe sum of the two numbers is: "
subtraction:  	.asciiz "\nThe difference of the two numbers is: "
multiplication: .asciiz "\nThe product of the two numbers is: "
division:  	.asciiz "\nThe quotient of the two numbers is: "
remainder: 	.asciiz "\nThe remainder of the two numbers is: "
bye:	        .asciiz "\n **** Thanks for playing, come again soon ****"

vSum:		.word    0
vDiff:		.word    0
vProd:		.word    0
vDiv:		.word    0
vRem: 		.word    0
	  	.globl main
	  	.text
	
main:

# Give an introduction
# Print Name
	li    $v0, 4          
	la    $a0, name	
	syscall     

# Print Title
	li    $v0, 4          
	la    $a0, title	
	syscall     

# Print description of assignment
	li    $v0, 4          
	la    $a0, description	
	syscall     

# ask for input by printing prompt1
	li    $v0, 4          
	la    $a0, prompt1	
	syscall               
	
# get first int from a user
	li    $v0,5 
	syscall

#store input from $v0 to $t0 for use in computation
	move  $t0, $v0
#store input from $v0 to $a0 for use in printing value
	move  $a0, $v0

# ask for input by printing prompt2
	li    $v0, 4          
	la    $a0, prompt2	
	syscall                
	
# get second int from a user
	li    $v0,5 
	syscall

#store input from $v0 to $t1 for use in computation
	move  $t1, $v0
	
#print int stored in $a0 and message explain what they are
#	li    $v0, 4        
#	la    $a0, prompt3	
#	syscall             
#store input from $v0 to $a0 for use in printing value	
#	move  $a0, $v0
#	li    $v0, 1
#	syscall
	
#	li    $v0, 4
#	la    $a0, 'and'

# add inputs together and store them in memory
	add	$a0, $t0, $t1	# add the first two numbers
	sw    	$a0, vSum
	#li    $v0, 1
	#syscall
	
# subtract inputs together and store them in memory
	sub	$a0, $t0, $t1	
	sw    	$a0, vDiff
	#syscall

# multiply inputs together and store them in memory
	mul   	$a0, $t0, $t1	
	sw    	$a0, vProd
	#syscall

# divide inputs together and store them in memory
	div   	$a0, $t0, $t1	
	sw    	$a0, vDiv
	#syscall
	

# divide inputs together and store them in memory
	rem   	$a0, $t0, $t1	
	sw    	$a0, vRem
	#syscall

#print message about summing the two inputs
	li    $v0, 4         
	la    $a0, addition	
	syscall                
	
	lw    $a0, vSum
	li    $v0, 1
	syscall
	
#print message about the difference the two inputs
	li    $v0, 4          
	la    $a0, subtraction	
	syscall                
	
	lw    $a0, vDiff
	li    $v0, 1
	syscall

#print message about the product the two inputs
	li    $v0, 4          
	la    $a0, multiplication	
	syscall                
	
	lw    $a0, vProd
	li    $v0, 1
	syscall
			
#print message about the quotient the two inputs
	li    $v0, 4          
	la    $a0, division	
	syscall                
	
	lw    $a0, vDiv
	li    $v0, 1
	syscall
	
#print message about the remainder after division of the two inputs
	li    $v0, 4          
	la    $a0, remainder	
	syscall                
	
	lw    $a0, vRem
	li    $v0, 1
	syscall
	
#give a parting message
	li    $v0, 4
	la    $a0, bye
	syscall

#end program
	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM
