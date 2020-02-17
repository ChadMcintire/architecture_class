#####################################################################
# Program #3: Assignment3.asm     Programmer: Chad Mcintire
# Due Date: 02/19/2020    Course: CS2810
# Date Last Modified: 02/16/2020
#####################################################################
# Functional Description:
# The program gets a user to enter a hex string of a FAT-16 directory
# , the program then returns the big endian version as hex. Then
# the program returns the date contained in the converted value. 
#####################################################################
# Pseudocode:
# cout << "Chad Mcintire, Implementing Bitmasks - Decoding FAT"
# cout << "Welcome, you will be asked for a FAT-16 directory value," 
#         "this will be converted to big endian." 
# cout << "You will then be given the date of that converted value."
# cout << "Please enter the data field from the FAT-16 directory entry:"
#
# #since I didn't make readhex I'm not going to do the pseudocode for it
# #get original hex value read in
# $s0 = 255
#
# #READ AND SAVE HEX
# $s1 = readhex
#
# #CONVERT TO BIG ENDIAN
#
# # and with FF with the right most digits and shift 8 left
# $t1 = $s1 && $s0
# $t1=  sll($t1, 8)
#        
# # shift left 8 on FF ($s0) to get FF00, bitwise and with
# # the original entered value and you git the first 8 bits
# # then you move it right 8 bits
# $t2 = sll($s0, 8)
# $t2 = $s1 && $t2
# $t2 = srl($t2, 8)
#        
# # add the two values together swaps the digits and it is 
# # stored in $v0
#  $v0 = $t2 + $t1
#  $s1 = $v0
#
# #GET MONTH
#
#  # The bitmask 111100000 correlates to where the month is  
#  # stored, which is 480 decimal, so bitwise and gets the 
#  # month, I shift left 5 to save the actual month value,          
#  $t0 = $s1 && 480     
#  $v0 = srl($t0, 5)
#  $s2 = $v0
#
# #GET DAY
# # Since 31 corresponds to 11111, we use this bitmask to get the   
# # day, since it is the last 5 values, I didn't shift because      
# # we already are at the last 5 bites.                            
# $v0 = $s1 && 31
# $s3 = $v0
#
# #GET YEAR
#
# #Shift to remove the last 9 bits then add 1980 to get the year  
# $t0 = srl($s1, 9)
# $v0 = $t0 && 1980
# $s4 = $v0
#
# #PRINT BIG ENDIAN HEX
#
# cout << "The entered value converted to big-endian is: "
# $v0 = 34, $a0 = $s1 
#
# #PRINT DATE
#
# cout << "The date of the entered value is: 
# 
# #PRINT MONTH
#
# # subtract 1 from the month total so that we can
# # display the correct value from our month arrau
# # and store the value in t0
# $t0 = $s2 + -1
# # we multiply the new month value by 11 because each
# # month in the array is 11 bits apart then store that value
# # in $t0 using mflo to get the low 32 bits
# $t0 = $t0 * 11
# $t0 = mflo
# # load the months into register $a0 and add the months array
# # to the $t0 to get the month we want at the correct offset
# # then print the ascii value
# $a0 = months
# $a0 = $a0 + $t0     
#
# #PRINT DAY
# $a0 = $s3
#
# #PRINT COMMA
#
# $v0 = 11, $a0 = 44
#
# #PRINT YEAR
# $v0 = 1, $a0 = $s4
#
# cout << "Thanks again, hope to get a second date soon."
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: stores the value 255, this is used for swapping little endian
# to big endian
# $s1  originally was used to store hex as little endian,
#	then immediately used to store the value of the hexdigits 
#       as big endian      
# $s2  store the month value
# $s3  store the day value
# $s4  store the year value
# $t0: only used for place holding values
# $t1: temporary value to store the first half of the little 
#      endian value before converting to big endian
# $t2: temporary value to store the second half of the little 
#      endian value before converting to big endian
# $a0: Used to pass addresses and values to syscalls
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
mesg1:	           .asciiz "\nThe entered value in decimal is: "
mesg2:             .asciiz "\n\n"
months:            .ascii  "January \0  February \0 March \0    April \0    "
                   .ascii  "May \0      June \0     July \0     August \0   "
                   .asciiz "September \0October \0  November \0 December \0 "
conversionmessage: .asciiz  "        The entered value converted to big-endian is: "
datemessage:       .asciiz  "        The date of the entered value is: "
beginngmessage:    .ascii   "\nChad Mcintire, Implementing Bitmasks - Decoding FAT"
		   .ascii   "\nWelcome, you will be asked for a FAT-16 directory "
		   .ascii   "value, this will be converted to big endian. \n"
		   .asciiz  "You will then be given the date of that converted value."
returnmesage1:     .ascii   "\n\nPlease enter the data field from the FAT-16 "
                   .asciiz  "directory entry:"
endingmessage:     .asciiz  "\n\nThanks again, hope to get a second date soon."

	.text              # Executable code follows

main:
# Include your code here
	
	# initalize our hex FF register
	li $s0, 255
	
	li $v0, 4          
	la $a0, beginngmessage     
	syscall
	
	# ask for a FAT-16 entry
	li $v0, 4          
	la $a0, returnmesage1     
	syscall
	
	# return hex number in little endian format and store it in $s1
	jal readhex        
	move $s1, $v0      
	
	# convert to big endian and save new value as $s1
	jal convtobigi
	move $s1, $v0
        
        # get the month and store as $s2
        jal getmonth
        move $s2, $v0
        
        # get the day and store it as $s3
        jal getday
        move $s3, $v0
        
        # get the year and store it as $s4
        jal getyear
        move $s4, $v0

	# print out the hex value and the date that
	# was found using the big endian result 
	jal printstatement
	
	#print an exiting message
	li $v0, 4          
	la $a0, endingmessage     
	syscall
	
	#exit program
	li    $v0, 10         
	syscall                


# END OF MAIN PROGRAM # Subroutines are below #######################

#####################################################################
## Subroutine to convert little endian to big endian, the details  ##
## are more easily explained int he code so that is where they     ##
## are commented.                                                  ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
convtobigi:
	addi $sp, $sp, -8   # make room for 2 registers on the stack
	# save $t1 and #t2 on the stack
	sw   $t1, 4($sp)     
	sw   $t2, 0($sp)     
        
        # and with FF with the right most digits and shift 8 left
        and $t1, $s1, $s0
        sll $t1, $t1, 8
        
        # shift left 8 on FF ($s0) to get FF00, bitwise and with
        # the original entered value and you git the first 8 bits
        # then you move it right 8 bits
        sll $t2, $s0, 8
        and $t2, $s1, $t2
        srl $t2, $t2, 8
        
        # add the two values together swaps the digits and it is 
        # stored in $v0
        add $v0, $t2, $t1
        
        #pop $t1 and $t2 from the stack
        lw   $t2, 0($sp)     
	lw   $t1, 4($sp)     
	addi $sp, $sp, 8     # free the stack by changing the stack pointer
	
	jr   $ra             # Return to where called
	
#####################################################################
## Shift to remove the last 9 bits then add 1980 to get the year   ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
getyear:
        addi $sp, $sp, -4   # make room for 1 registers on the stack
	sw   $t0, 0($sp)    # save $t0 onto the stack

	srl $t0, $s1, 9
	addi $v0, $t0, 1980
	
	lw   $t0, 0($sp)     # pop $t0 from the stack
	addi $sp, $sp, 4     # free the stack by changing the stack pointer
	
	jr   $ra             # Return to where called


#####################################################################
## The bitmask 111100000 correlates to where the month is          ##
## stored, which is 480 decimal, so bitwise and gets the           ##
## month, I shift left 5 to save the actual month value,           ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
getmonth: 
        addi $sp, $sp, -4   # make room for 1 registers on the stack
	sw   $t0, 0($sp)    # save $t0 onto the stack

	andi $t0, $s1, 480     
       	srl  $v0, $t0, 5
       	
       	lw   $t0, 0($sp)     # pop $t0 from the stack
	addi $sp, $sp, 4     # free the stack by changing the stack pointer
       	
	jr   $ra             # Return to where called
	

#####################################################################
## Since 31 corresponds to 11111, we use this bitmask to get the   ##
## day, since it is the last 5 values, I didn't shift because      ##
## we already are at the last 5 bites.                             ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
getday: 
	andi $v0, $s1, 31
	jr   $ra             # Return to where called
	

#####################################################################
## The subroutine printstatement prints a message about the number ##
## converted to big endian, and displays that number as a hex      ##
## We then display a message about the date and display the date   ##
#+-----------------------------------------------------------------+#
## This subroutine changes no values                               ##
#####################################################################
printstatement: 
        addi $sp, $sp, -4   # make room for 1 registers on the stack
	sw   $t0, 0($sp)    # save $t0 onto the stack
        
        #print message about showing the converted
        #big endian hex
	li $v0, 4          
	la $a0, conversionmessage
        syscall
        
        #print the hex number after big endian conversion
        li $v0, 34          
	la $a0, ($s1)
        syscall
        
        
        # add two lines of space between the hex and date
        li $v0, 4     
	la $a0, mesg2
        syscall
        
        
        li $v0, 4          
	la $a0, datemessage
        syscall
        
        # subtract 1 from the month total so that we can
        # display the correct value from our month arrau
        # and store the value in t0
        addi $t0, $s2, -1
        # we multiply the new month value by 11 because each
        # month in the array is 11 bits apart then store that value
        # in $t0 using mflo to get the low 32 bits
        mul $t0, $t0, 11
	mflo $t0
	
	# load the months into register $a0 and add the months array
	# to the $t0 to get the month we want at the correct offset
	# then print the ascii value
	la $a0, months
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
	
	# print the day
	li $v0, 1
	la $a0, ($s3)
	syscall
	
	#insert a comma
	li $v0, 11
	li $a0, 44
	syscall
	
	#print the year
	li $v0, 1
	la $a0, ($s4)
	syscall
	
	lw   $t0, 0($sp)     # pop $t0 from the stack
	addi $sp, $sp, 4     # free the stack by changing the stack pointer
	
	jr   $ra             # Return to where called
	


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
	addi $sp, $sp, 8     # free the stack by changing the stack pointer
	jr   $ra             # Return to where called
