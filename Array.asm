.data
msg_input0: .asciiz "Du lieu nhap vao khong hop le! (0<n<100)\n"
msg_input1: .asciiz "Nhap Vao So Luong Phan Tu Mang n = "
msg_input2: .asciiz "Nhap Cac Phan Tu: "
msg_input3: .asciiz "Nhap Phan Tu Can Tim: "
msg_output1: .asciiz "Cac Phan Tu Cua Mang: "
msg_output2: .asciiz "Tong Cac Phan Tu Cua Mang: "
msg_output3: .asciiz "Cac So Nguyen To Trong Mang: "
msg_output4: .asciiz "Phan Tu Lon Nhat Trong Mang: "
msg_output5: .asciiz "Phan Tu Can Tim O Vi Tri i = "
msg_output6: .asciiz "Phan Tu Khong Co Trong Mang!"

output0: .asciiz "Lua Chon Khong Hop Le!\n"
output1: .asciiz "\nNhap 1 - Xuat Cac Phan Tu Cua Mang\n"
output2: .asciiz "Nhap 2 - Tinh Tong Cac Phan Tu Cua Mang\n"
output3: .asciiz "Nhap 3 - Xuat Cac Phan Tu La So Nguyen To Trong Mang\n"
output4: .asciiz "Nhap 4 - Xuat Phan Tu Lon Nhat Trong Mang\n"
output5: .asciiz "Nhap 5 - Tim Phan Tu Trong Mang\n"
output6: .asciiz "Nhap 6 - Thoat Chuong Trinh\n"
output7: .asciiz "\nNhap Lua Chon: "
output8: .asciiz "Chuong Trinh Da Ket Thuc! Hen Gap Lai!"

line_break: .asciiz "\n"
line_space: .asciiz " "
int_array: .word 0:100
.text
main:

#a0: input, output
#a1: int_array
#a2: so phan tu (n)
#a3: so can tim kiem (x)

#-----------------------------------------
# Nhap So Luong Phan Tu
jal input
move $t0,$v0

#-----------------------------------------
# Nhap cac phan tu cua mang
la $a0,msg_input2
li $v0,4
syscall

li $t1,0
la $t2,int_array
loop_input:
li $v0,5
syscall

sw $v0,($t2)
addi $t1,$t1,1
addi $t2,$t2,4
blt $t1,$t0,loop_input

#-----------------------------------------
run:
jal menu
jal choice
move $t1,$v0

li $t2, 0

addi $t3, $t1, -1
beq $t3, $t2, C1

addi $t3, $t1, -2
beq $t3, $t2, C2

addi $t3, $t1, -3
beq $t3, $t2, C3

addi $t3, $t1, -4
beq $t3, $t2, C4

addi $t3, $t1, -5
beq $t3, $t2, C5

addi $t3, $t1, -6
beq $t3, $t2, C6


#-----------------------------------------
#in cac phan tu cua mang
C1:
la $a0,msg_output1
li $v0,4
syscall

add $a2, $t0, $zero
la $a1, int_array
jal print_array
syscall

la $a0,line_break
li $v0,4
syscall

j run

#----------------------------------------------
#tinh tong cac phan tu trong mang
C2:
la $a0,msg_output2
li $v0,4
syscall

add $a2, $t0, $zero
la $a1, int_array
jal sum

move $a0,$v0
li $v0,1
syscall

la $a0,line_break
li $v0,4
syscall

j run

#-----------------------------------------
#in cac so nguyen to trong mang
C3:
la $a0,msg_output3
li $v0,4
syscall

add $a2, $t0, $zero
la $a1, int_array
jal print_prime

la $a0,line_break
li $v0,4
syscall

j run

#-------------------------------------------
#tim max cua cac phan tu trong mang
C4:
la $a0,msg_output4
li $v0,4
syscall

add $a2, $t0, $zero
la $a1, int_array
jal find_max

move $a0,$v0
li $v0,1
syscall

la $a0,line_break
li $v0,4
syscall

j run

#---------------------------------------------
#tim phan tu trong mang
C5:
la $a0,msg_input3
li $v0,4
syscall

li $v0,5
syscall
move $a3 ,$v0

add $a2, $t0, $zero
la $a1, int_array
jal find_value
syscall

la $a0,line_break
li $v0,4
syscall

j run
#---------------------------------------------
#ket thuc chuong trinh
C6:
la $a0,output8
li $v0,4
syscall

addi $a0, $0, 10
jal exit_program
syscall

#---------------------------------------------
input:
la $a0,msg_input1
li $v0,4
syscall

li $v0,5
syscall 

li $t1, 0
li $t2, 100

slt $t3, $v0, $t1
bne $t3, $0, FalseCase0

slt $t3, $t2, $v0
bne $t3, $0, FalseCase0

jr $ra

#---------------------------------------------
menu:
la $a0,output1
li $v0,4
syscall

la $a0,output2
li $v0,4
syscall

la $a0,output3
li $v0,4
syscall

la $a0,output4
li $v0,4
syscall

la $a0,output5
li $v0,4
syscall

la $a0,output6
li $v0,4
syscall

jr $ra

#---------------------------------------------
choice:
#Nhap lua chon:
la $a0,output7
li $v0,4
syscall

addi $v0,$0,5
syscall

li $t1, 1
li $t2, 6

slt $t3, $v0, $t1
bne $t3, $0, FalseCase

slt $t3, $t2, $v0
bne $t3, $0, FalseCase

jr $ra

#---------------------------------------------
sum:
li $t1,0
li $v0,0
loop_tong:
lw $t2,($a1)
add $v0,$v0,$t2
addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_tong
jr $ra

#-----------------------------------------------
print_array:
li $t1, 0
loop_print:
lw $t2, ($a1)
move $a0, $t2
li $v0, 1
syscall

la $a0, line_space
li $v0, 4
syscall

addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_print
jr $ra

#-----------------------------------------------
check_prime:
li $t4, 2
beq $a0, $t4, TrueCase1
slt $t3, $a0, $t4
bne $t3, $0, FalseCase1
loop_check:
div $a0, $t4
mfhi $s0
beq $s0, $zero, FalseCase1
addi $t4,$t4,1
blt $t4,$a0,loop_check
li $v0, 1
jr $ra

#-------------------------------------------------
print_prime:
li $t1, 0
addi $sp, $sp, -4
sw $ra, 4($sp)
loop_prime:
lw $a0, ($a1)
jal check_prime
bne $v0, $zero, TrueCase2
addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_prime
lw $ra, 4 ($sp)
addi $sp, $sp, 4
jr $ra

#-------------------------------------------------
find_max:
li $t1, 0
lw $v0, ($a1)
addi $t1,$t1,1
addi $a1,$a1,4
loop_find:
lw $t2, ($a1)
slt $t3, $v0, $t2
bne $t3, $0, TrueCase3
addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_find
jr $ra

#------------------------------------------------
find_value:
li $t1, 0
loop_value:
lw $t2, ($a1)
beq $a3, $t2, TrueCase4
addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_value
la $a0,msg_output6
li $v0,4
jr $ra

#------------------------------------------------
exit_program:
move $v0, $a0
syscall
jr $ra

#-------------------------------------------------
FalseCase:
la $a0,output0
li $v0,4
syscall
j choice

FalseCase0:
la $a0,msg_input0
li $v0,4
syscall
j input

FalseCase1: 
li $v0, 0
jr $ra

TrueCase1: 
li $v0, 1
jr $ra

TrueCase2: 
li $v0, 1
syscall

la $a0, line_space
li $v0, 4
syscall

addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_prime
lw $ra, 4 ($sp)
addi $sp, $sp, 4
jr $ra

TrueCase3:
move $v0, $t2
addi $t1,$t1,1
addi $a1,$a1,4
blt $t1,$a2,loop_find
jr $ra

TrueCase4:
la $a0,msg_output5
li $v0,4
syscall

move $a0, $t1
li $v0,1
jr $ra









