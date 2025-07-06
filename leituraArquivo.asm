.data:
	end: .asciiz "\nFim do looping: "
	caminhoArquivo: .asciiz "/Users/mbp16/Documents/Projects/oac-ep2/EP2_OAC/dados.txt"
	conteudoDoArquivo: .space 120000
	quebraDeLinhaAsc: .word 10
	espacoAsc: .word 32
	
	linhaAtual: .space 32
	
	zeroFloat: .float 0.0
	umFloat:  .float 1.0
	dezFloat:  .float 10.0
	zeroPontoUmFloat:  .float 0.1        # 10^-1
	
	digitosEmFloat: .float 0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0
	
	vetorFloat: .space 120000
	vetorString: .space 120000
	
	espaco: .asciiz " "

.text:

le_arquivo:
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
   
   move $a0, $v0
   li $v0, 1
   syscall
   
   move $s7, $a0 # quantidade de bytes lidos do arquivo
   addi $t7, $s7, 1
   
   la $a0, quebraDeLinhaAsc
   li $v0, 4
   syscall
   
   
   #la $t1, linhaAtual
   la $s1, vetorFloat
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
      la $a0, quebraDeLinhaAsc
      li $v0, 4
      syscall
   
      move $a0, $t7
      li $v0, 1
      syscall
      
      la $a0, quebraDeLinhaAsc
      li $v0, 4
      syscall
      
      move $a0, $s6
      la $a1, vetorFloat
      jal imprime_vetor
      
      la $a0, quebraDeLinhaAsc
      li $v0, 4
      syscall
      
      # move $a0, $s6
      move $a0, $s6
      la  $a1, vetorString
      jal imprime_vetor_de_string

      jal fecha_arquivo
      
      # jal escreve_no_arquivo
      
      li $v0, 10
      syscall
   
   
   
   
   
   
   grava_numero_como_float:
      sb $zero, 0($t9) # adiciono o 0 no fim para indicar que é uma string
      
      # conversão da linha atual em float
      la $a0, linhaAtual
      move $a1, $s3
      jal copia_string
      # guarda string no vetor
      ## li $v0, 4
      ## syscall
      
      la $a0, linhaAtual
      
      jal converte_string_para_float
      
      # mov.s $f12, $f03
      # li $v0, 2
      # syscall
      
      # guarda float no vetor
      swc1 $f0, 0($s1)
      addi $s1, $s1, 4
      addi $s3, $s3, 32
      
      la $t9, linhaAtual
      
      addi $s6, $s6, 1
      
      # la $a0, espaco
      # li $v0, 4
      # syscall
   
      j read_loop
   
   
   
   
      copia_string:
          lb   $s4, 0($a0)       # carrega o byte atual da origem
          sb   $s4, 0($a1)       # armazena no destino
          beqz $s4, fim_copia    # se for 0 (fim da string), termina
          addi $a0, $a0, 1       # avança na origem
          addi $a1, $a1, 1       # avança no destino
          j copia_string
  
      fim_copia:
          jr $ra
         
   
   
   
# fecha arquivo
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




imprime_vetor_de_string: # a0 = tamanho; a1 = vetor
   addi $sp, $sp, -4
   sw $ra, 0($sp)

   li $t0, 32 # tamanho da palavra
   mul $t1, $a0, $t0 # tamanho real do vetor
   move $t2, $a1 # armazena vetor em t2
   li $t3, 0 # contador i

   ivs_loop:
      bgt $t3, $t1, end_ivs_loop
      move $a0, $t2
      
      jal imprime_string
      
      la $a0, espaco
      jal imprime_string
      
      addi $t2, $t2, 32 # incrementa a posicao do vetor
      addi $t3, $t3, 32 # incrementa o i do loop
      
      j ivs_loop
      
   end_ivs_loop:
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
   
   la $a0, espaco
   jal imprime_string
   
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   
   jr $ra





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




escreve_no_arquivo:
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
   
   # fecha arquivo
   li $v0, 16
   move $a0, $s2
   syscall
   
   jr $ra
