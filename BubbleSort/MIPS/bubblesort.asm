.data
	zeroF: .float 0.0
	space: .asciiz " "
	
	caminhoArquivo: .asciiz "/Users/mbp16/Documents/Projects/oac-ep2/EP2_OAC/dados.txt"
	conteudoDoArquivo: .space 120000
	quebraDeLinhaAsc: .word 10
	
	linhaAtual: .space 32
	
	zeroFloat: .float 0.0
	umFloat:  .float 1.0
	dezFloat:  .float 10.0
	zeroPontoUmFloat:  .float 0.1
	
	digitosEmFloat: .float 0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0
	
	vetor: .space 120000
	vetorString: .space 120000
	
	espaco: .asciiz " "

   bubbleSortMensagem: .asciiz "Ordenando vetor com Bubble Sort...\n"
   quickSortMensagem: .asciiz "Ordenando vetor com Quick Sort...\n"


.text
   jal le_arquivo

   la $s0, vetor
   li $s1, 0 # i do loop
   li $s3, 4 # tamanho da palavra
   move $s4, $s6 # quantidade de palavras do vetor
   subi $s5, $s4, 1 # quantidade de vezes que o j serah percorrido

   li $s7, 0 # tipo de ordenação escolhido. 0 = bubblesort, 1 = quicksort
      
   mul $s6, $s4, $s3 # tamanho do vetor em bytes

   move $a0, $s4 # tamanho do vetor
   move $a1, $s7 # tipo de ordenação
   move $a2, $s0 # vetor de floats

   jal ordena

   li $v0, 10
   syscall







ordena:
   move $t0, $a0 # tamanho do vetor
   move $t1, $a1 # tipo de ordenação
   move $t2, $a2 # vetor de floats

   li $t3, 1
   beq $t1, $zero, executa_bubblesort
   beq $t1, $t3, executa_quicksort

   li $v0, 10
   syscall

   executa_bubblesort:
      la $a0, bubbleSortMensagem
      li $v0, 4
      syscall

      move $a0, $s0 # vetor
      move $a1, $s4 # tamanho do vetor
      jal bubblesort

      move $a0, $v0 # pega vetor retornado e coloca em a0
      move $a1, $s4 # pega tamanho do vetor e coloca em a1
      jal escreve_no_arquivo

      li $v0, 10
      syscall

   executa_quicksort:
      la $a0, quickSortMensagem
      li $v0, 4
      syscall

      # precisamos implementar ainda
      li $v0, 10
      syscall











bubblesort:
   move $s0, $a0 # vetor de floats
   move $s4, $a1 # tamanho do vetor

   addi $sp, $sp, -4
   sw $ra, 0($sp)

   lwc1 $f10, zeroF
   
   move $a0, $s4
   move $a1, $s0
   
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
      
      
   end_loop: # se finalizado, retorna o vetor ordenado
      lw $ra, 0($sp)
      addi $sp, $sp, 4

      la $v0, vetorString

      jr $ra
      
      
   swap: # $a0 = posicao à esquerda, $a1 = posicao à direita; $f12 = float a esquerda; $f14 = float a direita
      move $t0, $a0 # armazena posicao do valor a esquerda em registrado temporaria
      mov.s $f1, $f12 # armazena valor a esquerda em registrador temporario
      
      la $t2, vetor
      add $t3, $t2, $a0 # posicao no vetor do valor a esquerda
      
      la $t4, vetor
      add $t5, $t4, $a1 # posicao no vetor do valor a direita
      
      swc1 $f14, 0($t3) # coloca valor a direita na posicao da esquerda
      swc1 $f1, 0($t5) # coloca valor a esquerda na posicao da direita
      
      # swap da string agora
      
      li $t6, 8 # valor que precisa para ser multiplicado e cehgar a 32 bytes
      
      mul $t0, $t0, $t6 # transforma a posicao a esquerda na posicao da string, que eh de 32 bytes
      
      mul $t2, $a1, $t6 # transforma a posicao a direita na posicao da string, que eh de 32 bytes
      
      la $t3, vetorString
      add $t3, $t3, $t0 #posicao no vetor do valor a esquerda
      lw $t5, 0($t3)
      
      la $t4, vetorString
      add $t4, $t4, $t2
      lw $t6, 0($t4)
      
      sw $t5, 0($t4)
      sw $t6, 0($t3)
      
      j loop2
	   












le_arquivo:
   addi $sp, $sp, -4
   sw $ra, 0($sp)
      
   la $a0, caminhoArquivo
   li $a1, 0
   li $v0, 13
   syscall
   
   move $s2, $v0
   
   move $a0, $s2
   la $a1, conteudoDoArquivo
   la $a2, 100000
   li $v0, 14
   syscall
   
   move $a0, $v0 # tamanho lido do arquivo
   move $s7, $a0 # quantidade de bytes lidos do arquivo
   addi $t7, $s7, 1
   
   la $s1, vetor
   la $t4, quebraDeLinhaAsc
   lw $t4, 0($t4)
   la $t5, conteudoDoArquivo
   li $s6, 0 # contador de palavras
   li $t7, 0 # contador de caracteres lidos
   
   la $t9, linhaAtual # linha atual
   
   la $s3, vetorString
   
   read_loop:
      bgt $t7, $s7, fim_read_loop
      
      lb $t3, 0($t5) # caractere atual
      addi $t7, $t7, 1
      addi $t5, $t5, 1
      
      bgt $t7, $s7, grava_numero_como_float
      beq $t3, $t4, grava_numero_como_float
      sb $t3, 0($t9)
      
      addi $t9, $t9, 1
      
      j read_loop

   fim_read_loop:  
      jal fecha_arquivo
      
      lw $ra, 0($sp)
      addi $sp, $sp, 4
      
      jr $ra
   
   
   
   
   
   
   grava_numero_como_float:
      sb $zero, 0($t9) # adiciono o 0 no fim para indicar que é uma string
      
      la $a0, linhaAtual
      move $a1, $s3
      jal copia_string
      
      la $a0, linhaAtual
      
      # conversão da linha atual, que estah como string, em float
      jal converte_string_para_float
      
      # guarda float no vetor
      swc1 $f0, 0($s1)
      addi $s1, $s1, 4
      addi $s3, $s3, 32
      
      la $t9, linhaAtual
      
      addi $s6, $s6, 1
   
      j read_loop
   










# $a0 = origem, $a1 = destino
copia_string:
   lb   $s4, 0($a0)       # carrega o byte atual da origem
   sb   $s4, 0($a1)       # armazena no destino
   beqz $s4, fim_copia    # se for 0 (fim da string), termina
   addi $a0, $a0, 1       # avança na origem
   addi $a1, $a1, 1       # avança no destino
   j copia_string

fim_copia:
   jr $ra
   
   










   
   
# fecha arquivo que estava sendo lido
fecha_arquivo:
   li $v0, 16
   move $a0, $s2
   syscall
   
   jr $ra














         
# $a0 = string que vai ser convertida
converte_string_para_float:
   # f0 = acc (resultado), f2 = factor (1.0 ou 0.1, 0.01, ...)
   l.s  $f0, zeroFloat       # acc = 0.0
   l.s  $f2, umFloat        # factor = 1.0   (antes do ponto)
   l.s  $f3, dezFloat        # 10.0  (const)
   l.s  $f4, zeroPontoUmFloat        # 0.1   (const)

   li   $t0, 0 # flag do decimal; 0 = parte inteira, 1 = parte fracionária
   li $t6, 0 # flag do sinal; 0 = positivo e 1 negativo

   move $s0, $a0 # string recebida

   # verificacao do sinal do numero
   lb   $t1, 0($s0)
   li   $t2, 45 # codigo asc do -
   bne  $t1, $t2, continua_parse # se valor for positivo, continua
   li   $t6, 1 # marca como negativo
   addi $s0, $s0, 1 # pula o símbolo '-' e segue

   continua_parse:

   loop_conversao:
      lb   $t1, 0($s0)         # lê próximo char
      beqz $t1, finaliza_conversao         # fim da string?

      li   $t2, 46             # 46 é o '.'
      beq  $t1, $t2, sinaliza_decimal

      # se não é dígito, pula
      li   $t2, 48             # 49 é o digito 0
      li   $t3, 57             # 57 é o digito 9
      blt  $t1, $t2, passa_pro_proximo_char # checa se valor é menor que 0
      bgt  $t1, $t3, passa_pro_proximo_char # checa se valor é maior que 9

      sub  $t1, $t1, $t2       # t1 = dígito (0-9)

      # carrega digito como float
      la   $s5, digitosEmFloat
      sll $t1, $t1, 2         # *4 (tamanho float)
      add  $s5, $s5, $t1
      l.s  $f1, 0($s5)         # f1 = dígito em float

      beq  $t0, 0, trata_inteiro

      # parte fracionária
      mul.s $f2, $f2, $f4
      mul.s $f5, $f1, $f2 # multiplica o valor por 0.1
      add.s $f0, $f0, $f5 # adiciona parte fracionaria no valor final
      j    passa_pro_proximo_char

   trata_inteiro:
      mul.s $f0, $f0, $f3      # deixa valor inteiro
      add.s $f0, $f0, $f1      # soma inteiro no valor final
      j    passa_pro_proximo_char

   sinaliza_decimal:
      li   $t0, 1              # agora na parte decimal
      j    passa_pro_proximo_char

   passa_pro_proximo_char:
      addi $s0, $s0, 1 # vai pro proximo char
      j    loop_conversao

   finaliza_conversao:
      beq  $t6, $zero, retorno
      neg.s $f0, $f0
      jr   $ra

   retorno:
      jr   $ra













# $a0 = vetor de strings; $a1 = tamanho
escreve_no_arquivo:
   move $s0, $a0 # vetor 
   move $s1, $a1 # tamahno do vetor

   la $a0, caminhoArquivo
   li $a1, 9
   li $v0, 13
   syscall # salva descritor no v0
   
   move $s2, $v0
   
   # escrevendo string no arquivo
   move $a0, $s2
   la $a1, quebraDeLinhaAsc
   li $a2, 1
   li $v0, 15
   syscall
   
   li $v0, 15
   syscall
   
   li $t0, 0 # contador
   
   loop_escrita:
      beq $t0, $s1, fim_loop_escrita # se contador ultrapassar tamanho
      
      li $t1, 0 # tamanho da string
      
      contador_de_tamanho_da_string_loop:
         lb  $t2, 0($s0)
         beqz $t2, fim_contador_de_tamanho_da_string_loop
         addi $s0, $s0, 1
         addi $t1, $t1, 1
         j    contador_de_tamanho_da_string_loop
         
      fim_contador_de_tamanho_da_string_loop:
         move $a2, $t1     # $a2 = n bytes reais, sem o '\0'
         
      sub $s0, $s0, $t1
      
      move $a0, $s2
      move $a1, $s0
      li $v0, 15
      syscall
      
      move $a0, $s2
      la $a1, quebraDeLinhaAsc
      li $a2, 1
      li $v0, 15
      syscall
      
      addi $s0, $s0, 32
      addi $t0, $t0, 1
      
      j loop_escrita
   
   
   fim_loop_escrita:
   
   
   # fecha arquivo
   li $v0, 16
   move $a0, $s2
   syscall
   
   jr $ra
