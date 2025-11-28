.data
    nome_arquivo:       .asciiz "cartas.txt"
    .align 2
    
    # --- BUFFERS ---
    buffer_arquivo:     .space 2048     # Texto bruto lido do arquivo
    
    # Layout: ID(0), Nome(4), Vida(24), Atk(28), Def(32), Elem(36)
    cartas_struct:      .space 400  
    
    # --- CARTAS ESCOLHIDAS PELOS JOGADORES ---
    # J1: offsets 0, 4, 8 | J2: offsets 12, 16, 20
    cartas_escolhidas:  .space 24       
    
    # --- ARQUIVO DE SAÍDA ---
    nome_saida:     .asciiz "resultado_jogo.txt"
    buffer_conv:    .space 16       # Buffer temporário para conversão
    
    txt_espaco:     .asciiz " "     # Separador de campos
    txt_enter:      .asciiz "\n"    # Separador de linhas
    
    # --- MENSAGENS TESTES ---
    msg_sucesso:    .asciiz "Leitura e Conversao concluidas!\n"
    msg_teste:      .asciiz "Teste de Memoria "
    msg_nomecarta:  .asciiz "\nNome: "
    msg_vida:       .asciiz "\nVida (Int): "
    msg_ataque:     .asciiz "\nAtaque (Int): "
    msg_defesa:     .asciiz "\nDefesa (Int): "
    msg_elemento:   .asciiz "\nElemento (Int): "
    msg_erro:       .asciiz "Erro ao abrir arquivo."
    msg_id:         .asciiz "\nID(int): "
    
    # --- MENSAGENS USUARIO ---
    msg_escolha:     .asciiz "\nEscolha uma carta (ID): "
    msg_disponiveis: .asciiz "As cartas disponiveis são"
    

.text
.globl main

main:
    # ---------------------------------------------------------
    # 1. ABRIR E LER ARQUIVO
    # ---------------------------------------------------------
    li   $v0, 13            # Open File
    la   $a0, nome_arquivo
    li   $a1, 0
    li   $a2, 0
    syscall
    
    move $s0, $v0           # Salva descritor
    blt  $v0, 0, erro       # Se erro, sai

    li   $v0, 14            # Read File
    move $a0, $s0
    la   $a1, buffer_arquivo
    li   $a2, 2048
    syscall
    
    move $s1, $v0           # $s1 = Quantidade lida
    
    li   $v0, 16            # Close File
    move $a0, $s0
    syscall
    
    # ---------------------------------------------------------
    # 2. PARSER (CONVERTER TEXTO PARA STRUCT)
    # ---------------------------------------------------------
    la   $t0, buffer_arquivo    # $t0 = Cursor no texto
    la   $t1, cartas_struct     # $t1 = Cursor na struct
    li   $t2, 0                 # $t2 = Contador de cartas (0 a 9)

loop_leitura:
    beq  $t2, 10, preparacao_jogo  # Se leu 10, vai para o JOGO!

    # A. ID
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 0($t1)

    # B. NOME
    jal  pular_espacos
    move $a0, $t1
    addi $a0, $a0, 4
    jal  ler_nome

    # C. VIDA
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 24($t1)

    # D. ATAQUE
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 28($t1)

    # E. DEFESA
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 32($t1)

    # F. ELEMENTO
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 36($t1)

    # PROXIMA
    addi $t1, $t1, 40
    addi $t2, $t2, 1
    j    loop_leitura

# ---------------------------------------------------------
# 3. LÓGICA DE ESCOLHA DE CARTAS (JOGADORES)
# ---------------------------------------------------------
preparacao_jogo:
    la   $t3, cartas_escolhidas # Base do array de escolhidas
    
    # Prepara contadores e ponteiros
    li   $t0, 0                 # Contador de turnos (0 a 5)
    move $s1, $t3               # $s1 = Ponteiro Jogador 1 (Offset 0)
    addi $s2, $t3, 12           # $s2 = Ponteiro Jogador 2 (Offset 12)

loop_escolha:
    beq  $t0, 6, zera_t2        # Se escolheram 6 cartas, vai imprimir tudo

    # Mensagem "Escolha uma carta"
    li   $v0, 4
    la   $a0, msg_escolha
    syscall

    # Verifica vez (Par = J1, Ímpar = J2)
    andi $t4, $t0, 1         
    bne  $t4, 0, jogador_dois 

jogador_um:
    li   $v0, 5          # Lê ID
    syscall
    sw   $v0, 0($s1)     # Salva no slot do J1
    addi $s1, $s1, 4     # Avança slot J1
    j    proximo_turno

jogador_dois:
    li   $v0, 5          # Lê ID
    syscall
    sw   $v0, 0($s2)     # Salva no slot do J2
    addi $s2, $s2, 4     # Avança slot J2

proximo_turno:
    addi $t0, $t0, 1     # Próximo turno
    j    loop_escolha

# ---------------------------------------------------------
# 4. IMPRIMIR TODAS AS CARTAS (DEBUG/CONFERÊNCIA)
# ---------------------------------------------------------
zera_t2:
    li   $t2, 0
    la   $t9, cartas_struct
    
    # Mensagem de sucesso (opcional)
    li   $v0, 4
    la   $a0, msg_sucesso
    syscall

loop_impressao:
    beq  $t2, 10, salvar_arquivo

    # ID
    li   $v0, 4
    la   $a0, msg_id
    syscall
    
    li   $v0, 1
    lw   $a0, 0($t9)
    syscall

    # Nome
    li   $v0, 4
    la   $a0, msg_nomecarta
    syscall
    
    li   $v0, 4
    addi $a0, $t9, 4
    syscall

    # Vida
    li   $v0, 4
    la   $a0, msg_vida
    syscall
    
    li   $v0, 1
    lw   $a0, 24($t9)
    syscall
    
    # Ataque
    li   $v0, 4
    la   $a0, msg_ataque
    syscall
    
    li   $v0, 1
    lw   $a0, 28($t9)
    syscall
    
    # Defesa
    li   $v0, 4
    la   $a0, msg_defesa
    syscall
    
    li   $v0, 1
    lw   $a0, 32($t9)
    syscall
    
    # Elemento
    li   $v0, 4
    la   $a0, msg_elemento
    syscall
    
    li   $v0, 1
    lw   $a0, 36($t9)
    syscall
    
    # Pula linha
    li   $v0, 11
    li   $a0, 10
    syscall

    # Avança
    addi $t9, $t9, 40
    addi $t2, $t2, 1
    j    loop_impressao

# =========================================================
# 5. SALVAR ARQUIVO (FORMATO RAW/BRUTO)
# =========================================================
salvar_arquivo:
    # 1. ABRIR ARQUIVO (WRITE)
    li   $v0, 13
    la   $a0, nome_saida
    li   $a1, 1             # 1 = Escrita
    li   $a2, 0
    syscall
    
    move $s7, $v0           # $s7 = ID do Arquivo
    blt  $v0, 0, erro

    # 2. LOOP DAS CARTAS ESCOLHIDAS
    la   $s0, cartas_escolhidas  # Ponteiro para IDs escolhidos
    li   $s1, 0                  # Contador (0 a 6)

loop_gravar_raw:
    beq  $s1, 6, fechar_raw

    # --- Pegar o ID escolhido ---
    lw   $t0, 0($s0)        # $t0 = ID alvo (ex: 5)

    # --- Buscar na Struct ---
    la   $t1, cartas_struct # $t1 = Ponteiro busca
    li   $t2, 0             # Contador busca

busca_raw:
    beq  $t2, 10, proxima_raw_save # Segurança
    lw   $t3, 0($t1)               # Lê ID do baralho
    beq  $t3, $t0, achou_raw       # Achou!
    
    addi $t1, $t1, 40       # Próxima carta
    addi $t2, $t2, 1
    j    busca_raw

achou_raw:
    # Agora $t1 aponta para a carta. Vamos escrever: ID NOME VIDA ATK DEF ELEM
    
    # 1. ID
    lw   $a0, 0($t1)        # Carrega Valor ID
    jal  escreve_int        # Escreve numero
    jal  escreve_espaco     # Escreve " "

    # 2. NOME (String não precisa converter)
    addi $a0, $t1, 4        # Endereço do Nome
    jal  escreve_string_mem # Função especial para string da memória
    jal  escreve_espaco

    # 3. VIDA
    lw   $a0, 24($t1)
    jal  escreve_int
    jal  escreve_espaco

    # 4. ATAQUE
    lw   $a0, 28($t1)
    jal  escreve_int
    jal  escreve_espaco

    # 5. DEFESA
    lw   $a0, 32($t1)
    jal  escreve_int
    jal  escreve_espaco

    # 6. ELEMENTO
    lw   $a0, 36($t1)
    jal  escreve_int
    
    # Fim da linha (Enter)
    la   $a0, txt_enter
    li   $v0, 15
    move $a1, $a0
    li   $a2, 1             # 1 caractere
    move $a0, $s7
    syscall

proxima_raw_save:
    addi $s0, $s0, 4        # Próximo ID escolhido
    addi $s1, $s1, 1        # +1 carta feita
    j    loop_gravar_raw

fechar_raw:
    li   $v0, 16
    move $a0, $s7
    syscall
    j    fim_programa

# =========================================================
# HELPER: ESCREVE INTEIRO NO ARQUIVO
# Entrada: $a0 = Inteiro
# =========================================================
escreve_int:
    sub  $sp, $sp, 4        # Salva $ra
    sw   $ra, 0($sp)
    
    la   $a1, buffer_conv   # Buffer temporário
    jal  int_to_string      # Converte (No funcoes.asm)
    
    move $a2, $v0           # Tamanho retornado
    la   $a1, buffer_conv   # Texto convertido
    li   $v0, 15            # Write
    move $a0, $s7           # ID Arquivo
    syscall

    lw   $ra, 0($sp)        # Recupera $ra
    addi $sp, $sp, 4
    jr   $ra

# =========================================================
# HELPER: ESCREVE ESPAÇO
# =========================================================
escreve_espaco:
    la   $a1, txt_espaco
    li   $a2, 1             # Tamanho 1
    li   $v0, 15
    move $a0, $s7
    syscall
    jr   $ra

# =========================================================
# HELPER: ESCREVE STRING DA MEMÓRIA (Calcula tamanho)
# Entrada: $a0 = Endereço da String (ex: Nome da carta)
# =========================================================
escreve_string_mem:
    move $t8, $a0           # Salva início
    li   $t9, 0             # Tamanho = 0
strlen_loop:
    lb   $t5, 0($t8)        # Lê byte
    beqz $t5, strlen_fim    # Se 0 (null), fim
    addi $t8, $t8, 1
    addi $t9, $t9, 1
    j    strlen_loop
strlen_fim:
    move $a1, $a0           # Buffer
    move $a2, $t9           # Tamanho calculado
    li   $v0, 15            # Write
    move $a0, $s7           # ID Arquivo
    syscall
    jr   $ra
    
erro:
    li   $v0, 4
    la   $a0, msg_erro
    syscall

fim_programa:
    li   $v0, 10
    syscall

.include "funcoes.asm"