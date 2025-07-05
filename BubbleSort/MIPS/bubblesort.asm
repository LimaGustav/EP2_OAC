.data
	vetor: .word 1 12 3 5 3 7 0 -15 11
	space: .asciiz " "
	end: .asciiz "\nFim do looping"
	antes: .asciiz "Antes do algoritmo: "
	depois: .asciiz "\nDepois do algoritmo: "
.text
	la $s0, vetor
	li $s1, 0 # i do loop
	li $s3, 4 # tamanho da palavra
	li $s4, 8 # ultimo valor de de i
	li $s5, 7 # ultimo valor de j
	
	mul $s6, $s4, $s3 # ultima posicao do vetor
	
	
	la $a0, antes
	jal imprime_string
	
	move $a0, $s4
	move $a1, $s0
	jal imprime_vetor
	
	loop:
           beq $s1, $s4, end_loop # finaliza o loop se i == ultima posicao do vetor
	   mul $t0, $s3, $s1 # posicao atual do i no vetor
	   li $s2, 0 # j do loop2
	   
	   loop2:
	      beq $s2, $s5, end_loop2
	      mul $t2, $s2, $s3 # posicao atual do j
	      addi $t4, $s2, 1 # proximo valor de j
	      mul $t4, $t4, $s3
	      
	      lw $t3, 0($s0) # lê valor da posicao j do vetor
	      #move $a0, $t3
	      
	      # jal imprime_inteiro
	      
	      addi $s2, $s2, 1
	      addi $s0, $s0, 4
	      
	      lw $t5, 0($s0) # lê valor da proxima posicao j do vetor
	      
	      move $a0, $t2
	      move $a1, $t3
	      move $a2, $t4
	      move $a3, $t5
	      
	      blt, $t5, $t3, swap
	      
	      j loop2
	      
	      end_loop2:
           
           addi $s1, $s1, 1
           la $s0, vetor
	   j loop
	   
	   
        end_loop:
	   la $a0, depois
	   jal imprime_string
	   
	   move $a0, $s4 # tamanho do vetor
	   la $a1, vetor
	   jal imprime_vetor
	   
	   li $v0, 10
	   syscall
	   
	   
	swap: # $a0 = posicao à esquerda, $a1 = valor à esquerda; $a2 = posicao à direita; $a3 = valor à direita
	   move $t0, $a0 # armazena posicao do valor a esquerda em registrado temporaria
	   move $t1, $a1 # armazena valor a esquerda em registrador temporario
	   
	   la $t2, vetor
	   add $t3, $t2, $a0 # posicao no vetor do valor a esquerda
	   
	   la $t4, vetor
	   add $t5, $t4, $a2 # posicao no vetor do valor a direita
	   
	   sw $a3, 0($t3) # coloca valor a direita na posicao da esquerda
	   sw $t1, 0($t5) # coloca valor a esquerda na posicao da direita
	   
	   j loop2
	   
	   
	
	imprime_inteiro:
	   addi $sp, $sp, -4
	   sw $ra, 0($sp)
	
	   li $v0, 1
	   syscall 
	   
	   la $a0, space
	   jal imprime_string
	   
	   lw $ra, 0($sp)
	   addi $sp, $sp, 4
	   
	   jr $ra



	imprime_string:
	   addi $sp, $sp, -4
	   sw $ra, 0($sp)
	   
	   li $v0, 4
	   syscall
	   
	   lw $ra, 0($sp)
	   addi $sp, $sp, 4
	   
	   jr $ra



        imprime_vetor: # a0 = tamanho; a1 = vetor
           addi $sp, $sp, -4
	   sw $ra, 0($sp)
	   
           li $t0, 4 # tamanho da palavra
           mul $t1, $a0, $t0 # tamanho real do vetor
           move $t2, $a1 # armazena vetor
           li $t3, 0

           iv_loop:
              beq $t3, $t1, end_iv_loop
              lw $a0, 0($t2)
              
              jal imprime_inteiro
              
              addi $t2, $t2, 4 # incrementa a posicao do vetor
              addi $t3, $t3, 4 # incrementa o i do loop
              
              j iv_loop
              
           end_iv_loop:
              lw $ra, 0($sp)
	      addi $sp, $sp, 4
	   
              jr $ra
              
              
              
