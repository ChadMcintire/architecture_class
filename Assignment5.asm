#####################################################################
# Program #3: Assignment4.asm     Programmer: Chad McIntire
# Due Date: 03/25/2020    Course: CS2810
# Date Last Modified: 03/22/2020
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
welcome: .ascii "Welcome, My name is Chad McIntire.\nProgram: MIPS 2-D arrays"
         .ascii "\n\nIn this program you will be asked for a MP3 Header."
         .asciiz "\n    From this you will be given the Version, Layer, and Bit Rate." 
prompt:  .asciiz "\n\nPlease enter the MP3 header: "
mesg1:	.asciiz "\nThe entered value in decimal is: "
mpegres: .asciiz "\n    The version is reserved, and thus has no bit rate."
layres:  .asciiz "\n    The layer is reserved, and thus has no bit rate."
mpegv:  .asciiz "\n    MPEG Version "
layernum: .asciiz "\n    Layer "
bitratenum:  .asciiz "\n    Bit rate: "
mpegarr:  .ascii   "\n    MPEG Version 1.0 \0"
          .ascii   "\n    MPEG Version 2.0 \0"
          .ascii   "\n    Reserved \0        "
          .asciiz  "\n    MPEG Version 2.5 \0"
layerarr: .ascii   "\n    Layer I\0  "
          .ascii   "\n    Layer II\0 "
          .ascii   "\n    Layer III\0"
          .asciiz  "\n    Reserved \0"

kbps:     .asciiz  " kbps"
mesg2:  .asciiz "\n\n"
badandexit: .asciiz "\n    This is a bad bit rate, program will now close."
exitmessage:   .asciiz "\n\nProgram complete, bye now."
bytebits:    .byte	0, 0, 0, 0, 0, 0,
	4, 4, 4, 4, 1, 1,
        8, 6, 5, 6, 2, 2,
        12, 7, 6, 7, 3, 3,
        16, 8, 7, 8, 4, 4,
        20, 10, 8, 10, 5, 5,
        24, 12, 10, 12, 6, 6,
        28, 14, 12, 14, 7, 7, 
        32, 16, 14, 16, 8, 8,
        36, 20, 16, 18, 10, 10,
        40, 24, 20, 20, 12, 12,
        44, 28, 24, 22, 14, 14,
        48, 32, 28, 24, 16, 16,
        52, 40, 32, 28, 18, 18,
        56, 48, 40, 32, 20, 20 

	.text              # Executable code follows
main:
# Include your code here
	li $v0, 4          # Syscall to print a string
	la $a0, welcome     # We will display the prompt
	syscall

	li $v0, 4          # Syscall to print a string
	la $a0, prompt     # We will display the prompt
	syscall
	
	jal readhex        # call the subroutine to read a hex integer
	
	move $s0, $v0      # Save the result of reading a hex

	# get the version, layer, row,and the bit rate then print them
        jal getversion
        jal getlayer
        jal getrow
        jal getbitrateindex
        jal print
end:
        li $v0, 4          # Syscall to print a string
	la $a0, exitmessage     # We will display the prompt
	syscall
        
	li    $v0, 10          # terminate program run and
	syscall                # return control to system


# END OF MAIN PROGRAM # Subroutines are below #######################


getversion: 
        # shift to the where the version is stored, use a not to flip
        # the order of the binary so it matches my array, use
        # and to have a bitmask that gets the first 2 bits that 
        srl $t0, $s0, 19
        not $t0, $t0
        andi $t0, 3
        move $s1, $t0
        
        #branch if there is no version
        beq $s1, 2, noversion
  
        jr $ra
        
getlayer:
        # shift to the where the version is stored, use a not to flip
        # the order of the binary so it matches my array, use
        # and to have a bitmask that gets the first 2 bits that  
	srl $t0, $s0, 17
	not $t0, $t0
        andi $t0, 3
        move $s2, $t0
        
        #branch if there is no layer
        beq $s2, 3, reslayer
        
        jr $ra


getrow:          
        # shift left to eliminate extra bits
	srl $t0, $s0, 12
	# 15 is the bitmask 1111 doing an and return the first 4 digits
        andi $t0, 15

        # if the row value is 1111, then the value is bad, so brach
        # give current layer and version, and exit
        beq $t0, 15, badvalue 
        
        # mulitply by 6 to get the memory offset for the row
        add $t1, $t1, 6
        mult $t1, $t0
        mflo $t0
        #save the row value to $s3
        move $s3, $t0
          
        jr $ra

getbitrateindex: 
        addi $sp, $sp, -4   # make room for 1 registers on the stack
	sw   $ra, 0($sp)    # save $ra onto the stack
	
	#get the column #
	jal calcolumn
	
	#use $s4 and $s3 to get the memory offset of the column + row * 4
	add $t0, $s4, $s3
	
	#load the array address into a register	
        la $t1, bytebits
	#lb $a0, 75($a0)
	#shift to where the memory offset would be for the row and column
	add $t1, $t1, $t0
	
	#load the byte at that offset
	lb $t1, ($t1)
	
	#multiply by 8 to get the actual bit rate
	sll $t1, $t1, 3
	
	#save the bitrate
	move $s5, $t1
	
	#load in the address we saved
	lw   $ra, 0($sp)     # pop $ra from the stack
	addi $sp, $sp, 4     # free the stack by changing the stack pointer
	
	jr $ra

calcolumn: 
        
        move $t0, $s1
        #check if the version val is not 3, if it is change it to 1,
        #because the values for v1 = 0, and v2 = 1
        bne $t0, 3, notthree
        addi $t0, $t0, -2
        
notthree:
        #this happens either way, but the formula for calculating column
        #is v# * 3 + layer#, so only 6 options 0 and 1 for version,
        #and 0,1,2 for Layer
        addi $t1, $zero, 3 
	mult $t0, $t1
	mflo $t1
	add $s4, $t1, $s2
	
        jr $ra
	
print: 
	#the array size is 23 so the offset is 23 * current value of mpeg 
	mul $t0, $s1, 23
	mflo $t0
	
	#display the MPEG version by adding the offset to the current position of $a0
	la $a0, mpegarr
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
		
	#the array size is 15 so the offset is 15 * current value of Layer 
	mul $t0, $s2, 15
	mflo $t0
	
	#display the Layer version by adding the offset to the current position of $a0
	la $a0, layerarr
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
        
        #display the bit rate
        li $v0, 4
	la $a0, bitratenum
        syscall
        
        li $v0, 1
        move $a0, $s5
        syscall
        
        li $v0, 4          # Syscall to print a string
	la $a0, kbps     # We will display the prompt
	syscall
	
	jr $ra

noversion: 
        #display the result if the version # is reserved
	li $v0, 4          # Syscall to print a string
	la $a0, mpegres     # We will display the prompt
	syscall
	
	j end

reslayer: 
	#display the Version, and give a message that the layer is reserved
	#the array size is 23 so the offset is 23 * current value of mpeg 
	mul $t0, $s1, 23
	mflo $t0
	
	#display the MPEG version by adding the offset to the current position of $a0
	la $a0, mpegarr
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
        
	li $v0, 4          # Syscall to print a string
	la $a0, layres     # We will display the prompt
	syscall
	
	j end


badvalue:  
        #display the version, layer, and let the user know the bitrate is bad
	#the array size is 23 so the offset is 23 * current value of mpeg 
	mul $t0, $s1, 23
	mflo $t0
	
	#display the MPEG version by adding the offset to the current position of $a0
	la $a0, mpegarr
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
		
	#the array size is 15 so the offset is 15 * current value of Layer 
	mul $t0, $s2, 15
	mflo $t0
	
	#display the Layer version by adding the offset to the current position of $a0
	la $a0, layerarr
	add $a0, $a0, $t0
	li $v0, 4     
        syscall
        
        #display that the bitrate is bad
        li $v0, 4
        la $a0, badandexit
        syscall

        j end

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
