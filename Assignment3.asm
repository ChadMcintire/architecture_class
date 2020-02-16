#####################################################################
# Program #3: <File Name>     Programmer: <YOUR NAME>
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
# $s0: stores the value 255, this is used for swapping little endian
# to big endian
# $t0: only used for place holding values
# $t1: Loop counter
# $t2: Fibonacci(N-2)
# $t3: Used to temporarily store Fibonacci(N-1)
# $a0: Used to pass addresses and values to syscalls
#     <HERE YOU DECLARE ANY ADDITIONAL REGISTERS USED>
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
mesg1:	           .asciiz "\nThe entered value in decimal is: "
mesg2:             .asciiz "\n\n"
mesg3:             .asciiz " and val"
months:            .ascii  "January \0  February \0 March \0    April \0    "
                   .ascii  "May \0      June \0     July \0     August \0   "
                   .asciiz "September \0October \0  November \0 December \0 "
returnmesage1:     .ascii  "Please enter the data field from the FAT-16 "
                   .asciiz "directory entry:"
conversionmessage: .asciiz  "        The entered value converted to big-endian is: "
datemessage:       .asciiz  "        The date of the entered value is: "
	.text              # Executable code follows

main:
# Include your code here
	li $s0, 255
	li $v0, 4          # Syscall to print a string
	la $a0, returnmesage1     # We will display the prompt
	syscall
	
	jal readhex        # call the subroutine to read a hex integer
	
	move $s1, $v0      # Save the result of reading a hex
	
	jal convtobigi
	move $s1, $v0
        
        jal getmonth
        move $s2, $v0
        
        jal getday
        move $s3, $v0
                          
        jal getyear
        move $s4, $v0

	jal printstatement
	
	li    $v0, 10          # terminate program run and
	syscall                # return control to system


convtobigi:
        and $t1, $s1, $s0
        sll $t1, $t1, 8
        
        sll $t2, $s0, 8
        and $t3, $s1, $t2
        srl $t3, $t3, 8
        
        add $v0, $t3, $t1
	jr   $ra             # Return to where called
	
#shift to remove the last 9 bits then add 1980 to get the year
getyear:
	srl $t0, $s1, 9
	addi $v0, $t0, 1980
	jr   $ra             # Return to where called

# the bitmask 111100000 correlates to where the month is
# stored, which is 480 decimal, so bitwise and gets the 
# month, I shift left 5 to save the actual month value,
getmonth: 
	andi $t0, $s1, 480     
       	srl  $v0, $t0, 5
	jr   $ra             # Return to where called
	
# since 31 corresponds to 11111, we use this bitmask to 
# get the day, since it is the last 5 values, I didn't 
# shift
getday: 
	andi $v0, $s1, 31
	jr   $ra             # Return to where called
	
	
printstatement: 

        
	li $v0, 4          # Get ready to label result
	la $a0, conversionmessage
        syscall
        
        li $v0, 34          # Get ready to label result
	la $a0, ($s1)
        syscall
        
        li $v0, 4     
	la $a0, mesg2
        syscall
        
        li $v0, 4          # Get ready to label result
	la $a0, datemessage
        syscall
        
        
        addi $t0, $s2, -1
        mul $t0, $t0, 11
	mflo $t0
	la $a0, months
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
	
	#insert a space
#	li $v0, 11
#	li $a0, 32
#	syscall
	
	li $v0, 1
	la $a0, ($s3)
	syscall
	
	#insert a comma
	li $v0, 11
	li $a0, 44
	syscall
	
	li $v0, 1
	la $a0, ($s4)
	syscall
	
	
        
	jr   $ra             # Return to where called
	
# END OF MAIN PROGRAM # Subroutines are below #######################

#####################################################################
## The subroutine readhex is provided to read in a Hex number up   ##
## to 8 digits long, producing 32-bit integer result, returned in  ##
## register $v0. Non-hex values terminate the subroutine           ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
readhex:   # Read a Hex value
	addi $sp, $sp, -8   # make room for 2 registers on the stack
	sw   $t0, 4($sp)     # save $t0 on stack, used to accum6ulate
	sw   $t1, 0($sp)     # save $t1 on stack, used to count
	li   $t1, 8          # We will read up to 8 characters
	move $t0, $zero      # initialize hex value to zero
rdachr: li   $v0, 12         # Beginning of loop to read a character
	syscall              # syscall 12 reads a character into $v0
	blt  $v0, 32, hexend # Read a non-printable character so done
	blt  $v0, 48, hexend # Non-hex value entered (special char)
	blt  $v0, 58, ddigit # A digit 0-9 was entered
	blt  $v0, 65, hexend # A special character was entered so done
	blt  $v0, 71, uphex  # A hex A-F was entered so handle that
	blt  $v0, 97, hexend # A non-hex letter or special, so done
	blt  $v0, 103, lhex  # A hex a-f was entered so handle that
	j    hexend          # Not a hex so finish up
ddigit:	addi $v0, $v0, -48   # Subtract the ASCII value of 0 to get num
        j    digitdone       # value to OR is now in $v0 so OR
uphex:	addi $v0, $v0, -55   # Subtract 65 and add 10 so A==10
	j    digitdone       # hex value determined, so put in 
lhex:	addi $v0, $v0, -87   # Subtract 97 and add 10 so a==10
digitdone:
	sll  $t0, $t0, 4     # New value will fill the 4 low order bits
        or   $t0, $t0, $v0   # Bitwise OR $t0 and $v0 to enter hex digit
        addi $t1, $t1, -1    # Count down for digits read at zero, done
        beqz $t1, hexend     # If $t0 is zero, we've read 8 hex digits
        j    rdachr          # Loop back to read the next character
hexend:	move $v0, $t0        # Set $v0 to the return value
	lw   $t1, 0($sp)     # pop $t1 from the stack
	lw   $t0, 4($sp)     # pop $t0 from the stack
	addi $sp, $sp, 12     # free the stack by changing the stack pointer
	jr   $ra             # Return to where called
