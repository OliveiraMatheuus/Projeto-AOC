.data
    # --- ARQUIVOS ---
    # AJUSTE O CAMINHO ABAIXO SE O MARS NÃO ENCONTRAR O ARQUIVO
    # Exemplo: "C:/Users/SEU_USUARIO/Documents/ProjetoAOC/cartas.txt"
    nome_arquivo:       .asciiz "cartas.txt"
    nome_saida:         .asciiz "resultado_jogo.txt"
    
    .align 2
    
    # --- BUFFERS ---
    buffer_arquivo:     .space 2048     # Buffer genérico de leitura
    
    # STRUCTS
    # Base: ID(0), Nome(4), Vida(24), Atk(28), Def(32), Elem(36)
    cartas_struct:      .space 400      
    
    # Estado do Jogo (Cartas Vivas em Jogo - 6 cartas)
    cartas_em_jogo:     .space 240 
    
    # IDs Escolhidos (Usado apenas na seleção de novo jogo)
    cartas_escolhidas:  .space 24       
    
    # --- AUXILIARES ---
    buffer_conv:    .space 16
    txt_espaco:     .asciiz " "
    txt_enter:      .asciiz "\n"
    
    # --- MENUS E MENSAGENS ---
    msg_menu:       .asciiz "\n\n=== BATALHA ELEMENTAL ===\n1. Ver Cartas Disponiveis\n2. Novo Jogo (Escolher Cartas)\n3. Carregar Jogo Salvo\n4. Sair\nEscolha: "
    msg_erro:       .asciiz "\nErro de Arquivo! Verifique o caminho ou se o arquivo existe.\n"
    msg_carregado:  .asciiz "\nJogo Carregado! As cartas atuais sao:\n"
    
    # Labels de atributos
    lbl_id:         .asciiz "ID: "
    lbl_nome:       .asciiz " | Nome: "
    lbl_vida:       .asciiz " | HP: "
    lbl_atk:        .asciiz " | Atk: "
    lbl_def:        .asciiz " | Def: "
    lbl_elem:       .asciiz " | Elem: "
    
    # Mensagens de Jogo
    msg_escolha:    .asciiz "\nEscolha uma carta pelo ID: "
    msg_vez_j1:     .asciiz "\n>>> Vez do Jogador 1 (Escolha ID): "
    msg_vez_j2:     .asciiz "\n>>> Vez do Jogador 2 (Escolha ID): "
    msg_invalida:   .asciiz "\n[!] ID Invalido! Essa carta nao existe.\n"
    msg_repetida:   .asciiz "\n[!] Carta Repetida! Escolha outra.\n"

.text
.globl main

main:
    # =========================================================
    # PASSO 1: CARREGAR A BASE DE DADOS (cartas.txt)
    # =========================================================
    
    # 1. Abrir cartas.txt
    li   $v0, 13
    la   $a0, nome_arquivo
    li   $a1, 0             # Read-only
    li   $a2, 0
    syscall
    move $s0, $v0
    blt  $v0, 0, erro_fatal

    # 2. Ler
    li   $v0, 14
    move $a0, $s0
    la   $a1, buffer_arquivo
    li   $a2, 2048
    syscall
    
    # 3. Fechar
    li   $v0, 16
    move $a0, $s0
    syscall
    
    # 4. Parsear (Texto -> cartas_struct)
    la   $t0, buffer_arquivo
    la   $t1, cartas_struct
    li   $t2, 0

loop_parse_base:
    beq  $t2, 10, menu_principal    # Terminou de ler as 10 cartas?

    # Parse campos
    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 0($t1)    # ID

    jal  pular_espacos
    move $a0, $t1
    addi $a0, $a0, 4
    jal  ler_nome       # Nome

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 24($t1)   # Vida

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 28($t1)   # Atk

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 32($t1)   # Def

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 36($t1)   # Elem

    addi $t1, $t1, 40   # Próxima carta
    addi $t2, $t2, 1
    j    loop_parse_base

# =========================================================
# MENU PRINCIPAL
# =========================================================
menu_principal:
    # Imprime Menu
    li   $v0, 4
    la   $a0, msg_menu
    syscall
    
    # Lê Opção
    li   $v0, 5
    syscall
    move $t0, $v0
    
    beq  $t0, 1, ver_cartas
    beq  $t0, 2, novo_jogo
    beq  $t0, 3, carregar_jogo
    beq  $t0, 4, fim_programa
    j    menu_principal         # Opção inválida, repete

# =========================================================
# OPÇÃO 1: VER CARTAS DISPONÍVEIS
# =========================================================
ver_cartas:
    la   $t9, cartas_struct     # Ponteiro para base de dados
    li   $t2, 0                 # Contador 0-9
    
loop_ver:
    beq  $t2, 10, menu_principal
    
    jal  imprimir_carta_detalhada
    
    addi $t9, $t9, 40
    addi $t2, $t2, 1
    j    loop_ver

# =========================================================
# OPÇÃO 2: NOVO JOGO (COM VALIDAÇÃO DE CONFLITO)
# =========================================================
novo_jogo:
    # 1. Limpar buffer de escolhas (Para evitar lixo de jogos anteriores)
    la   $t0, cartas_escolhidas
    li   $t1, 0
    li   $t2, 0
limpar_buffer_loop:
    beq  $t2, 6, iniciar_selecao
    sw   $zero, 0($t0)          # Zera o slot
    addi $t0, $t0, 4            # Próximo slot (4 bytes)
    addi $t2, $t2, 1
    j    limpar_buffer_loop

iniciar_selecao:
    la   $t3, cartas_escolhidas
    li   $t0, 0                 # Contador de turnos (0 a 5)
    move $s1, $t3               # Ponteiro J1 (Offset 0)
    addi $s2, $t3, 12           # Ponteiro J2 (Offset 12)

loop_escolha:
    beq  $t0, 6, preparar_save_inicial # Se escolheu 6, acabou

    # Define de quem é a vez para mostrar a mensagem certa
    andi $t4, $t0, 1            # Verifica se $t0 é par ou ímpar
    bne  $t4, 0, msg_j2_print

msg_j1_print:
    li   $v0, 4
    la   $a0, msg_vez_j1
    syscall
    j    ler_input

msg_j2_print:
    li   $v0, 4
    la   $a0, msg_vez_j2
    syscall

ler_input:
    li   $v0, 5                 # Lê Inteiro
    syscall
    move $s3, $v0               # Salva o ID escolhido em $s3 para validar

    # -----------------------------------------------------
    # VALIDAÇÃO 1: O ID EXISTE NO JOGO?
    # -----------------------------------------------------
    la   $t8, cartas_struct     # Início da base de dados
    li   $t9, 0                 # Contador (0 a 9)
    li   $t7, 0                 # Flag de "Encontrei" (0 = não, 1 = sim)

check_existencia:
    beq  $t9, 10, fim_check_exist
    lw   $t6, 0($t8)            # Carrega ID da carta atual da base
    beq  $t6, $s3, id_existe    # Se igual, achamos!
    addi $t8, $t8, 40           # Pula pra próxima carta
    addi $t9, $t9, 1
    j    check_existencia

id_existe:
    li   $t7, 1                 # Marca que achou

fim_check_exist:
    beqz $t7, erro_id_invalido  # Se flag for 0, erro!

    # -----------------------------------------------------
    # VALIDAÇÃO 2: A CARTA JÁ FOI ESCOLHIDA?
    # -----------------------------------------------------
    la   $t8, cartas_escolhidas
    li   $t9, 0                 # Contador (0 a 5 slots)

check_duplicidade:
    beq  $t9, 6, validacao_ok   # Se percorreu tudo e não achou, ok
    
    lw   $t6, 0($t8)            # Carrega ID já escolhido
    beq  $t6, 0, proximo_slot_dup # Se for 0 (vazio), ignora
    beq  $t6, $s3, erro_id_repetido # Se for igual, erro!

proximo_slot_dup:
    addi $t8, $t8, 4            # Próximo slot
    addi $t9, $t9, 1
    j    check_duplicidade

    # -----------------------------------------------------
    # TRATAMENTO DE ERROS
    # -----------------------------------------------------
erro_id_invalido:
    li   $v0, 4
    la   $a0, msg_invalida
    syscall
    j    loop_escolha           # Tenta de novo

erro_id_repetido:
    li   $v0, 4
    la   $a0, msg_repetida
    syscall
    j    loop_escolha           # Tenta de novo

    # -----------------------------------------------------
    # SUCESSO: SALVA E PASSA A VEZ
    # -----------------------------------------------------
validacao_ok:
    andi $t4, $t0, 1
    bne  $t4, 0, salvar_j2

salvar_j1:
    sw   $s3, 0($s1)            # Salva no ponteiro J1
    addi $s1, $s1, 4            # Avança ponteiro J1
    j    proximo_turno_ok

salvar_j2:
    sw   $s3, 0($s2)            # Salva no ponteiro J2
    addi $s2, $s2, 4            # Avança ponteiro J2

proximo_turno_ok:
    addi $t0, $t0, 1            # Incrementa turno
    j    loop_escolha

preparar_save_inicial:
    j    salvar_arquivo_novo

# =========================================================
# OPÇÃO 3: CARREGAR JOGO (Lê resultado_jogo.txt)
# =========================================================
carregar_jogo:
    # 1. Abrir Save
    li   $v0, 13
    la   $a0, nome_saida
    li   $a1, 0
    li   $a2, 0
    syscall
    move $s0, $v0
    blt  $v0, 0, erro_load # Se não existir save, avisa

    # 2. Ler Save no Buffer
    li   $v0, 14
    move $a0, $s0
    la   $a1, buffer_arquivo # Reusamos o buffer
    li   $a2, 2048
    syscall
    
    # 3. Fechar
    li   $v0, 16
    move $a0, $s0
    syscall
    
    # 4. Parsear o Save para 'cartas_em_jogo'
    la   $t0, buffer_arquivo
    la   $t1, cartas_em_jogo # Onde o jogo acontece
    li   $t2, 0              # Vamos ler 6 cartas

loop_parse_save:
    beq  $t2, 6, fim_load

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 0($t1)    # ID

    jal  pular_espacos
    move $a0, $t1
    addi $a0, $a0, 4
    jal  ler_nome       # Nome

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 24($t1)   # Vida

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 28($t1)   # Atk

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 32($t1)   # Def

    jal  pular_espacos
    jal  ler_inteiro
    sw   $v0, 36($t1)   # Elem

    addi $t1, $t1, 40
    addi $t2, $t2, 1
    j    loop_parse_save

fim_load:
    li   $v0, 4
    la   $a0, msg_carregado
    syscall
    
    # Mostra o estado carregado
    la   $t9, cartas_em_jogo
    li   $t2, 0
loop_print_load:
    beq  $t2, 6, logica_batalha
    jal  imprimir_carta_detalhada
    addi $t9, $t9, 40
    addi $t2, $t2, 1
    j    loop_print_load

# =========================================================
# LÓGICA DE SALVAR (CRIA O ARQUIVO INICIAL)
# =========================================================
salvar_arquivo_novo:
    # Abre arquivo para escrita
    li   $v0, 13
    la   $a0, nome_saida
    li   $a1, 1         # Write
    li   $a2, 0
    syscall
    move $s7, $v0
    
    # Percorre IDs escolhidos e busca na cartas_struct
    la   $s0, cartas_escolhidas
    li   $s1, 0

loop_gravar_escolhas:
    beq  $s1, 6, fecha_save_novo
    
    lw   $t0, 0($s0)        # Pega ID escolhido
    
    # Busca esse ID na cartas_struct
    la   $t1, cartas_struct
    li   $t2, 0
busca_id:
    lw   $t3, 0($t1)
    beq  $t3, $t0, achou_id_gravar
    addi $t1, $t1, 40
    addi $t2, $t2, 1
    blt  $t2, 10, busca_id
    j    prox_gravar 

achou_id_gravar:
    # Escreve ID
    lw   $a0, 0($t1)
    jal  escreve_int_file
    jal  escreve_espaco_file
    
    # Escreve Nome
    addi $a0, $t1, 4
    jal  escreve_string_file
    jal  escreve_espaco_file
    
    # Escreve Vida
    lw   $a0, 24($t1)
    jal  escreve_int_file
    jal  escreve_espaco_file
    
    # Escreve Atk
    lw   $a0, 28($t1)
    jal  escreve_int_file
    jal  escreve_espaco_file
    
    # Escreve Def
    lw   $a0, 32($t1)
    jal  escreve_int_file
    jal  escreve_espaco_file
    
    # Escreve Elem
    lw   $a0, 36($t1)
    jal  escreve_int_file
    
    # Newline
    la   $a1, txt_enter
    li   $a2, 1
    li   $v0, 15
    move $a0, $s7
    syscall

prox_gravar:
    addi $s0, $s0, 4
    addi $s1, $s1, 1
    j    loop_gravar_escolhas

fecha_save_novo:
    li   $v0, 16
    move $a0, $s7
    syscall
    
    # Agora carrega o jogo recém criado para a memória de batalha
    j    carregar_jogo 

# =========================================================
# LUGAR PARA A LÓGICA DE BATALHA (FUTURO)
# =========================================================
logica_batalha:
    # Por enquanto volta pro menu
    j    menu_principal 

# =========================================================
# FUNÇÕES DE IMPRESSÃO (CORRIGIDAS)
# =========================================================

imprimir_carta_detalhada:
    # $t9 deve apontar para o inicio da carta
    li   $v0, 4
    la   $a0, lbl_id
    syscall
    
    li   $v0, 1
    lw   $a0, 0($t9)
    syscall
    
    li   $v0, 4
    la   $a0, lbl_nome
    syscall
    
    li   $v0, 4
    addi $a0, $t9, 4
    syscall
    
    li   $v0, 4
    la   $a0, lbl_vida
    syscall
    
    li   $v0, 1
    lw   $a0, 24($t9)
    syscall
    
    li   $v0, 4
    la   $a0, lbl_atk
    syscall
    
    li   $v0, 1
    lw   $a0, 28($t9)
    syscall
    
    li   $v0, 4
    la   $a0, lbl_def
    syscall
    
    li   $v0, 1
    lw   $a0, 32($t9)
    syscall
    
    li   $v0, 4
    la   $a0, lbl_elem
    syscall
    
    li   $v0, 1
    lw   $a0, 36($t9)
    syscall
    
    li   $v0, 4
    la   $a0, txt_enter
    syscall
    jr   $ra

escreve_int_file:
    sub  $sp, $sp, 4
    sw   $ra, 0($sp)
    
    la   $a1, buffer_conv
    jal  int_to_string
    
    move $a2, $v0       
    la   $a1, buffer_conv
    li   $v0, 15
    move $a0, $s7
    syscall
    
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

escreve_string_file:
    move $t8, $a0
    li   $t9, 0
sl_loop:
    lb   $t5, 0($t8)
    beqz $t5, sl_fim
    addi $t8, $t8, 1
    addi $t9, $t9, 1
    j    sl_loop
sl_fim:
    move $a1, $a0
    move $a2, $t9
    li   $v0, 15
    move $a0, $s7
    syscall
    jr   $ra

escreve_espaco_file:
    la   $a1, txt_espaco
    li   $a2, 1
    li   $v0, 15
    move $a0, $s7
    syscall
    jr   $ra

erro_fatal:
    li   $v0, 4
    la   $a0, msg_erro
    syscall
    
    li   $v0, 10
    syscall
    
erro_load:
    li   $v0, 4
    la   $a0, msg_erro
    syscall
    j    menu_principal

fim_programa:
    li   $v0, 10
    syscall

.include "funcoes.asm"