.data
    # --- ARQUIVO ---
    # AJUSTE O CAMINHO AQUI!
    nome_arquivo:   .asciiz "C:/Users/User/Documents/AOC/ProjetoFinal/Projeto-AOC/cartas.txt"
    
    # --- BUFFERS ---
    buffer_arquivo: .space 2048     # Texto bruto lido do arquivo
    
    # --- ESTRUTURA DE DADOS (ARRAY DE CARTAS) ---
    # Cada carta tem 40 bytes. 10 cartas = 400 bytes.
    # Layout: ID(0), Nome(4), Vida(24), Atk(28), Def(32), Elem(36)
    cartas_struct:  .space 400      
    
    # --- MENSAGENS ---
    msg_sucesso:    .asciiz "Leitura e Conversao concluidas!\n"
    msg_teste:      .asciiz "Teste de Memoria - Carta 1:\nNome: "
    msg_vida:       .asciiz "\nVida (Int): "
    msg_erro:       .asciiz "Erro ao abrir arquivo."

.text
.globl main

main:
    # =================================================
    # 1. LEITURA DO ARQUIVO (Igual ao anterior)
    # =================================================
    li   $v0, 13            # Open File
    la   $a0, nome_arquivo
    li   $a1, 0
    li   $a2, 0
    syscall
    
    move $s0, $v0           # Salva descritor em $s0
    blt  $v0, 0, erro       # Se der erro, sai

    li   $v0, 14            # Read File
    move $a0, $s0
    la   $a1, buffer_arquivo
    li   $a2, 2048
    syscall
    
    move $s1, $v0           # $s1 = Quantidade de bytes lidos
    
    li   $v0, 16            # Close File
    move $a0, $s0
    syscall

    # =================================================
    # 2. PARSER (CONVERSÃO TEXTO -> STRUCT)
    # =================================================
    
    la   $t0, buffer_arquivo    # $t0 = Ponteiro que percorre o texto (Cursor)
    la   $t1, cartas_struct     # $t1 = Ponteiro que percorre a memoria das cartas
    li   $t2, 0                 # $t2 = Contador de cartas (0 a 9)

loop_parser:
    beq  $t2, 10, fim_parser    # Se leu 10 cartas, acabou

    # --- A. LER ID (Inteiro) ---
    jal  pular_espacos          # Avanca cursor ate achar algo que nao seja espaco
    jal  ler_inteiro            # Converte texto p/ int. Resultado em $v0
    sw   $v0, 0($t1)            # Salva ID no offset 0 da struct atual

    # --- B. LER NOME (String) ---
    jal  pular_espacos
    move $a0, $t1               # $a0 = Endereco base da carta atual
    addi $a0, $a0, 4            # $a0 = Endereco base + 4 (Campo Nome)
    jal  ler_nome               # Copia caracteres ate achar espaco

    # --- C. LER VIDA (Inteiro) ---
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 24($t1)           # Salva Vida no offset 24

    # --- D. LER ATAQUE (Inteiro) ---
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 28($t1)           # Salva Ataque no offset 28

    # --- E. LER DEFESA (Inteiro) ---
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 32($t1)           # Salva Defesa no offset 32

    # --- F. LER ELEMENTO (Inteiro) ---
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 36($t1)           # Salva Elemento no offset 36

    # --- PROXIMA CARTA ---
    addi $t1, $t1, 40           # Avanca ponteiro da struct em 40 bytes
    addi $t2, $t2, 1            # Incrementa contador de cartas
    j    loop_parser

fim_parser:
    # =================================================
    # 3. TESTE: IMPRIMIR DADOS DA MEMÓRIA
    # =================================================
    
    # Imprime "Sucesso"
    li   $v0, 4
    la   $a0, msg_sucesso
    syscall

    # Imprime "Nome: "
    li   $v0, 4
    la   $a0, msg_teste
    syscall

    # Imprime o Nome da PRIMEIRA carta (que esta no inicio de cartas_struct + 4)
    li   $v0, 4
    la   $t9, cartas_struct
    addi $a0, $t9, 4        # Offset 4 = Nome
    syscall

    # Imprime "Vida: "
    li   $v0, 4
    la   $a0, msg_vida
    syscall

    # Imprime a Vida da PRIMEIRA carta (que esta no inicio de cartas_struct + 24)
    li   $v0, 1             # Print Integer
    lw   $a0, 24($t9)       # Carrega a palavra no offset 24
    syscall

    # Encerra
    li   $v0, 10
    syscall

erro:
    li   $v0, 4
    la   $a0, msg_erro
    syscall
    li   $v0, 10
    syscall

# =================================================
# SUB-ROTINAS (FUNÇÕES AUXILIARES)
# =================================================

# --- Função: Pular Espaços e Quebras de Linha ---
# Avança $t0 até encontrar um caractere visível
pular_espacos:
    lb   $t3, 0($t0)        # Lê byte atual
    beq  $t3, 32, pular     # Se for espaco (32), pula
    beq  $t3, 13, pular     # Se for \r (carriage return), pula
    beq  $t3, 10, pular     # Se for \n (new line), pula
    jr   $ra                # Se nao for nada disso, retorna (achou dado)
pular:
    addi $t0, $t0, 1        # Avança cursor
    j    pular_espacos

# --- Função: Ler Inteiro (ATOI) ---
# Lê dígitos em $t0 e converte para int em $v0
ler_inteiro:
    li   $v0, 0             # Zera o acumulador
atoi_loop:
    lb   $t3, 0($t0)        # Lê caractere
    blt  $t3, 48, atoi_fim  # Se menor que '0', acabou o numero
    bgt  $t3, 57, atoi_fim  # Se maior que '9', acabou o numero
    
    sub  $t3, $t3, 48       # Converte ASCII '0'-'9' para int 0-9
    mul  $v0, $v0, 10       # Desloca casa decimal (x10)
    add  $v0, $v0, $t3      # Soma o novo digito
    
    addi $t0, $t0, 1        # Avança cursor no texto
    j    atoi_loop
atoi_fim:
    jr   $ra

# --- Função: Ler Nome ---
# Copia string de $t0 para o endereço em $a0 até achar espaço
ler_nome:
    move $t4, $a0           # $t4 = Endereço de destino (struct.nome)
nome_loop:
    lb   $t3, 0($t0)        # Lê do texto
    beq  $t3, 32, nome_fim  # Se espaco, fim do nome
    beq  $t3, 13, nome_fim  # Se \r, fim
    beq  $t3, 10, nome_fim  # Se \n, fim
    
    sb   $t3, 0($t4)        # Salva byte na struct
    addi $t0, $t0, 1        # Avança cursor texto
    addi $t4, $t4, 1        # Avança cursor struct
    j    nome_loop
nome_fim:
    sb   $zero, 0($t4)      # Adiciona NULL terminator na string
    jr   $ra