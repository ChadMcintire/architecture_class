#####################################################################
# Program #2: Assignment2.asm     Programmer: Chad McIntire
# Due Date: 02/05/2020    Course: CS2810
# Date Last Modified: 02/01/2020
#####################################################################
# Functional Description:
# We prompt a user for a string and save the string, 
# we then we parse that string to 
# see how many printable characters there are
# and print that number and the original string
#####################################################################
# t1 = 0, s0=33,
#
#load characters
# v0 = 8, a1 = 64
# a0 = address(userString), t0 = address(userString)
# 
# parse characters
# countChr:
# t2 = 0(t0)
# if (t0 < s0) 
#     jump to remove
# else 
#     print (Byte byte# is byte)
#     t0 += 1
#     t1 += 1
#     jump countChr
#
# remove:
# sub $0, 0(t0)
#
# print The string: string contains #chars characters
# print exit message
# exit the program 
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $t0: Used to store user string
# $t1: Loop counter
# $t2: Stores the current byte value of t0 as we loop
# $a0: Used to pass addresses and values to syscalls
# $a1: Sets number of characters read
# $s0: Is 33 and is the upper limit of the printable characters
######################################################################

.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
name:			.asciiz "Name: Chad McIntire"
title:			.asciiz "\nTitle: CS 2810 - Loops in MIPS Assembly"
description: 		.ascii  "\n\nDescription: The program will prompt you for an input string\n" 
           	        .ascii  "give the input string, the bytes will be parsed and return you\n"
           	        .ascii  "each byte value and its position, and finally the string and "
           	        .asciiz "the number of characters"
lbl:   			.asciiz "\n\nThe string: "
byteLoaderMessage: 	.asciiz "\nEach byte by index in array:\n"
userStringprompt: 	.asciiz "\n\nPlease enter the string of your choice: "
contains:               .asciiz " contains "
characters:             .asciiz " characters.\n"
byteName:               .asciiz  "\nByte "
is:                     .asciiz  " is: "
endThanks:              .asciiz   "\nThanks again for the string, that's all for now." 
userString: 		.space  64 

.text              # Executable code follows
main:

intro:
	li $v0, 4
	la $a0, name
	syscall
	
	li $v0, 4
	la $a0, title
	syscall

	li $v0, 4
	la $a0, description
	syscall

# initialize variables
# initialize t1 as a counter and s0 as the upper bound for non-printable characters
	li $t1, 0    # $t1 is the counter. set it to 0 
    	li $s0, 32   # $s3 is the upper bound

# print a string to prompt users for a value
	li $v0, 4
	la $a0, userStringprompt
	syscall

#read in a string from the user setting the read limit at 64 and storing the input at userStrings address
	li $v0, 8
	li $a1, 64
	la $a0, userString
	la $t0, userString
	syscall

#print a message about each byte being displayed and its number in the index
	li $v0, 4
	la $a0, byteLoaderMessage
	syscall

#print a message about each byte being displayed and its number in the index
countChr:  
# Load the first byte from address in $t0 
   
	lb $t2, 0($t0)  
# if this is a nonprintable character make it an endline instead of newline,
    	blt $t2, $s0, remove
    	
# else if the character is not print (Byte byte# is byte) 

    	li  $v0, 4
    	la  $a0, byteName
    	syscall
    	
    	move $a0, $t1
    	li $v0, 1
    	syscall
    	
    	li  $v0, 4
    	la  $a0, is
    	syscall
    	
    	move $a0, $t2
    	la $v0, 11
    	syscall

# also increment the t0 and t1 address by 1 and jump back to the top
    	    	
    	add $t0, $t0, 1   
    	add $t1, $t1, 1   
    	j countChr        

#replace any nonprintable with an endline    	
remove: 
	sb $0, 0($t0)

#print The string: string contains #chars characters
printFinal:	
	li $v0, 4
	la $a0, lbl
	syscall

	la $a0, userString
	syscall

	li $v0, 4
	la $a0, contains
	syscall
    	
    	move $a0, $t1
    	la $v0, 1
    	syscall

	li $v0, 4
	la $a0, characters
	syscall

#print end statement and exit safely
end:
	li $v0, 4
	la $a0, endThanks
	syscall
	
	li $v0, 10
	syscall
