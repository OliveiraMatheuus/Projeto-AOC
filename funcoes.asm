# --- ARQUIVO DE FUNÇÕES AUXILIARES ---

# --- Pular Espaços ---
pular_espacos:
    lb   $t3, 0($t0)
    beq  $t3, 32, pular
    beq  $t3, 13, pular
    beq  $t3, 10, pular
    jr   $ra
pular:
    addi $t0, $t0, 1
    j    pular_espacos

# --- Ler Inteiro ---
ler_inteiro:
    li   $v0, 0
atoi_loop:
    lb   $t3, 0($t0)
    blt  $t3, 48, atoi_fim
    bgt  $t3, 57, atoi_fim
    sub  $t3, $t3, 48
    mul  $v0, $v0, 10
    add  $v0, $v0, $t3
    addi $t0, $t0, 1
    j    atoi_loop
atoi_fim:
    jr   $ra

# --- Ler Nome ---
ler_nome:
    move $t4, $a0
nome_loop:
    lb   $t3, 0($t0)
    beq  $t3, 32, nome_fim
    beq  $t3, 13, nome_fim
    beq  $t3, 10, nome_fim
    sb   $t3, 0($t4)
    addi $t0, $t0, 1
    addi $t4, $t4, 1
    j    nome_loop
nome_fim:
    sb   $zero, 0($t4)
    jr   $ra
    
# --- Função: Converter Inteiro para String (com \n) ---
# Entrada: $a0 = Inteiro para converter
# Entrada: $a1 = Endereço do buffer onde salvar
# Saída:   $v0 = Tamanho da string gerada
int_to_string:
    move $t3, $a0           # Copia o número para $t3
    move $t4, $a1           # Copia o endereço do buffer para $t4
    
    # Caso especial: Se o número for 0
    bne  $t3, 0, its_loop
    li   $t5, 48            # ASCII '0'
    sb   $t5, 0($t4)
    addi $t4, $t4, 1
    j    its_fim

its_loop:
    # Empilha os dígitos (porque a divisão gera eles ao contrário)
    li   $t6, 0             # Contador de dígitos
    li   $t7, 10            # Divisor

push_digits:
    blez $t3, pop_digits    # Se número acabou, desempilha
    div  $t3, $t7           # Divide por 10
    mfhi $t8                # Pega o resto (o dígito atual)
    mflo $t3                # Atualiza o número (quociente)
    
    addi $t8, $t8, 48       # Converte int (0-9) para ASCII ('0'-'9')
    sub  $sp, $sp, 1        # Abre espaço na pilha
    sb   $t8, 0($sp)        # Salva dígito na pilha
    addi $t6, $t6, 1        # Conta +1 dígito
    j    push_digits

pop_digits:
    # Tira da pilha e coloca no buffer na ordem certa
    lb   $t8, 0($sp)        # Lê da pilha
    addi $sp, $sp, 1        # Fecha espaço na pilha
    sb   $t8, 0($t4)        # Grava no buffer
    addi $t4, $t4, 1        # Avança buffer
    sub  $t6, $t6, 1        # Decrementa contador
    bgtz $t6, pop_digits

its_fim:

    # O código principal é quem decide quando pular linha.
    
    # Calcula tamanho total (Final - Inicial)
    sub  $v0, $t4, $a1      
    jr   $ra

