.data
file_in: .asciiz	"input_sort.txt"		# File name
file_out: .asciiz	"output_sort.txt"		# File name

.word	0
buffer_out: .space 11000
buffer:	.space	12000		# Place to store character
	.align 2    		# word-aligned
array:  .word 2:1000    	# a word array of 10 elements
msg_output0: .asciiz "Khong The Mo File!\n"
msg_output1: .asciiz "Khong The Doc File!\n"
msg_output2: .asciiz "So luong phan tu cua mang khong hop le\n"
msg_output3: .asciiz "So luong phan tu cua mang: "
msg_output4: .asciiz "Cac Phan Tu Cua Mang: "
line_break: .asciiz "\n"
line_space: .asciiz " "

.text
#Bat dau ham main
#-----------------------------------------------------------------------------------------------
main:
# Open File:
li	$v0, 13			
la	$a0, file_in		# a0: chua file input
add	$a1, $0, $0		# a1: 0 - Read only
add	$a2, $0, $0		# a2 = mode = 0
syscall

slt $t0, $v0, $0
bne $t0, $0, FalseCase0	
		
add	$s0, $v0, $0		# v0 chua file descriptor

# Doc noi dung file ghi vao buf
li	$v0, 14			# 14=read from  file
add	$a0, $s0, $0		# $s0 contains fd
la	$a1, buffer		# buffer chua data cua file
li	$a2, 12000			
syscall

slt $t0, $v0, $0
bne $t0, $0, FalseCase1
	
li 	$s1, 0			# s1 chua vi tri doc cua ham atoi

#Doc so luong phan tu cua mang	
la	$a0, buffer		# truyen dia chi buffer vao 
jal 	atoi
move 	$a0, $v0
jal 	checkNArray
move 	$s2, $v0		#s2 chua so phan tu cua mang

la	$a0, msg_output3
li 	$v0, 4
syscall

li 	$v0, 1
move 	$a0, $s2
syscall
	
li	$v0, 4
la	$a0, line_break
syscall
	
#Doc cac phan tu vao mang
li 	$t5, 0
la 	$t6, array
la	$a0, buffer
add	$a0, $a0, $s1
addi	$a0, $a0, 1

loop_Array:
addi	$a0, $a0, 1
addi	$s1, $s1, 1
jal	atoi
sw 	$v0, ($t6)
addi 	$t5, $t5, 1
addi 	$t6, $t6, 4
blt 	$t5, $s2, loop_Array

#in cac phan tu cua mang nguon ra
la 	$a0, msg_output4
li 	$v0, 4
syscall

la 	$a1, array
jal 	print_array
syscall

la	$a0, line_break
li	$v0, 4
syscall

done:
li	$v0, 16			# 16=close file
add	$a0, $s0, $0		# $s0 contains fd
syscall				# close file

#goi ham quick sort
la	$t0, array 		# Moves the address of array into register $t0.
addi	$a0, $t0, 0 		# Set argument 1 to the array.
addi	$a1, $zero, 0 		# Set argument 2 to (low = 0)
add 	$a2, $zero, $s2
subi 	$a2, $a2, 1
jal 	quicksort 		# Call quick sort

#in cac phan tu cua mang nguon ra
la 	$a0, msg_output4
li 	$v0, 4
syscall

la 	$a1, array
jal 	print_array
syscall

la 	$a0, line_break
li 	$v0, 4
syscall

#chuyen array sang string vao buffer
la 	$a0, array
la 	$s6, buffer_out
li 	$a1, 0
jal 	arrayTostring
	
# Open (for writing) a file that does not exist
li	$v0, 13      	 # system call for open file
la   	$a0, file_out    # output file name
li   	$a1, 1       	 # Open for writing (flags are 0: read, 1: write)
li   	$a2, 0        	 # mode is ignored
syscall            	 # open a file (file descriptor returned in $v0)

move 	$s6, $v0      	 # save the file descriptor 

# Write to file just opened
li	$v0, 15        	 # system call for write to file
move 	$a0, $s6     	 # file descriptor 
la 	$a1, buffer_out  # address of buffer from which to write
li   	$a2, 11000       # hardcoded buffer length
syscall            	 # write to file

# Close the file 
li   	$v0, 16       	 # system call for close file
move 	$a0, $s6      	 # file descriptor to close
syscall            	 # close file

# Exit
exit:
li	$v0, 10
syscall

#-----------------------------------------------------------------------------------------------
atoi:
or      $v0, $zero, $zero   # num = 0
or      $t1, $zero, $zero   # isNegative = false
lb      $t0, 0($a0)
bne     $t0, '+', .isp      # consume a positive symbol
addi    $a0, $a0, 1
addi 	$s1, $s1, 1

.isp:
lb      $t0, 0($a0)
bne     $t0, '-', .num
addi    $t1, $zero, 1       # isNegative = true
addi    $a0, $a0, 1
addi 	$s1, $s1, 1

.num:
lb      $t0, 0($a0)
slti    $t2, $t0, 58        # *str <= '9'
slti    $t3, $t0, '0'       # *str < '0'
beq     $t2, $zero, .done
bne     $t3, $zero, .done
sll     $t2, $v0, 1
sll     $v0, $v0, 3
add     $v0, $v0, $t2       # num *= 10, using: num = (num << 3) + (num << 1)
addi    $t0, $t0, -48
add     $v0, $v0, $t0       # num += (*str - '0')
addi    $a0, $a0, 1         
addi 	$s1, $s1, 1
j   	.num

.done:
beq     $t1, $zero, .out    # if (isNegative) num = -num
sub     $v0, $zero, $v0

.out:
jr      $ra         	    # return

#check so luong phan tu mang
checkNArray:
li 	$t1, 2
li 	$t2, 1000

slt 	$t3, $v0, $t1
bne 	$t3, $0, FalseCase2
slt 	$t3, $t2, $v0
bne 	$t3, $0, FalseCase2
jr 	$ra

FalseCase0:
la 	$a0, msg_output0
li 	$v0, 4
syscall
j 	exit

FalseCase1:
la 	$a0, msg_output1
li 	$v0, 4
syscall
j 	exit


FalseCase2:
la 	$a0, msg_output2
li 	$v0, 4
syscall
j 	exit

#in array
print_array:
li 	$t1, 0
loop_print:
lw 	$t2, ($a1)
move 	$a0, $t2
li 	$v0, 1
syscall

la 	$a0, line_space
li 	$v0, 4
syscall

addi 	$t1, $t1, 1
addi 	$a1, $a1, 4
blt	$t1, $s2, loop_print
jr 	$ra

#------------------------------------------------------------------------------------------------
#QUICK SORT
swap:               	 #swap method
addi 	$sp, $sp, -12    # Make stack room for three

sw 	$a0, 0($sp)      # Store a0
sw 	$a1, 4($sp)      # Store a1
sw 	$a2, 8($sp)      # store a2

sll 	$t1, $a1, 2      #t1 = 4a
add 	$t1, $a0, $t1    #t1 = arr + 4a
lw 	$t3, 0($t1)      #s3  t = array[a]

sll 	$t2, $a2, 2      #t2 = 4b
add 	$t2, $a0, $t2    #t2 = arr + 4b
lw 	$t4, 0($t2)      #s4 = arr[b]

sw 	$t4, 0($t1)      #arr[a] = arr[b]
sw 	$t3, 0($t2)      #arr[b] = t 

addi 	$sp, $sp, 12     #Restoring the stack size
jr 	$ra          	 #jump back to the caller

partition:
addi 	$sp, $sp, -16  	 #Make room for 5

sw 	$a0, 0($sp)      #store a0
sw 	$a1, 4($sp)      #store a1
sw 	$a2, 8($sp)      #store a2
sw 	$ra, 12($sp)     #store return address

move 	$s3, $a1	 # s3: left = low
subi 	$s4, $a2, 1	 # s4: right = hight - 1

sll 	$t3, $a2, 2
add 	$t3, $a0, $t3
lw 	$s5, 0($t3)	 #pivot = a[high] = s5

while_true:
loop_left:
slt 	$t5, $s4, $s3
		
sll 	$t3, $s3, 2
add 	$t3, $a0, $t3
lw 	$t6, 0($t3)			#t6: a[left]
		
slt 	$t7, $t6, $s5		# a[left] < pivot ?
		
bne 	$t5, $zero, loop_right
beq 	$t7, $zero, loop_right	# False -> next

addi 	$s3, $s3, 1
j 	loop_left

loop_right:
slt 	$t5, $s4, $s3
		
sll 	$t3, $s4, 2
add 	$t3, $a0, $t3
lw 	$t6, 0($t3)			#t6: a[right]
		
slt 	$t7, $s5, $t6
		
bne 	$t5, $zero, continute
beq 	$t7, $zero, continute

subi 	$s4, $s4, 1
j 	loop_right

continute:
slt 	$t5, $s3, $s4
beq 	$t5, $zero, exit_loop
		
move 	$a1, $s3
move 	$a2, $s4
jal 	swap

addi 	$s3, $s3, 1
subi 	$s4, $s4, 1	
j 	while_true

exit_loop:
move 	$a1, $s3
lw 	$a2, 8($sp)
jal	swap
		
move 	$v0, $s3
lw 	$ra, 12($sp)
addi 	$sp, $sp, 16
jr 	$ra

quicksort:                   #quicksort method
addi 	$sp, $sp, -16        # Make room for 4

sw 	$a0, 0($sp)          # a0
sw 	$a1, 4($sp)          # low
sw 	$a2, 8($sp)          # high
sw 	$ra, 12($sp)         # return address

slt 	$t1, $a1, $a2        # t1=1 if low < high, else 0
beq 	$t1, $zero, endif    # if low >= high, endif

jal 	partition            # call partition 
move 	$s5, $v0             # pivot, s0= v0

lw 	$a1, 4($sp)          #a1 = low
addi 	$a2, $s5, -1         #a2 = pi -1
jal 	quicksort            #call quicksort

addi 	$a1, $s5, 1          #a1 = pi + 1
lw 	$a2, 8($sp)          #a2 = high
jal 	quicksort            #call quicksort

endif:
lw 	$a0, 0($sp)          #restore a0
lw 	$a1, 4($sp)          #restore a1
lw 	$a2, 8($sp)          #restore a2
lw 	$ra, 12($sp)         #restore return address
addi 	$sp, $sp, 16         #restore the stack
jr 	$ra                  #return to caller

#------------------------------------------------------------------------------------------------
#chuyen array sang string
arrayTostring:
sll 	$t1, $a1, 2     #t1 = 4a
add 	$t1, $a0, $t1   #t1 = arr + 4a
lw 	$t3, 0($t1)	#t3 = phan tu[a1]

li 	$s7, 0		#soluong chu so

count_digit:
li 	$t5, 10
div 	$t3, $t5	#t3 chua int
mfhi 	$t4		#luu du
mflo 	$t3		#luu thuong
	
addi 	$s7, $s7, 1
beq 	$t3, $0, set
j 	count_digit

set:			#set lai t3, t5
lw 	$t3, 0($t1)
li 	$t5, 10
subi 	$t6, $s7, 1 

itoa:
div 	$t3, $t5
mfhi 	$t4		#luu du
mflo 	$t3		#luu thuong
		
add 	$s6, $s6, $t6
addi 	$t4, $t4, 48
sb 	$t4, 0($s6)
addi 	$s6, $s6, -1
li 	$t6, 0
beq 	$t3, $0, next_index
j 	itoa

next_index:
add 	$s6, $s6, $s7
addi 	$s6, $s6, 1
addi 	$t4, $0, 32
sb 	$t4, 0($s6)
addi 	$s6, $s6, 1
	
addi 	$a1, $a1, 1
beq 	$a1, $s2, exit_Tostring
j 	arrayTostring

exit_Tostring:
jr 	$ra
