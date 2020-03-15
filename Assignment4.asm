#####################################################################
# Program #1: <Using Floating points>     Programmer: <Chad Mcintire>
# Due Date: <03/14/2020>    Course: CS2810
# Date Last Modified: <03/14/2020>
#####################################################################
# Functional Description:
# <The program takes a float and an int. The program then returns the
# result the float raised to the int, then continues until the user is
# done>
#####################################################################
# Pseudocode:
#     cout << This program prompts you for an float and an int
#             The int is used as the exponent for the float,
#             and the result is calculated. Either number can
#             be positiveor negative, you will be prompted to 
#             compute a new number as many times as you want,
#             press N or n to exit when prompted.
#
#    While $v0 = char(y or Y)
#
#       get float
#	cout <<  "Please enter a float value:"
#       cin >> float($f1)
#
#       #get int
#       cout << "Please enter an integer value:"
#       cin >> int($s1)
#
#       #initalize float and value we will use to calculate
#	$f2 = $f1
#       $s2 = abs($s1)
#
#       #check if the exp. is zero if so take care of it
#       if $s2 = 0
#          cout << "$f1 raised to $s1 = 1"
#	   cout <<  "Continue and enter other values? (y or Y for yes): n"
#          cin >> $v0
#	   #follow continue logic
#
#       #initalize loop counter
#       $t0 = 1 
#       
#       #if the counter is the same as the abs(original int) (1) we don't need
#       #to loop but we do need to check if the exponent is negative and
#       #do the rest of the calculations
#       if ($t0 == $s2):
#
#           #if the int is negative, the number will be 1/$f2
# 	    if $s1 < 0:
#		$f2 = f2
#		$f2 = 1/$f2
#               cout << "$f1 raised to $s1 = $f2"
#               cin >> $v0
#	        #follow continue logic
#
#           #if $s1 if positive we can skip the division step		
#	    else:
#		while ($t0 < $s2):
#		    $f2 = $f2 * $f1
#               cout << "$f1 raised to $s1 = $f2"
#               cin >> $v0
#	        #follow continue logic
#		
#       #we loop until the counter = the int, because that
#       #is the number of times we need to multiply   	
#	while ($t0 < $s2):
#           $t0 += 1
#           $f2 = $f2 * $f1
#
#       #if the int is negative, the number will be 1/$f2
# 	if $s1 < 0:
#	   $f2 = 1/$f2
#          cout << "$f1 raised to $s1 = $f2"
#          cin >> $v0
#	   #follow continue logic
#       
#       #if $s1 if positive we can skip the division step
#	else:
#           $t0 += 1
#	    $f2 = $f2 * $f1
#           cout << "$f1 raised to $s1 = $f2"
#           cin >> $v0
#	    #follow continue logic
#		
#
#       ##continue logic
#
#       cout << "Continue and enter other values? (y or Y for yes):"
#       if ($v0 == int(y) or $v0 == int(Y)):
#           $t2 = 1
#       else:
#           $t2 = 0
#
#       if ($v0 == int(n) or $v0 == int(N)):
#           $t3 = 1
#       else:
#           $t3 = 0
#       
#       $t4 = ($t2 or t3)
#
#       #if neither y, Y, n, N, are not entered retry continue logic
#       if $t4:
#           cout << Continue and enter other values? (y or Y for yes):
#           #continue logic
#
#       #if no y or Y, exit
#       if !$t2:
#           cout << "Thanks for playing come again soon"
#           exit()
#
#      #if no n or N, start from the beginning by calling the procedure
#      if !$t3:
#          calnum() 
#      
#              
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $f0: Used to read in floats
# $f1: Used to store initial read in float
# $f2: Used to store a copy of initial float for computation
# $f12: Used to print Floats
# $s1: Used to store original int
# $s2: absolute value of $s1
# $t0-$t4: Used for temporary storage, and counters

######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
promptfloat:  .asciiz "\n    Please enter a float value: "
promptint:    .asciiz "\n    Please enter an integer value: "
raised:       .asciiz " raised to"
oneval:       .asciiz " 1 "
intzero:      .asciiz "Anything times 0 is 0"
continue1:    .asciiz "\n\nContinue and enter other values? (y or Y for yes): "
intro:        .ascii  "\nThis program prompts you for an float and an int\n"
              .ascii  "The int is used as the exponent for the float,\nand "
              .ascii  "the result is calculated. Either number can\nbe positive"
              .ascii  "or negative, you will be prompted to \ncompute a new number"
              .asciiz  " as many times as you want,\npress N or n to exit when prompted.\n"
thanks:       .asciiz  "\n\nThanks for playing come again soon"
newl:         .asciiz "\n"
indent:       .asciiz "    "
negexpval:    .float 1.0
	.text              # Executable code follows
main:
	li $v0, 4
	la $a0, intro
	syscall	
	
calnum:
	li $v0, 4
	la $a0, promptfloat
	syscall	

	li $v0, 6
	syscall
	
	#store the float at $f1
	li $v0, 2
	mov.s $f1, $f0
	
	li $v0, 4
	la $a0, promptint
	syscall	
	
	#store the int at $t1
	li $v0, 5
	syscall
	move $s1, $v0	
	
	# value to multiple and the final saved exponent
	mov.s $f2, $f1
	
	# t2 is the absolut value of the int so we can resolve the
	# exponetial computation then take care of the negative if we have to
	abs $s2, $s1
	
	# this takes care of the value of the exponent being zero
	beqz $s2, ifexpzero
	
	#calculate the exponential
	jal exp
	
	# print the calculated numbers
	jal printmessage
	
	#check if the user wants to continue
	j continue


ifexpzero: 
	# display the number if it is return message if the exponent is 0
	li $v0, 4
	la $a0, newl
	syscall
	
	li $v0, 4
	la $a0, indent
	syscall
	
	li $v0, 2
	mov.s $f12, $f1
	syscall
	
	li $v0, 4
	la $a0, raised
	syscall
	
	addi $a0, $zero, 32
	li $v0, 11
	syscall
	
	li $v0, 1
	move $a0, $s1
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
	
	
exp:    
	#initialize ad add to loop counter
	addi $t0, $t0, 1
	#check if the initial int value is 1  
	seq $t4, $t0, $s2
	#if the int is 1 then the math is done check if it is negative
        beq $t4, 1, checknegative

	#if we need to keep computing the number we multiply for new result
        mul.s $f2, $f2, $f1
        
        # we check if we have reached the int value
        seq $t4, $t0, $s2
        #if we haven't we multiply again
        beqz $t4, exp
        
        #once done we check if a value is negative
	j checknegative
	

checknegative:
	#check if the zero is less than the number, if the number is greater
	#we return else we do do the math for a -exponent
        slt $t3, $zero, $s1
        # branch to negativeexp if the user int was negative
        beqz $t3, negativeexp 
        jr $ra


negativeexp:
	#do 1/float then return for a negative
        l.s $f0, negexpval
        div.s $f2, $f0, $f2
	jr $ra


printmessage:
	# prints the format (float raised to in = result)
	li $v0, 4
	la $a0, newl
	syscall
	
	li $v0, 4
	la $a0, indent
	syscall

	li $v0, 2
	mov.s $f12, $f1
	syscall
	
	li $v0, 4
	la $a0, raised
	syscall
		
	addi $a0, $zero, 32
	li $v0, 11
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	addi $a0, $zero, 32
	li $v0, 11
	syscall
	
	addi $a0, $zero, 61
	li $v0, 11
	syscall
	
	addi $a0, $zero, 32
	li $v0, 11
	syscall
	
	li $v0, 2
	mov.s $f12, $f2
	syscall
	
	jr $ra


continue: 
        li $v0, 4
	la $a0, continue1
	syscall
	
	#get a character from the user
	li $v0, 12
	syscall
	
	#check if Y or y was selected
	seq $t0, $v0, 121
	seq $t1, $v0, 89
	or  $t2, $t0, $t1
	
	#check if N or n was selected
	seq $t0, $v0, 78
	seq $t1, $v0, 110
	or  $t3, $t0, $t1
        
        #check if neither of the previous conditions is true
        or $t4, $t3, $t2
    
        # if neither y, Y, n, or N is selected we go back to continue
        beqz $t4, continue
        #if $t4 is false, then we end if a Y, or Y is not selected
        beqz $t2, end
        #if $t4 is false and no n or N is found, we do another try at the game
        beqz $t3, calnum

	      	      
end:	
	# Thank and quit message
    	li $v0, 4
	la $a0, thanks
	syscall
	
	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM
