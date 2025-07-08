.data
array:  .float 5.4, 3.1, 8.4, 1.7, 9.3, 2.6, 7.0, 4.9
array_string: .asciiz "5.2", "3.1", "8.4", "1.7", "9.3", "2.6", "7.0", "4.9"
size:   .word 8                                       
newline: .asciiz "\n"

.text
.globl main
.globl particao
.globl quickSort

main:
    
    la $a0, array          
    li $a1, 0             
    lw $a2, size
    addi $a2, $a2, -1      
    
    jal quickSort          
    jal imprimir
    
    # Sair
    li $v0, 10
    syscall


imprimir:
  addi $t1,$zero,0 # iterador
  lw $t2, size
  la $t3,array # inicio do array
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
    
# int particao(float* numeros, int inicio, int fim)
particao:
    
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # $a0 = numeros, $a1 = inicio, $a2 = fim
    move $s0, $a0        # $s0 = numeros (base address)
    move $s1, $a1        # $s1 = inicio
    move $s2, $a2        # $s2 = fim

    # pivo = numeros[fim]
    sll $t0, $s2, 2      # $t0 = fim * 4 (float offset)
    add $t0, $s0, $t0    # $t0 = address of numeros[fim]
    lwc1 $f0, 0($t0)     # $f0 = pivo = numeros[fim]

    # i = inicio - 1
    addi $s3, $s1, -1    # $s3 = i = inicio - 1

    # j = inicio
    move $t1, $s1        # $t1 = j = inicio

particao_loop:
    # for (j = inicio; j < fim; j++)
    bge $t1, $s2, particao_end_loop

    # numeros[j]
    sll $t2, $t1, 2      # $t2 = j * 4
    add $t2, $s0, $t2    # $t2 = address of numeros[j]
    lwc1 $f1, 0($t2)     # $f1 = numeros[j]

    # if (numeros[j] <= pivo)
    c.le.s $f1, $f0      # if $f1 <= $f0
    bc1f particao_continue

    # i = i + 1
    addi $s3, $s3, 1     # i++

    # Swap numeros[j] and numeros[i]
    sll $t3, $s3, 2      # $t3 = i * 4
    add $t3, $s0, $t3    # $t3 = address of numeros[i]
    lwc1 $f2, 0($t3)     # $f2 = numeros[i]
    swc1 $f1, 0($t3)     # numeros[i] = numeros[j]
    swc1 $f2, 0($t2)     # numeros[j] = $f2 (old numeros[i])

particao_continue:
    addi $t1, $t1, 1     # j++
    j particao_loop

particao_end_loop:
    # Swap numeros[i+1] and numeros[fim]
    addi $t4, $s3, 1     # $t4 = i + 1
    sll $t4, $t4, 2      # $t4 = (i+1) * 4
    add $t4, $s0, $t4    # $t4 = address of numeros[i+1]
    lwc1 $f3, 0($t4)     # $f3 = numeros[i+1]

    sll $t5, $s2, 2      # $t5 = fim * 4
    add $t5, $s0, $t5    # $t5 = address of numeros[fim]
    lwc1 $f4, 0($t5)     # $f4 = numeros[fim]

    swc1 $f4, 0($t4)     # numeros[i+1] = numeros[fim]
    swc1 $f3, 0($t5)     # numeros[fim] = $f3 (old numeros[i+1])

    # return i + 1
    addi $v0, $s3, 1

    # Restore $ra and $s registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

# void quickSort(float* numeros, int inicio, int fim)
quickSort:
    # Save $ra and $s registers
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # $a0 = numeros, $a1 = inicio, $a2 = fim
    move $s0, $a0        # $s0 = numeros
    move $s1, $a1        # $s1 = inicio
    move $s2, $a2        # $s2 = fim

    # if (inicio >= fim) return
    bge $s1, $s2, quickSort_end

    # Call particao
    move $a0, $s0        # arg1 = numeros
    move $a1, $s1        # arg2 = inicio
    move $a2, $s2        # arg3 = fim
    jal particao
    move $s3, $v0        # $s3 = q = particao result

    # quickSort(numeros, inicio, q - 1)
    move $a0, $s0        # arg1 = numeros
    move $a1, $s1        # arg2 = inicio
    addi $a2, $s3, -1    # arg3 = q - 1
    jal quickSort

    # quickSort(numeros, q + 1, fim)
    move $a0, $s0        # arg1 = numeros
    addi $a1, $s3, 1     # arg2 = q + 1
    move $a2, $s2        # arg3 = fim
    jal quickSort

quickSort_end:
    # Restore $ra and $s registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra