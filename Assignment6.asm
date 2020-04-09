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
	 
empty:    .asciiz "\n\nThe list is empty, nothing to print."

newline:  .asciiz "\n"

listheader: .asciiz "\n-------- List Contents ----------\n"
	 
endMessage: .asciiz "\nThanks for the info, have a good day!"
choice:  .asciiz "\n\n\tWhich option between 1 and 3 do you choose? "

name:    .asciiz "\nPlease enter a name (up to 40 characters): "
age:     .asciiz "Please enter the age for "

listprintname: .asciiz "Name: "
listprintage: .asciiz "Age: "
tabs:         .asciiz " \t"

	.text              # Executable code follows


main:
# initialize t1 as a counter and s0 as the upper bound for non-printable characters

    	li $s0, 32   # $s3 is the upper bound
    	
    	#print welcome message
    	li $v0, 4
	la $a0, welcome
	syscall
    	
	j printMenu
	
######################################################################
# Prints the menu options and drops to reach
######################################################################
# No registers were saved
######################################################################
printMenu: 
	li $v0, 4
	la $a0, menu
	syscall

readChoice:
	li $v0, 4  # Ask for a choice
	la $a0, choice
	syscall	
	
	li $v0, 5 # Get the integer for the choice
	syscall
	
	move $t0, $v0 # temporarily store choice in $t0

	ble $t0, 0, readChoice	# check if the number is in the 1 to 3 range if not ask for another
	bge $t0, 4, readChoice	# choice
	
	beq $t0, 1, printList #branch to the respective choice
        beq $t0, 2, addPerson
        beq $t0, 3, end
	
	jr $ra

######################################################################
# Prints the list of nodes in FILO order
######################################################################
# Uses $t2 to traverse the nodes, head is $a3
######################################################################
printList:
	beqz $a3, emptylist
	
	li $v0, 4
	la $a0, listheader
	syscall	
	
	la $t2, ($a3)	

looplist:
	li $v0, 4
	la $a0, listprintname
	syscall

	li $v0, 4
	la $a0, ($t2)
	syscall
		
	li $v0, 4
	la $a0, tabs
	syscall
	
	
	li $v0, 4
	la $a0, listprintage
	syscall
	
	li $v0, 1
	lw $a0, 40($t2)
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	lw $t2, 44($t2)

	beqz $t2, printMenu
	
	j looplist

emptylist:
	li $v0, 4
	la $a0, empty
	syscall
	
	j printMenu

######################################################################
# Gets a name, age from the user, and if there is a next, assigns it
######################################################################
# $t1 is used for assigning the node, $a3 is used for storing the nodes
######################################################################
addPerson:
	li $v0, 4
	la $a0, name
	syscall
	
	#allocate space
	li	$v0, 9
	li	$a0, 48 # allocates 48 bytes, 4 to point to age, 12 for string and 4 for next
	syscall

	#initialize the nodes
	move	$t1, $v0	# register t1 now has the address to the allocated space (48 bytes)
	sw	$zero, 40($t1)	# initalize age to zero
	sw	$zero, 44($t1)	# initalize age to zero
	
	#load the user name into the newly allocated space for it
	la $a0, ($t1)
	li $v0, 8
	li $a1, 40
	syscall
	
	move $t0, $a0

countChr:  
	lb $t2, 0($t0)  # Load the first byte from address in $t0 
    	blt $t2, $s0, remove # if this is a nonprintable character make it an endline instead of newline,
    	add $t0, $t0, 1 # also increment the t0 address by 1 and jump back to the top
    	j countChr        

#replace any nonprintable with an endline    	
remove: 
	sb $0, 0($t0)

	#get the age the user enters
	li $v0, 4 #message to get user age
	la $a0, age
	syscall
	
	li $v0, 4 #print inserted name
	la $a0, ($t1)
	syscall	
	
	li $v0, 11 #print a colon
	li $a0, 58
	syscall	

	li $v0, 11 #print a space
	li $a0, 32
	syscall	

	li $v0, 5 #read the age in
	syscall
	
	#save the age to the memory allocated for it
	sw $v0, 40($t1)

	beqz $a3, declareFirstNode #if first node get don't use it's address as next
	
	sw $a3, 44($t1)	# initialized address of current node to next
	la $a3, ($t1) #push node
	
	j printMenu
	
declareFirstNode:
	la $a3, ($t1)	#push first node
	j printMenu

######################################################################
# Gets a age from the user
######################################################################
# Stores value of Name in register $t4
######################################################################
end:
	li $v0, 4
	la $a0, endMessage
	syscall

	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM
