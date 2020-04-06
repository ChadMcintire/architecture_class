#####################################################################
# Program #6: Memory Management Programmer: Chad McIntire
# Due Date: 04/15/2020    Course: CS2810
# Date Last Modified: 04/09/2020
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
prompt:  .asciiz "\nPlease enter N to compute Fibonacci(N): "
welcome: .ascii "Welcome, My name is Chad McIntire."
         .ascii "\nProgram: Memory Management, Linked List"
         .ascii "\nClass: 2810"
         .ascii "\n\nIn this program names and ages of people will be added to a"
         .ascii "\nlinked list, and can be printed. Once the user presses the "
         .ascii "\nthe user will no longer be able to enter new info and the "
         .ascii "\nprogram will exit." 
         .asciiz "\n\nAdd a person, print the linked list or exit"

menu:    .ascii "\n\nPlease select one of the following"
	 .ascii	"\n\t1} Print list"
	 .ascii	"\n\t2} Add person"
	 .asciiz "\n\t3} Exit"
	 
empty:    .asciiz "list is empty"

newline:  .asciiz "\n\n"

listheader: .asciiz "\n-------- List Contents ----------"
	 
endMessage: .asciiz "\nThanks for the info, have a good day!"
choice:  .asciiz "\n\n\tWhich option between 1 and 3 do you choose? "

name:    .asciiz "\n\nPlease enter a name (up to 40 characters): "
age:     .asciiz "\nPlease enter the age for "
nonext:  .asciiz "\nno new next"

userString: 		.space  40


	.text              # Executable code follows
	
main:
# initialize t1 as a counter and s0 as the upper bound for non-printable characters

    	li $s0, 32   # $s3 is the upper bound
    	
	jal printWelcome
	j guideChoice
# Include your code here

end:
	li $v0, 4
	la $a0, endMessage
	syscall

	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM

######################################################################
# Prints a welcome message
######################################################################
# saves no registers
######################################################################
printWelcome:
	li $v0, 4
	la $a0, welcome
	syscall
	
	jr $ra 
	
######################################################################
# Prints the menu options
######################################################################
# No registers were saved
######################################################################
printMenu: 
	li $v0, 4
	la $a0, menu
	syscall

######################################################################
# Prints the menu options
######################################################################
# No registers were saved
######################################################################
readChoice:
	# Ask for a choice
	li $v0, 4
	la $a0, choice
	syscall
		
	# Get the integer for the choice
	li $v0, 5
	syscall
	
	# move it to $t0
	move $t0, $v0
	
	# check if the number is in the 1 to 3 range if not ask for another
	# choice
	ble $t0, 0, readChoice
	bge $t0, 4, readChoice
	
	jr $ra

guideChoice:
	jal printMenu
	j executeChoice
	
executeChoice:
	beq $t0, 1, printList
        beq $t0, 2, addPerson
        beq $t0, 3, end
       
printList:
	li $v0, 4
	la $a0, listheader
	syscall

	beqz $a3, emptylist


	#beqz $t0, emptylist
looplist:

	li $v0, 4
	la $a0, newline
	syscall

	#sep0
	la $t2, ($a3)	

	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	lw $a0, ($t2)
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 1
	lw $a0, 40($t2)
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 1
	lw $a0, 44($t2)
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	#sep1
	lw $t2, 44($t2)
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	lw $a0, ($t2)
	syscall
		
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 1
	lw $a0, 40($t2)
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 1
	lw $a0, 44($t2)
	syscall
	
	#sep2
	lw $t2, 44($t2)
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	lw $a0, ($t2)
	syscall
		
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 1
	lw $a0, 40($t2)
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 1
	lw $a0, 44($t2)
	syscall
	#jal findNext
	
	j guideChoice
	
addPerson:
	jal getName
	jal getAge
	jal alloSpace
	jal initializeNode
	jal loadvariables
	jal addNode
	j guideChoice

######################################################################
# Gets a name from the user
######################################################################
# Stores value of Name in register $t7
######################################################################
getName:
        addi $sp, $sp, -4   # make room for 1 registers on the stack
	sw   $ra, 0($sp)    # save $ra onto the stack
	
	li $v0, 4
	la $a0, name
	syscall
	
	la $a0, userString
	li $v0, 8
	li $a1, 40
	syscall
	
	move $t0, $a0
	#la $t0, userString
	
	li $v0, 4
	la $a0, listheader
	syscall
	
	li $v0, 4
	move $a0, $t0
	syscall


	li $t5, 0    # $t1 is the counter. set it to 0 
	jal countChr
	
	la $t7, userString
	
	#li $v0, 4
	#move $a0, $t7
	#syscall
	
	lw   $ra, 0($sp)     # pop $ra from the stack
	addi $sp, $sp, 4     # free the stack by changing the stack pointer
	
	jr $ra

######################################################################
# Gets a age from the user
######################################################################
# Stores value of Name in register $t4
######################################################################
getAge:
	li $v0, 4
	la $a0, age
	syscall

	li $v0, 5
	syscall
	
	move $t4, $v0
	
	jr $ra
	

#print a message about each byte being displayed and its number in the index
countChr:  
# Load the first byte from address in $t0 
	lb $t2, 0($t0)  
# if this is a nonprintable character make it an endline instead of newline,
    	blt $t2, $s0, remove

# also increment the t0 and t1 address by 1 and jump back to the top
    	    	
    	add $t0, $t0, 1   
    	add $t5, $t5, 1   
    	j countChr        

#replace any nonprintable with an endline    	
remove: 
	sb $0, 0($t0)
	jr $ra

#allocate space in the heap
alloSpace:
	li	$v0, 9
	li	$a0, 48 # allocates 48 bytes, 4 to point to age, 12 for string and 4 for next
	syscall
	jr	$ra

initializeNode:
	move	$t1, $v0	# register t1 now has the address to the allocated space (12 bytes)
	
	sw	$zero, 40($t1)	# initalize age to zero
	sw	$zero, 44($t1)	# initialized next to zero
	jr $ra

loadvariables:
	sw $t7, ($t1)
	sw $t4, 40($t1)
	jr $ra 
	
addNode:
	#move $a0, $t7
	#li $v0, 4
	#syscall
	
	#lw $a0, ($t1)
	#li $v0, 4
	#syscall
	
	beqz	$s7, declareFirstNode
	#li $v0, 4
	#la $a0, nonext
	#syscall
	

	
	#lw $a0, 48($a3)	# check for next node of current node
	#move $a0, $t2
	#li $v0, 4
	#syscall
	
	#li $v0, 4
	#la $a0, nonext
	#syscall
	
	#lw $a0, 40($a3)	# check for next node of current node
	#move $a0, $t2
	#li $v0, 1
	#syscall
	
	#lw	$t2, 44($a3)	# check for next node of current node
	
	#beqz	$t2, noNextNode
	j NextNode
	
	
declareFirstNode:
	la	$s7, ($t1)	#set head pointer to point to string in the new node
	la	$a3, ($t1)	#set curr pointer to point to string in the new node
	j guideChoice
	
NextNode:
	li $v0, 4
	la $a0, nonext
	syscall
	
	#store head to temp $t2
	#la $t2, ($a3)
	# save next to to temp $t1 address
	sw $a3, 44($t1)	# initialized next to
	la $a3, ($t1)
	
	
	
	j guideChoice
	
emptylist:
	li $v0, 4
	la $a0, empty
	syscall
	
	j guideChoice
	
findNext:
	la $t2, 44($t2)
	beqz $t2, guideChoice
	j looplist
	