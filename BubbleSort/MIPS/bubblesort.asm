.data
	vetor: .float 1.1 12.0 3.0 5.0 3.0 7.0 0.0 -15.0 11.0
	zeroF: .float 0.0
	space: .asciiz " "
	end: .asciiz "\nFim do looping"
	antes: .asciiz "Antes do algoritmo: "
	depois: .asciiz "\nDepois do algoritmo: "

.text
	la $s0, vetor
	li $s1, 0 # i do loop
	li $s3, 4 # tamanho da palavra
	li $s4, 9 # ultimo valor de de i
	li $s5, 8 # ultimo valor de j
	
	mul $s6, $s4, $s3 # ultima posicao do vetor
	
	lwc1 $f10, zeroF
	
	
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
	      beq $s2, $s5, end_loop2 # checa se o j do loop2 é igual à última posição
	      mul $t2, $s2, $s3 # posicao atual do j
	      addi $t4, $s2, 1 # proximo valor de j
	      mul $t4, $t4, $s3
	      
	      lwc1 $f12, 0($s0) # lê valor da posicao j do vetor
	      
	      addi $s2, $s2, 1
	      addi $s0, $s0, 4
	      
	      lwc1 $f14, 0($s0) # lê valor da proxima posicao j do vetor
	      
	      move $a0, $t2
	      move $a1, $t4
	      
	      c.lt.s, $f14, $f12
	      bc1t swap
	      
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
	   
	   
	swap: # $a0 = posicao à esquerda, $a1 = posicao à direita; $f12 = float a esquerda; $f14 = float a direita
	   move $t0, $a0 # armazena posicao do valor a esquerda em registrado temporaria
	   mov.s $f1, $f12 # armazena valor a esquerda em registrador temporario
	   
	   la $t2, vetor
	   add $t3, $t2, $a0 # posicao no vetor do valor a esquerda
	   
	   la $t4, vetor
	   add $t5, $t4, $a1 # posicao no vetor do valor a direita
	   
	   swc1 $f14, 0($t3) # coloca valor a direita na posicao da esquerda
	   swc1 $f1, 0($t5) # coloca valor a esquerda na posicao da direita
	   
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
              
              jal imprime_float
              
              addi $t2, $t2, 4 # incrementa a posicao do vetor
              addi $t3, $t3, 4 # incrementa o i do loop
              
              j iv_loop
              
           end_iv_loop:
              lw $ra, 0($sp)
	      addi $sp, $sp, 4
	   
              jr $ra
              
         
        imprime_float:
	   addi $sp, $sp, -4
	   sw $ra, 0($sp)
	   
	   mtc1 $a0, $f2
	   
	   add.s $f12, $f10, $f2
	
	   li $v0, 2
	   syscall 
	   
	   la $a0, space
	   jal imprime_string
	   
	   lw $ra, 0($sp)
	   addi $sp, $sp, 4
	   
	   jr $ra
