.data
uncom: .asciiz "\nThe uncompressed file size : "
com: .asciiz "\nThe compressed file size : "
ratio: .asciiz "\nFile Compression Ratio : "
newline: .asciiz "\n" 
dectexi: .asciiz "\nWelcome to our mips program.\nDoes the dictionary.txt file exist? "
menu: .asciiz "\nThe Menu:\n c) compress, or compression means compression.\n d) decompress, decompression means decompression.\n q) quit means quit the program.\nYour choice is : "
ask: .asciiz "\nEnter the path of the file to be compressed:\n"
ermessge: .asciiz "\nWrong choice"
fin: .asciiz "D:/dictionary.txt"
c_fin: .asciiz "D:/comp.txt"
filenam: .asciiz "\nWhat is the file name? "
fn: .asciiz "sami"
compfile: .asciiz ""
buffer: .space 256
dictionary: .space 1024
dictionary_array: .space 2048
text_array: .space 2048
comp_array: .space 2048
index: .byte 0    
bufferint: .space 32  

                
.text
.globl main
main: 
	
	la $a0, dectexi
	li $v0, 4  
	syscall
	li $v0, 12
	syscall
	li $t1, 121
	beq $v0,$t1,filename
	li $t1, 110
	beq $v0,$t1,exiest
	b choiceq

filename:
	la $a0, filenam	
	li $v0, 4
	syscall
	li $v0, 8
    	la $a0, fn
   	li $a1, 18
	syscall
   	li $v0, 13       # system call for open file
	la $a0, fn      # board file name
	li $a1, 0        # Open for reading
	li $a2, 0
	syscall
	move $s0, $v0      # save the file descriptor 

	    # Read characters from the file
d_read_loop:
    	li $v0, 14               # system call code for reading from a file
    	move $a0, $s0            # file descriptor in $a0
    	la $a1, dictionary           # buffer address in $a1
    	li $a2, 1024              # buffer size in $a2
    	syscall                  # read from the file

    	beqz $v0, end_read_loop  # exit the loop if no characters read

    	# Process the characters
    	la $t0, dictionary           # load buffer address into $t0
    	li $t4, 0
    	la $t2, dictionary_array
	la $t5, dictionary_array
	
d_process_chars:
   	lbu $t1, ($t0)           # load the character into $t1

    	beqz $t1, d_end_read_loop   # exit if end of string (null character)

    	# Check if character is a space or delimiter
    	beq $t1,'\n', d_next_char   # if space, go to next character
	
    	sb $t1, ($t2)            # store character in word_array
    	addi $t2, $t2, 1       # add index offset to $t2
	addi $t0, $t0, 1        # move to next character in buffer
    	j d_process_chars
d_next_char:           
    	addi $t5,$t5, 16
	addi $t2, $t5, 0
	addi $t0, $t0, 1        # move to next character in buffer
	b d_process_chars
	
    	


d_end_read_loop:
	move $t7,$t5
	
	
    	# Close the file
    	li $v0, 16              # system call code for closing a file
    	move $a0, $s0           # file descriptor in $a0
    	syscall
	
	
			
exiest:
	la $a0, menu 
	li $v0, 4  
	syscall
	li $v0, 12
	syscall
	li $t1, 99
	beq $v0,$t1,choicec
	li $t1, 67
	beq $v0,$t1,choicec
	li $t1, 68
	beq $v0,$t1,choiced
	li $t1, 100
	beq $v0,$t1,choiced
	li $t1, 113
	beq $v0,$t1,choiceq
	li $t1, 81
	beq $v0,$t1,choiceq
	b worng

choicec:
	la $a0, ask 
	li $v0, 4 
	syscall
	la $a0,compfile
	li $a1,12
	li $v0,8
	syscall
	li   $v0, 13       # system call for open file
	la   $a0, compfile      # board file name
	li   $a1, 0        # Open for reading
	li   $a2, 0
	syscall            # open a file (file descriptor returned in $v0)
	move $s0, $v0      # save the file descriptor 






	li $s7,0
	    # Read characters from the file
read_loop:
    	li $v0, 14               # system call code for reading from a file
    	move $a0, $s0            # file descriptor in $a0
    	la $a1, buffer           # buffer address in $a1
    	li $a2, 256              # buffer size in $a2
    	syscall                  # read from the file

    	beqz $v0, end_read_loop  # exit the loop if no characters read

    	# Process the characters
    	la $t0, buffer           # load buffer address into $t0
    	li $t4, 0
    	la $t2, text_array
	la $t5, text_array
	li $t9,1
	
process_chars:
   	lb $t1, ($t0)           # load the character into $t1

    	beqz $t1, end_read_loop   # exit if end of string (null character)

    	# Check if character is a space or delimiter
    	beq $t1,' ', checkbefore
	beq $t1,'.', checkbefore
	beq $t1,',', checkbefore
	beq $t1,':', checkbefore
	beq $t1,'\n', checkbefore
	
    	sb $t1, ($t2)            # store character in word_array
    	addi $t2, $t2, 1       # add index offset to $t2
	addi $t0, $t0, 1        # move to next character in buffer
	addi $s7,$s7,1
	li $t9,0
    	j process_chars

checkbefore:
	beq $t9,1,next_char2   	    	
    	
next_char1:
	addi $t5, $t5, 16
	addi $t2, $t5, 0
	sb $t1, 0($t2)            # store character in word_array
    	addi $t5,$t5, 16
	addi $t2, $t5, 0
	addi $t0, $t0, 1        # move to next character in buffer
	addi $s7,$s7,1
	li $t9,1
	b process_chars
	
next_char2:
	sb $t1, 0($t2)            # store character in word_array
    	addi $t5,$t5, 16
	addi $t2, $t5, 0
	addi $t0, $t0, 1        # move to next character in buffer
	addi $s7,$s7,1
	li $t9,1
	b process_chars	
	
    	


end_read_loop:
	# Close the file
	mul $s7,$s7,16
    	li $v0, 16              # system call code for closing a file
    	move $a0, $s0           # file descriptor in $a0
    	syscall
 
    	
    	   	
    	   	   	
    	   	   	   	
    	   	   	   	   	
    	   	   	   	   	   	   	
    	li $s6,0		
        la $s0, comp_array
    	li $t2, 0
    	la $t0, text_array     
    	la $t1, dictionary_array 
initloop:    	  	
	move $s3,$t0
	move $s4,$t1
loop:	
        lb $a0, ($s3)    # Load a character from str1
        lb $a1, ($s4)    # Load a character from str2
        lb $t9,dictionary_array 
        beqz $t9,add_to_dict
        beqz $a0, check
        beqz $a1, notequal
        beq $a0,$a1,incre
        bne $a0,$a1,notequal
incre:
	addi $s3,$s3,1
	addi $s4,$s4,1
	b loop        
		
check:
	beqz $a1,equal

notequal:
	addi $t1,$t1,16
	addi $t2,$t2,1
	move $s4,$t1
	lb $a1,($s4)
	beqz $a1, add_to_dict
	b initloop

add_to_dict:
	move $t6,$t0
	move $a0,$s4
loopadd:
	lbu $t5,($t6)
	beqz $t5, equal   # exit if end of string (null character)
	
    	sb $t5, ($a0)            # store character in word_array
    	addi $a0,$a0,1
    	addi $t6,$t6,1
    	b loopadd

equal:
	addi $s6,$s6,1
	sb $t2, 0($s0)
	addi $s0,$s0,8
	addi $t0,$t0,16
	
	lb $a0,($t0)
	beqz $a0, goprint
	la $t1, dictionary_array 
	li $t2,0
	b initloop
	la $a0, ermessge
	li $v0, 4
	syscall														

goprint:
	mul $s6,$s6,16
	la $a0, uncom
	li $v0, 4
	syscall
	move $a0, $s7
	li $v0, 1
	syscall
	la $a0, com
	li $v0, 4
	syscall
	move $a0, $s6
	li $v0, 1
	syscall
	div $s7,$s7,$s6
	la $a0, ratio
	li $v0, 4
	syscall
	move $a0, $s7
	li $v0, 1
	syscall
	
print:
	# Open the file for writing
    	li $v0, 13       # system call for open file
    	la $a0, fin 
    	li $a1, 1        # open for writing
    	li $a2, 0        # file permissions (not used here)
    	syscall          # open the file (file descriptor returned in $v0)
    	move $s0, $v0    # store the file descriptor in $s0
    	
    	la $s5, dictionary_array   # load the address of the string
    	li $t0, 0        		#	 initialize the character counter
init_print_loop:    	
    	move $t9,$s5
print_loop:
	
    	la $t1, ($t9)    # load a character from the string
    	lb $t8, ($t1)
    	beqz $t8, next_in    # exit the loop if end of string (null terminator)

    	# Write the character to the file
    	li $v0, 15       # system call for write
    	move $a0, $s0    # file descriptor
    	move $a1, $t1    # character to write
    	li $a2, 1        # number of characters to write
    	syscall          # write the character to the file

    	addi $t9, $t9, 1 # increment the string address
    	j print_loop

next_in:
	li $v0, 15              # System call code for writing to file
    	move $a0, $s0         # Load address of newline character
    	la $a1, newline              # Length of the string to write
    	li $a2, 1               # File descriptor (1 for standard output)
    	syscall                 # Execute the system call
    	
	addi $s5,$s5,16
	lb $t8,($s5)
	beqz $t8,f_print_loop
	b init_print_loop   	    	
    	
f_print_loop: 
	li $v0, 16      # system call for close file
    	move $a0, $s0   # file descriptor
    	syscall         # close the file  
    	
    	  	    	

    	  	    	  	    	  	    	
    	  	    	  	    	  	    	    	  	    	  	    	  	    	
    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	
    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	
    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	
c_print:
	# Open the file for writing
    	li $v0, 13       # system call for open file
    	la $a0, c_fin 
    	li $a1, 1        # open for writing
    	li $a2, 0        # file permissions (not used here)
    	syscall          # open the file (file descriptor returned in $v0)
    	move $s0, $v0    # store the file descriptor in $s0
    	
    	la $s5, comp_array   # load the address of the string
    	li $t0, 0        		#	 initialize the character counter
c_init_print_loop:    	
    	move $t9,$s5
c_print_loop:
	
    	la $t1, bufferint       # Address of the buffer
    	lb $t2, ($t9)        # Copy the integer value
    	addi $t1,$t1,1

convert_loop:
    	addiu $sp, $sp, -4   # Allocate space on the stack for remainder
    	div $t2, $t2, 10     # Divide by 10 to get quotient and remainder
    	mfhi $t3             # Get the remainder
    	addiu $t3, $t3, 48   # Convert to ASCII by adding '0'
    	sb $t3, ($t1)        # Store ASCII digit in buffer
    	subiu $t1, $t1, 1    # Increment buffer address
    	beqz $t2, done       # Exit the loop if quotient is zero
    	j convert_loop

done:
    	sb $zero, ($t1)      # Null-terminate the buffer
	
    # Write ASCII representation to the file
    	li $v0, 15           # System call for write
    	move $a0,$s0       # Buffer address
    	la $a1, bufferint         # File descriptor
    	li $a2, 32           # Number of characters to write
    	syscall              # Write the buffer to the file
    	
    	addi $s5,$s5,8
	lb $t8,($s5)
	beqz $t8,c_f_print_loop
    	
	li $v0, 15              # System call code for writing to file
    	move $a0, $s0         # Load address of newline character
    	la $a1, newline              # Length of the string to write
    	li $a2, 1               # File descriptor (1 for standard output)
    	syscall                 # Execute the system call
    	
	b c_init_print_loop   	    	
    	
c_f_print_loop: 
	li $v0, 16      # system call for close file
    	move $a0, $s0   # file descriptor
    	syscall         # close the file      	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	
    	b choiceq 
    	 	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	    	  	    	  	    	  	    	
choiced:




worng:
	la $a0, ermessge
	li $v0, 4
	syscall
	
choiceq:
	li $v0, 10 # Exit program
	syscall
	
