.data
	vetor: .word 1 12 3 5 3 7 0 -15 11
	space: .asciiz " "
	end: .asciiz "\nFim do looping"
.text
	la $s0, vetor
	li $s1, 0 # i do loop
	li $s3, 4 # tamanho da palavra
	li $s4, 4 # ultimo valor de de i
	li $s5, 3 # ultimo valor de j
	
	mul $s6, $s4, $s3 # ultima posicao do vetor
	
	loop:
           beq $s1, $s4, end_loop # finaliza o loop se i == ultima posicao do vetor
	   mul $t0, $s3, $s1 # posicao atual do i no vetor
	   li $s2, 0 # j do loop2
	   
	   loop2:
	      beq $s2, $s5, end_loop2
	      mul $t2, $s3, $s2 # posicao atual do j
	      
	      lw $t3, 0($s0)
	      move $a0, $t3
	      
	      jal imprime_inteiro
	      
	      addi $s2, $s2, 1
	      addi $s0, $s0, 4
	      
	      j loop2
	      
	      end_loop2:
           
           addi $s1, $s1, 1
           la $s0, vetor
	   j loop
	
	end_loop:
	   la $a0, end
	   jal imprime_string
	   
	   li $v0, 10
	   syscall
	   
	   
	
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
