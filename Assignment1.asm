#####################################################################
# Program #1: Assignment1.asm     Programmer: Chad McIntire
# Due Date: 01/22/2020    Course: CS2810
# Date Last Modified: 01/20/2020
#####################################################################
# Functional Description:
# The programs purpose is to get two inputs from a user,
# Then these inputw are used to calculate the sum, product, difference,
# and quotient.
# Finally the information is printed to the screen
#####################################################################
# Pseudocode:
####################################################################
#  #print an introdcution
#  cout <<  "Name: Chad McIntire"
#       <<  "Title: CS 2810 - Assignement 1 (Introduction)"
#       <<  "Description: This program is intended to get 2 inputs" 
#       <<  "from the user and use them to give a sum, difference, product, ..."
#
#  #get the first value value from the user
#  cout <<  "Please enter a value: "
#  cin >> v0
#  s0=v0
#  
#  #get the second value value from the user
#  cout <<  "Please enter a value 2: "
#  cin >> v0
#  s1=v0
#
#  #compute the sum and save it
#  a0 = s0 + s1
#  vSum = a0
#
#  #compute the minus and save it
#  a0 = s0 - s1
#  vDiff = a0
#
#  #compute the product and save it
#  a0 = s0 * s1
#  vProd = a0
#
#  #compute the quotient and save it
#  a0 = s0 / s1
#  vDiv = a0
#
#  #compute the remainder and save it
#  a0 = remainder of s0 and s1
#  vRem = a0
#
#  #print the values of the sum, diff, product, quotient, and remainder
#  cout << "\nThe sum of the two numbers is: " << vSum
#  cout << "\nThe difference of the two numbers is: " << vDiff
#  cout << "\nThe product of the two numbers is: " << vProd
#  cout << "\nThe quotient of the two numbers is: " << vDiv
#  cout << "\nThe remainder of the two numbers is: " << vRem 
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: This is where the first input from the user is stored
# $t0: This is where the first input from the user is stored
# $a0: Used to pass addresses and values to syscalls
######################################################################
	.data              # Data declaration section

# Entries here are <label>:  <type>   <value>
#Output to user section
name:		.asciiz "Name: Chad McIntire"
title:		.asciiz "\nTitle: CS 2810 - Assignement 1 (Introduction)"
description: 	.ascii  "\nDescription: This program is intended to get 2 inputs" 
                .asciiz " from the user and use them to give a sum, difference, product, ..."
prompt1:  	.asciiz "\n\nPlease enter a value: "
prompt2:  	.asciiz "\nPlease enter a value 2: "
addition:  	.asciiz "\nThe sum of the two numbers is: "
subtraction:  	.asciiz "\nThe difference of the two numbers is: "
multiplication: .asciiz "\nThe product of the two numbers is: "
division:  	.asciiz "\nThe quotient of the two numbers is: "
remainder: 	.asciiz "\nThe remainder of the two numbers is: "
bye:	        .asciiz "\n\n **** Thanks for playing, come again soon ****"

#stored variables section
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

#store input from $v0 to $s0 for use in computation
	move  $s0, $v0

# ask for input by printing prompt2
	li    $v0, 4          
	la    $a0, prompt2	
	syscall                
	
# get second int from a user
	li    $v0,5 
	syscall

#store input from $v0 to $s1 for use in computation
	move  $s1, $v0
	
# add inputs together and store them in memory
	add   $a0, $s0, $s1	# add the first two numbers
	sw    $a0, vSum
	
# subtract inputs together and store them in memory
	sub   $a0, $s0, $s1	
	sw    $a0, vDiff

# multiply inputs together and store them in memory
	mul   $a0, $s0, $s1	
	sw    $a0, vProd

# divide inputs together and store them in memory
	div   $a0, $s0, $s1	
	sw    $a0, vDiv

# divide inputs together and store them in memory
	rem   $a0, $s0, $s1	
	sw    $a0, vRem

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
