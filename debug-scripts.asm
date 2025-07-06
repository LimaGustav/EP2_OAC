
# $0 = tamanho do vetor; $a1 = vetor de floats
imprime_vetor:
   addi $sp, $sp, -4
   sw $ra, 0($sp)

   li $t0, 4 # tamanho da palavra
   mul $t1, $a0, $t0 # tamanho real do vetor
   move $t2, $a1 # armazena vetor
   li $t3, 0

   iv_loop:
      beq $t3, $t1, end_iv_loop
      
      addi $t2, $t2, 4 # incrementa a posicao do vetor
      addi $t3, $t3, 4 # incrementa o i do loop
      
      j iv_loop
      
   end_iv_loop:
      lw $ra, 0($sp)
      addi $sp, $sp, 4

      jr $ra








# $0 = tamanho do vetor; $a1 = vetor de strings
imprime_vetor_de_string:
   addi $sp, $sp, -4
   sw $ra, 0($sp)

   li $t0, 32 # tamanho da palavra
   mul $t1, $a0, $t0 # tamanho real do vetor
   move $t2, $a1 # armazena vetor em t2
   li $t3, 0 # contador i

   ivs_loop:
      bgt $t3, $t1, end_ivs_loop
      
      addi $t2, $t2, 32 # incrementa a posicao do vetor
      addi $t3, $t3, 32 # incrementa o i do loop
      
      j ivs_loop
      
   end_ivs_loop:
      lw $ra, 0($sp)
      addi $sp, $sp, 4

      jr $ra












# $a0 = float a ser impresso
imprime_float:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
   
   mtc1 $a0, $f2
   
   add.s $f12, $f10, $f2

   li $v0, 2
   syscall 
   
   la $a0, espaco
   jal imprime_string
   
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   
   jr $ra












# $a0 = string a ser impressa
imprime_string:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
   
   li $v0, 4
   syscall
   
   la $a0, espaco
   li $v0, 4
   syscall
   
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   
   jr $ra