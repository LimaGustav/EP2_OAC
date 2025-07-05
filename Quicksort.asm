.data
meu_array: .float 1.5, 2.75, -3.0, 4.25, 1.54, 3.5
tam: .word 6
newline: .asciiz "\n"



.text
lw $s0, tam # tamanho do array
la $a0,meu_array # inicio do array
addi $a1, $zero, 0 # inicio
addi $a2, $s0, -1 # fim
jal quickSort
jal imprimir

quickSort:
  addi $sp, $sp, -20
  
  sw $fp, 16($sp)
  sw $ra, 12($sp)
  sw $a0, 8($sp)
  sw $a1, 4($sp)
  sw $a2, 0($sp)

  bge $a1,$a2,quickReturn
  lw $a0, 8($sp)
  lw $a1, 4($sp)
  lw $a2, 0($sp)
  
  move $fp, $sp
    
  jal particao
  
  # quickSort(numeros, inicio, q - 1)
  move $t1, $v0
  addi $a1,$t1,-1
  jal quickSort
  
  # quickSort(numeros, q + 1, fim)
  lw $a0, 8($fp)
  addi $a1, $t1, 1  # inicio = q + 1
  lw $a2, 0($fp)    # fim
  jal quickSort



quickReturn:
  lw $fp, 16($sp)
  lw $ra, 12($sp)
  addi $sp,$sp,20
  jr $ra


particao:
  addi $sp, $sp, -20
  sw $ra, 16($sp)
  sw $a0, 12($sp)     
  sw $a1, 8($sp)      
  sw $a2, 4($sp)
  sw $fp, 0($sp)

  # pivo = numeros[fim]
  move $fp, $sp
  mul $t0, $a2, 4          
  add $t0, $a0, $t0         
  l.s $f2, 0($t0)
  
  addi $t1, $a1, -1
  move $t2, $a1 
  
particao_loop:
  bge $t2, $a2, particao_fim
  sll $t3, $t2, 2
  add $t4, $a0, $t3
  l.s $f4, 0($t4)
    
  c.le.s $f4, $f2
  bc1f noSwap
  
  
  addi $t1, $t1, 1
  
  sll $t5, $t1, 2
  add $t6, $a0, $t5     
  l.s $f6, 0($t6)      
  s.s $f6, 0($t4)      
  s.s $f4, 0($t6)
    
noSwap:
  addi $t2, $t2, 1
  j particao_loop
particao_fim:

  addi $t1, $t1, 1      
  sll $t7, $t1, 2
  add $t8, $a0, $t7     
  l.s $f4, 0($t8)       
  l.s $f6, 0($t0)        

  s.s $f6, 0($t8)        
  s.s $f4, 0($t0)

  move $v0, $t1

  lw $fp, 0($sp)
  lw $ra, 16($sp)
  addi $sp, $sp, 20
  jr $ra
      
imprimir:
addi $t1,$zero,0 # iterador
lw $t2, tam
la $t3,meu_array # inicio do array
loop:
beq $t1,$t2,fim
mul $t4,$t1,4
add $t4,$t3,$t4
l.s $f12, 0($t4)
li $v0,2
syscall
la $a0,newline
li $v0,4
syscall

addi $t1,$t1,1
j loop



fim:
addi $v0,$v0,10
syscall
