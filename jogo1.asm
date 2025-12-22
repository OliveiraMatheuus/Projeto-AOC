.include "Macros.asm"

.data

    COR_BORDA:   .word 0x009900FF  # Roxo
    COR_PLAYER:  .word 0x00FFFF00  # Amarelo
    COR_FUNDO:   .word 0x00000000  # Preto
    COR_INIMIGO: .word 0x00FF0000  # Vermelho
    COR_MOEDA:   .word 0x00FFD700  # Dourado 
    
   
    KDMMIO_CTRL: .word 0xffff0000
    KDMMIO_DATA: .word 0xffff0004

    onda_atual:   .word 1              
    max_inimigos: .word 0    
    max_moedas:   .word 0
    vidas:        .word 3        
    moedas_coletadas:   .word 0   
    
    # Controle de Velocidade com Contadores
    frame_delay: .word 40  
    delay_inimigos:     .word 0   
    VELOCIDADE_INIMIGO: .word 6   
    dir_atual: .word 0
    
    .align 2
    inimigos_x:   .space 80       
    inimigos_y:   .space 80
    moedas_x:     .space 80       
    moedas_y:     .space 80       

    msg_gameover: .asciiz "\nGAME OVER! Tente novamente."
    msg_onda:     .asciiz "\n--- INICIANDO ONDA "
    
    item_x:       .word -100   
    item_y:       .word -100   
    item_tipo:    .word 0
    powerup_timer:.word 0     
    
    sprite_player: .word
        0,0,0,0x00FFFF00,0x00FFFF00,0,0,0,
        0,0,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0,0,
        0,0x00FFFF00,0,0,0,0,0x00FFFF00,0,
        0x00FFFF00,0x00FFFF00,0,0,0,0,0x00FFFF00,0x00FFFF00,
        0x00FFFF00,0x00FFFF00,0,0,0,0,0x00FFFF00,0x00FFFF00,
        0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,
        0,0x00FFFF00,0x00FFFF00,0,0,0x00FFFF00,0x00FFFF00,0,
        0,0,0x00FFFF00,0x00FFFF00,0x00FFFF00,0x00FFFF00,0,0

    sprite_inimigo: .word 
        0,0,0,0x00FF0000,0x00FF0000,0,0,0,
        0,0,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0,0,
        0,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0,
        0x00FF0000,0x00FF0000,0xFFFFFFFF,0x00FF0000,0x00FF0000,0xFFFFFFFF,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0x000000FF,0x00FF0000,0x00FF0000,0x000000FF,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0,0,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0,0,0,0,0,0,0x00FF0000

    sprite_moeda: .word 
        0,0,0,0x00FFD700,0x00FFD700,0,0,0,
        0,0,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0,0,
        0,0x00FFD700,0x00FFD700,0,0,0x00FFD700,0x00FFD700,0,
        0x00FFD700,0x00FFD700,0,0x00FFD700,0x00FFD700,0,0x00FFD700,0x00FFD700,
        0x00FFD700,0x00FFD700,0,0x00FFD700,0x00FFD700,0,0x00FFD700,0x00FFD700,
        0,0x00FFD700,0x00FFD700,0,0,0x00FFD700,0x00FFD700,0,
        0,0,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0,0,
        0,0,0,0x00FFD700,0x00FFD700,0,0,0

    sprite_letra_N: .word
        0x00FF0000,0x00FF0000,0,0,0,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0x00FF0000,0,0,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,0,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0x00FF0000,0x00FF0000,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0,0x00FF0000,0x00FF0000,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0,0,0x00FF0000,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0,0,0,0x00FF0000,0x00FF0000,
        0x00FF0000,0x00FF0000,0,0,0,0,0x00FF0000,0x00FF0000

    sprite_letra_S: .word
        0,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0,
        0x00FFD700,0x00FFD700,0,0,0,0,0x00FFD700,0x00FFD700,
        0x00FFD700,0x00FFD700,0,0,0,0,0,0,
        0,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0,0,0,
        0,0,0,0,0x00FFD700,0x00FFD700,0x00FFD700,0,
        0,0,0,0,0,0,0x00FFD700,0x00FFD700,
        0x00FFD700,0x00FFD700,0,0,0,0,0x00FFD700,0x00FFD700,
        0,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0x00FFD700,0
        
    
    sprite_pimenta: .word
        0,0,0,0x0000FF00,0,0,0,0,
        0,0,0,0x00FF0000,0,0,0,0,
        0,0,0x00FF0000,0x00FF0000,0x00FF0000,0,0,0,
        0,0,0x00FF0000,0x00FF0000,0x00FF0000,0,0,0,
        0,0,0,0x00FF0000,0,0,0,0,
        0,0,0,0x00FF0000,0,0,0,0,
        0,0,0,0x00FF0000,0,0,0,0,
        0,0,0,0x0000FF00,0,0,0,0

    sprite_gelo: .word
        0,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0,
        0x0000FFFF,0,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0,0x0000FFFF,
        0x0000FFFF,0x0000FFFF,0,0x0000FFFF,0x0000FFFF,0,0x0000FFFF,0x0000FFFF,
        0x0000FFFF,0x0000FFFF,0x0000FFFF,0,0,0x0000FFFF,0x0000FFFF,0x0000FFFF,
        0x0000FFFF,0x0000FFFF,0x0000FFFF,0,0,0x0000FFFF,0x0000FFFF,0x0000FFFF,
        0x0000FFFF,0x0000FFFF,0,0x0000FFFF,0x0000FFFF,0,0x0000FFFF,0x0000FFFF,
        0x0000FFFF,0,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0,0x0000FFFF,
        0,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0x0000FFFF,0
        
    .include "menu.asm"
    .include "game_over.asm"
    .include "game_win.asm"

.text
    
j MenuPrincipal


MenuPrincipal:
    
    la   $a0, sprite_menu     
    jal  DesenhaTelaCheia

WaitDificuldade:
    
    li   $t0, 0xffff0000   
    
    lw   $t1, 0($t0)
    andi $t1, $t1, 1
    beqz $t1, WaitDificuldade
    
    li   $t2, 0xffff0004   # Endereço dos dados
    lw   $s4, 0($t2)
   
    beq  $s4, 49, SetFacil   
    beq  $s4, 50, SetNormal  
    beq  $s4, 51, SetDificil 
    
    j    WaitDificuldade

SetFacil:
    li   $t0, 3
    sw   $t0, vidas
    li   $t0, 7            # Inimigo Lento
    sw   $t0, VELOCIDADE_INIMIGO
    
    li   $t0, 30          
    sw   $t0, frame_delay    
    
    j    IniciarJogo

SetNormal:
    li   $t0, 2
    sw   $t0, vidas
    li   $t0, 5
    sw   $t0, VELOCIDADE_INIMIGO
    
    li   $t0, 20         
    sw   $t0, frame_delay    
    
    j    IniciarJogo

SetDificil:
    li   $t0, 1
    sw   $t0, vidas
    li   $t0, 3       # Inimigo Rápido
    sw   $t0, VELOCIDADE_INIMIGO
    
    li   $t0, 15            
    sw   $t0, frame_delay    
    
    j    IniciarJogo

IniciarJogo:
    li   $t0, 0x10040000    # Base do Bitmap
    li   $t1, 0             # Contador
    li   $t2, 16384         
    
LoopLimparTela:
    bge  $t1, $t2, FimLimpeza
    sw   $zero, 0($t0)     
    addi $t0, $t0, 4       
    addi $t1, $t1, 1        
    j    LoopLimparTela

FimLimpeza:
    sw   $zero, moedas_coletadas
    sw   $zero, delay_inimigos
    li   $t0, 1
    sw   $t0, onda_atual
    
    j    main

main:
    
    # bitmap
    li $s0, 0x10040000

    # arena
    linha_h 0, 127, 16, COR_BORDA     
    linha_h 0, 127, 127, COR_BORDA   
    linha_v 0, 16, 127, COR_BORDA      
    linha_v 127, 16, 127, COR_BORDA    

    jal AtualizaHUD                    
    
    # posicao jogador
    li $s2, 64   
    li $s3, 64   

    # desenhha jogador
    draw_sprite($s2, $s3, sprite_player)

    jal InicializarOnda


loop_principal:

LoopLeitura:
    
    #Verifica se tem tecla pressionada
    li   $t0, 0xffff0000     
    lw   $t1, 0($t0)         
    andi $t1, $t1, 1
    beqz $t1, ProcessaMovimentoPlayer  

    li   $t2, 0xffff0004    
    lw   $s4, 0($t2)         
    
    beq  $s4, 119, AtualizaDir  # w
    beq  $s4, 115, AtualizaDir  # s
    beq  $s4, 97,  AtualizaDir  # a
    beq  $s4, 100, AtualizaDir  # d

    j    LoopLeitura

AtualizaDir:
    # Salva como nova direção 
    sw   $s4, dir_atual
    j    LoopLeitura

ProcessaMovimentoPlayer:
    
    # Carrega direção atual
    lw   $t5, dir_atual
    beqz $t5, logica_do_jogo
    
    # posição antiga
    move $t8, $s2
    move $t9, $s3

    beq  $t5, 119, auto_w
    beq  $t5, 115, auto_s
    beq  $t5, 97,  auto_a
    beq  $t5, 100, auto_d
    j    logica_do_jogo

auto_w:
   
    ble  $s3, 17, renderiza_player  
    subi $s3, $s3, 1
    j    renderiza_player

auto_s:
    bge  $s3, 119, renderiza_player 
    addi $s3, $s3, 1
    j    renderiza_player

auto_a:
    ble  $s2, 1, renderiza_player
    subi $s2, $s2, 1
    j    renderiza_player

auto_d:
    bge  $s2, 119, renderiza_player
    addi $s2, $s2, 1
    j    renderiza_player

renderiza_player:
    beq  $s2, $t8, checa_y
    j    desenha_agora

checa_y:
    beq  $s3, $t9, logica_do_jogo

desenha_agora:

    # Apaga o rastro 
    erase_sprite($t8, $t9)

    # Desenha 
    draw_sprite($s2, $s3, sprite_player)


logica_do_jogo:

    jal MoverInimigos
    jal RedesenhaMoedas
    jal RedesenhaBordas
    jal VerificarColisao
    jal VerificarColeta
    jal  VerificarColetaItem   
    jal  DesenhaItem           

    lw   $a0, frame_delay      # Carrega velocidade normal
    
    lw   $t0, powerup_timer
    blez $t0, AplicaDelay      # Se timer acabou, velocidade normal
    
    lw   $t1, item_tipo
    bne  $t1, 1, AplicaDelay   
    
    div  $a0, $a0, 2           # Dobra o FPS
    
    # Decrementa timer da pimenta
    subi $t0, $t0, 1
    sw   $t0, powerup_timer

AplicaDelay:
    li   $v0, 32
    syscall
    
    j loop_principal
    

InicializarOnda:
    addi $sp, $sp, -16
    sw   $ra, 12($sp)
    sw   $s1, 8($sp)
    sw   $s5, 4($sp)
    sw   $s6, 0($sp)

    sw   $zero, moedas_coletadas

    # Calcula quantidades baseadas na onda
    lw   $t0, onda_atual
    mul  $s6, $t0, 2      
    sw   $s6, max_moedas
    addi $s5, $t0, 1      
    sw   $s5, max_inimigos

    li   $s1, 0           
LoopCriarInimigos:
    bge  $s1, $s5, PrepMoedas 
    
TentarPosicaoInimigo:
    gera_aleatorio $t2, 116, 2   
    gera_aleatorio $t3, 100, 18 
    
    sub  $t8, $t2, 64
    abs  $t8, $t8
    blt  $t8, 25, TentarPosicaoInimigo  

    sub  $t8, $t3, 64
    abs  $t8, $t8
    blt  $t8, 25, TentarPosicaoInimigo  

    mul  $t4, $s1, 4      
    sw   $t2, inimigos_x($t4) 
    sw   $t3, inimigos_y($t4) 
    
    move $a0, $t2
    move $a1, $t3
    la   $a2, sprite_inimigo
    jal  DesenhaSprite
    
    addi $s1, $s1, 1
    j    LoopCriarInimigos

PrepMoedas:
    li   $s1, 0
LoopCriarMoedas:
    bge  $s1, $s6, GerarItemExtra
 
    # Moedas não precisam de zona de segurança
    gera_aleatorio $t2, 116, 2   
    gera_aleatorio $t3, 100, 18  
    
    mul  $t4, $s1, 4
    sw   $t2, moedas_x($t4)
    sw   $t3, moedas_y($t4)
    
    move $a0, $t2
    move $a1, $t3
    la   $a2, sprite_moeda
    jal  DesenhaSprite
    
    addi $s1, $s1, 1
    j    LoopCriarMoedas


GerarItemExtra:

    gera_aleatorio $t2, 110, 10   # X
    gera_aleatorio $t3, 110, 10   # Y
    
    sw   $t2, item_x
    sw   $t3, item_y
    
    li   $a0, 0         
    li   $v0, 42         
    li   $a1, 2           # Limite 0 ou 1
    syscall
    
    addi $a0, $a0, 1      # Resultado vira 1 ou 2
    sw   $a0, item_tipo   # Salva o tipo
    
    sw   $zero, powerup_timer  # Reseta timer

FimInitOnda:
    lw   $s6, 0($sp)
    lw   $s5, 4($sp)
    lw   $s1, 8($sp)
    lw   $ra, 12($sp)
    addi $sp, $sp, 16
    jr   $ra

MoverInimigos:
    lw   $t0, powerup_timer
    blez $t0, ContinuaInimigos  
    
    lw   $t1, item_tipo
    bne  $t1, 2, ContinuaInimigos 
    
    subi $t0, $t0, 1
    sw   $t0, powerup_timer
    jr   $ra

ContinuaInimigos:
    # Controle de Velocidade 
    lw   $t0, delay_inimigos
    addi $t0, $t0, 1
    sw   $t0, delay_inimigos
    
    lw   $t1, VELOCIDADE_INIMIGO
    blt  $t0, $t1, SaiMoverInimigos
    
    sw   $zero, delay_inimigos

    addi $sp, $sp, -24     
    sw   $ra, 20($sp)
    sw   $s0, 16($sp)      
    sw   $s1, 12($sp)       
    sw   $s5, 8($sp)        
    sw   $s6, 4($sp)        
    sw   $s7, 0($sp)        
    
    li   $s0, 0x10040000 

    li   $s1, 0             
    lw   $s5, max_inimigos  

LoopInimigos:
    bge  $s1, $s5, FimLoopInimigos

    mul  $t0, $s1, 4        
    lw   $t1, inimigos_x($t0)
    lw   $t2, inimigos_y($t0) 
    
    # Backup 
    move $s6, $t1  
    move $s7, $t2

   # Apaga inimigo
    erase_sprite($t1, $t2)  

    move $t1, $s6
    move $t2, $s7

    blt  $t1, $s2, TentaDir
    bgt  $t1, $s2, TentaEsq

    j    ChecaY             

TentaDir:
    bge  $t1, 118, ChecaY  
    addi $t1, $t1, 1       
    j    ChecaY
TentaEsq:
    ble  $t1, 2, ChecaY    
    subi $t1, $t1, 1       

ChecaY:
    blt  $t2, $s3, TentaBaixo
    bgt  $t2, $s3, TentaCima
    j    VerificaSobreposicao 

TentaBaixo:
    bge  $t2, 118, VerificaSobreposicao 
    addi $t2, $t2, 1       
    j    VerificaSobreposicao
TentaCima:
    ble  $t2, 18, VerificaSobreposicao  
    subi $t2, $t2, 1       

VerificaSobreposicao:
    # Se a posição não mudou nem precisa checar
    beq  $t1, $s6, CheckYChange
    j    StartCheck
CheckYChange:
    beq  $t2, $s7, SalvaPosicao # Não mudou nada pode desenhar direto

StartCheck:
    li   $t8, 0             
    lw   $t9, max_inimigos  

LoopCheckColisao:
    bge  $t8, $t9, SalvaPosicao 

    # Ignora a si mesmo
    beq  $t8, $s1, ProxCheck

    mul  $t3, $t8, 4        
    lw   $t4, inimigos_x($t3) # X inimigo
    lw   $t5, inimigos_y($t3) # Y inimigo
    
    # posição antiga (s6,s7) ,(t4,t5) posicao do outro
    sub  $t6, $s6, $t4      
    abs  $t6, $t6
    bge  $t6, 8, ChecaNovaColisao 
    
    sub  $t6, $s7, $t5      
    abs  $t6, $t6
    bge  $t6, 8, ChecaNovaColisao 
    
    j    ProxCheck 

ChecaNovaColisao:

    sub  $t6, $t1, $t4      
    abs  $t6, $t6
    bge  $t6, 8, ProxCheck  # Longe no X

    sub  $t6, $t2, $t5      
    abs  $t6, $t6
    bge  $t6, 8, ProxCheck  # Longe no Y 

    # ele estava livre e tentou entrar em alguém
    move $t1, $s6
    move $t2, $s7
    j    SalvaPosicao       

ProxCheck:
    addi $t8, $t8, 1
    j    LoopCheckColisao
    
SalvaPosicao:

    mul  $t0, $s1, 4        
    
    sw   $t1, inimigos_x($t0)
    sw   $t2, inimigos_y($t0)
    
    # Desenha na Tela
    move $a0, $t1
    move $a1, $t2
    la   $a2, sprite_inimigo
    jal  DesenhaSprite

    # Próximo Inimigo
    addi $s1, $s1, 1
    j    LoopInimigos

FimLoopInimigos:
    lw   $s7, 0($sp)
    lw   $s6, 4($sp)
    lw   $s5, 8($sp)
    lw   $s1, 12($sp)
    lw   $s0, 16($sp)
    lw   $ra, 20($sp)
    addi $sp, $sp, 24
    
SaiMoverInimigos:
    jr   $ra
VerificarColisao:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    
    li   $t0, 0             
    lw   $t1, max_inimigos  

LoopColisao:
    bge  $t0, $t1, SaiColisao 

    # Pega X do Inimigo
    mul  $t2, $t0, 4       
    lw   $t3, inimigos_x($t2)
    
    # distancia x
    sub  $t5, $t3, $s2      
    abs  $t5, $t5           
    bge  $t5, 7, ProximoCheque 

    # so vai checar y se x estiver perto
    lw   $t4, inimigos_y($t2)
    
    # distancia y
    sub  $t5, $t4, $s3     
    abs  $t5, $t5
    bge  $t5, 7, ProximoCheque 

    # colisão
    jal  TratarColisao      
    
    # evitar bugs
    j    SaiColisao         

ProximoCheque:
    addi $t0, $t0, 1
    j    LoopColisao

SaiColisao:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

TratarColisao:

    jal  TocarSomDano

    lw   $t0, vidas
    subi $t0, $t0, 1
    sw   $t0, vidas
    
    # Debug e Game Over
    li   $v0, 1
    move $a0, $t0 #remover
    syscall
    blez $t0, GameOver
    
    jal  LimparTela       
    
    linha_h 0, 127, 16, COR_BORDA      
    linha_h 0, 127, 127, COR_BORDA   
    linha_v 0, 16, 127, COR_BORDA      
    linha_v 127, 16, 127, COR_BORDA    

    jal AtualizaHUD                    
    
    li   $s2, 64
    li   $s3, 64
    
    draw_sprite($s2, $s3, sprite_player)

    sw   $zero, dir_atual   
    
    jal  InicializarOnda  
    delay_ms 1000
    j  loop_principal

GameOver:

    play_midi(60, 150, 0, 127)
    play_midi(56, 150, 0, 127)
    play_midi(53, 150, 0, 127)
    play_midi(48, 150, 0, 127)

    la   $a0, sprite_gameover  
    jal  DesenhaTelaCheia

WaitRestart:
    lw   $t0, KDMMIO_CTRL
    lw   $t1, 0($t0)
    andi $t1, $t1, 1
    beqz $t1, WaitRestart

    lw   $t2, KDMMIO_DATA
    lw   $s4, 0($t2)
    
    beq  $s4, 114, ResetTotal  # 'r' para Reiniciar
    beq  $s4, 82,  ResetTotal  # 'R' maiúsculo
    beq  $s4, 101, SaiDoJogo   # 'e' para Exit
    j    WaitRestart

ResetTotal:
    j    MenuPrincipal   

SaiDoJogo:
    li   $v0, 10
    syscall

LimparTela:

    li   $t0, 0            
    li   $t1, 16384         # 128x128 pixels 
    lw   $t2, COR_FUNDO
    
LoopLimpa:
    
    beq  $t0, $t1, SaiLimpa
    
    sll  $t3, $t0, 2        # Offset 
    add  $t3, $t3, $s0     
    sw   $t2, 0($t3)
    
    addi $t0, $t0, 1
    j    LoopLimpa
SaiLimpa:
    jr   $ra
    
VerificarColeta:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    li   $t0, 0        
    lw   $t1, max_moedas    # Limite

LoopColeta:

    bge  $t0, $t1, ChecarFimOnda 

    mul  $t2, $t0, 4
    lw   $t3, moedas_x($t2)
    
    beq  $t3, -100, ProximaMoeda
    
    # x
    sub  $t5, $t3, $s2        
    abs  $t5, $t5             
    bgt  $t5, 8, ProximaMoeda 

    # y
    lw   $t4, moedas_y($t2)      

    sub  $t5, $t4, $s3        
    abs  $t5, $t5             
    bgt  $t5, 8, ProximaMoeda 

    #se chegou aqui ele pode coletar a moeda

    erase_sprite($t3, $t4)   
    
    mul  $t2, $t0, 4       
    
    li   $t5, -100
    sw   $t5, moedas_x($t2) 
    
    # Incrementa Contador
    lw   $t6, moedas_coletadas
    addi $t6, $t6, 1
    sw   $t6, moedas_coletadas

    jal  TocarSomMoeda

ProximaMoeda:
    addi $t0, $t0, 1
    j    LoopColeta


ChecarFimOnda:

    lw   $t0, moedas_coletadas
    lw   $t1, max_moedas
    blt  $t0, $t1, SaiVerificarColeta
    
    lw   $t2, onda_atual
    addi $t2, $t2, 1
    sw   $t2, onda_atual
    bgt  $t2, 5, TelaVitoria
    
    jal  LimparTela
    jal  RedesenhaBordas 
    jal  AtualizaHUD    
    
    li   $s2, 64
    li   $s3, 64

    draw_sprite($s2, $s3, sprite_player)

    sw   $zero, dir_atual
    jal  InicializarOnda
    delay_ms 1000

SaiVerificarColeta:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

TelaVitoria:
   
    play_midi(60, 150, 0, 127)  
    play_midi(64, 150, 0, 127)  
    play_midi(67, 150, 0, 127)  
    play_midi(72, 800, 0, 127)  

    la   $a0, sprite_gamewin    
    jal  DesenhaTelaCheia

WaitInputVitoria:

    li   $t0, 0xffff0000     
    lw   $t1, 0($t0)
    andi $t1, $t1, 1          
    beqz $t1, WaitInputVitoria 

    li   $t2, 0xffff0004
    lw   $zero, 0($t2)
    
    sw   $zero, moedas_coletadas
    li   $t0, 1
    sw   $t0, onda_atual
    
    j   MenuPrincipal


AtualizaHUD:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    lw   $t0, vidas
    li   $t1, 0x0000FF00  # Verde
    lw   $t2, COR_FUNDO

    # Vida 1
    bge  $t0, 1, CorV1
    move $a2, $t2 
    j    DrawV1
CorV1: move $a2, $t1
DrawV1:

    li   $a0,10
    li   $a1, 5
    jal  DesenhaBlocoHUD

    # Vida 2
    bge  $t0, 2, CorV2
    move $a2, $t2
    j    DrawV2
CorV2: move $a2, $t1
DrawV2:
    li   $a0, 20
    li   $a1, 5
    jal  DesenhaBlocoHUD

    # Vida 3
    bge  $t0, 3, CorV3
    move $a2, $t2
    j    DrawV3
CorV3: move $a2, $t1
DrawV3:
    li   $a0, 30
    li   $a1, 5
    jal  DesenhaBlocoHUD
    
    # Desenha Letra N em X=50, Y=4
    li   $a0, 50      
    li   $a1, 4       
    la   $a2, sprite_letra_N
    jal  DesenhaSprite

    # Desenha Letra S em X=59, Y=4 (9 pixels ao lado)
    li   $a0, 59      
    li   $a1, 4       
    la   $a2, sprite_letra_S
    jal  DesenhaSprite

    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

DesenhaBlocoHUD:

    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s6, 4($sp)  
    sw   $s7, 0($sp) 
    
    move $s6, $a0    
    move $s7, $a1     
    
    li   $t6, 0       
LoopBlocoY:
    bge  $t6, 4, FimBloco
    li   $t7, 0      
LoopBlocoX:
    bge  $t7, 4, ProxLinhaBloco
    
    add  $a0, $s6, $t7
    add  $a1, $s7, $t6
   
    jal  desenha_pixel
    
    addi $t7, $t7, 1
    j    LoopBlocoX
ProxLinhaBloco:
    addi $t6, $t6, 1
    j    LoopBlocoY
FimBloco:
    lw   $s7, 0($sp)
    lw   $s6, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra


DesenhaSprite:
    # Salva contexto na pilha
    addi $sp, $sp, -24
    sw   $ra, 0($sp)
    sw   $s0, 4($sp)
    sw   $s1, 8($sp)
    sw   $s2, 12($sp)
    sw   $s3, 16($sp)
    sw   $s4, 20($sp)

    move $s0, $a0        
    move $s1, $a2        
    move $s2, $a1        
    
    li   $t6, 0          # Contador Linha 

LoopSpriteY:
    bge  $t6, 8, FimSprite
    li   $t7, 0          # Contador Coluna 
    
LoopSpriteX:
    bge  $t7, 8, ProxLinhaSprite
    
    lw   $t8, 0($s1)     # Carrega cor do pixel
    addi $s1, $s1, 4    
    
    beqz $t8, PulaPixel  # Se for preto, pula
    
    add  $t9, $s2, $t6   
    mul  $t9, $t9, 128   
    add  $t5, $s0, $t7   
    add  $t9, $t9, $t5   
    sll  $t9, $t9, 2     
    
    li   $t4, 0x10040000 
    add  $t9, $t9, $t4   
    
    sw   $t8, 0($t9)     

PulaPixel:
    addi $t7, $t7, 1
    j    LoopSpriteX

ProxLinhaSprite:
    addi $t6, $t6, 1
    j    LoopSpriteY

FimSprite:
    # Restaura contexto
    lw   $ra, 0($sp)
    lw   $s0, 4($sp)
    lw   $s1, 8($sp)
    lw   $s2, 12($sp)
    lw   $s3, 16($sp)
    lw   $s4, 20($sp)
    addi $sp, $sp, 24
    jr   $ra

ApagaSprite:
    addi $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    
    li   $s0, 0x10040000 
    move $t2, $a0  # X original
    move $t3, $a1  # Y original
    li   $t6, 0    # Y offset
    
ApagaLoopY:
    bge  $t6, 8, FimApaga
    li   $t7, 0    # X offset
ApagaLoopX:
    bge  $t7, 8, ProxApagaY
    
    # Calcula endereço
    add  $t8, $t3, $t6    # Y atual
    mul  $t8, $t8, 128
    add  $t9, $t2, $t7    # X atual
    add  $t8, $t8, $t9
    sll  $t8, $t8, 2
    add  $t8, $t8, $s0
    
    sw   $zero, 0($t8)    # Pinta Preto (0)
    
    addi $t7, $t7, 1
    j    ApagaLoopX
ProxApagaY:
    addi $t6, $t6, 1
    j    ApagaLoopY
FimApaga:
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12
    jr   $ra

RedesenhaMoedas:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    li   $t0, 0             # i = 0
    lw   $t1, max_moedas    # Limite

LoopRedesenha:
    bge  $t0, $t1, FimRedesenha
    
    # Pega X da Moeda
    mul  $t2, $t0, 4
    lw   $t3, moedas_x($t2)
    
    # Se X == -100, já foi coletada. Não desenha.
    beq  $t3, -100, ProxRedesenha
    
    lw   $t4, moedas_y($t2)
    
    move $a0, $t3
    move $a1, $t4
    la   $a2, sprite_moeda
    jal  DesenhaSprite      

ProxRedesenha:
    addi $t0, $t0, 1
    j    LoopRedesenha

FimRedesenha:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

desenha_pixel:

    mul  $t9, $a1, 128    
    add  $t9, $t9, $a0     
    sll  $t9, $t9, 2       
    add  $t9, $t9, $s0     
    sw   $a2, 0($t9)       
    jr   $ra

TocarSomMoeda:
    # Nota 79, Duração 100ms, Instrumento 0, Volume 127
    play_midi(79, 100, 0, 127)
    jr   $ra

TocarSomDano:
    # Nota 45, Duração 300ms, Instrumento 33 (Baixo), Volume 127
    play_midi(45, 300, 33, 127)
    jr   $ra

TocarSomGameOver:
    # Toca Diminuindo o tom
    play_midi(60, 150, 0, 127)
    play_midi(56, 150, 0, 127)
    play_midi(53, 150, 0, 127)
    play_midi(48, 150, 0, 127)
    
    jr   $ra

RedesenhaBordas:
    
    addi $sp, $sp, -4
    sw   $ra, 0($sp)

    linha_h 0, 127, 16, COR_BORDA      
    linha_h 0, 127, 127, COR_BORDA   
    linha_v 0, 16, 127, COR_BORDA     
    linha_v 127, 16, 127, COR_BORDA  
    
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra


DesenhaTelaCheia:
    li   $t0, 0x10040000  
    li   $t1, 0           
    li   $t2, 16384       # 128 * 128 = 16.384

LoopTelaCheia:
    bge  $t1, $t2, FimTelaCheia
    
    lw   $t3, 0($a0)      
    sw   $t3, 0($t0)      
    
    addi $a0, $a0, 4      
    addi $t0, $t0, 4      
    addi $t1, $t1, 1      
    j    LoopTelaCheia

FimTelaCheia:
    jr   $ra


VerificarColetaItem:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    
    lw   $t0, item_x
    beq  $t0, -100, FimVerificaItem  # Se -100, item não existe
    
    # Verifica Colisão X
    sub  $t5, $t0, $s2
    abs  $t5, $t5
    bgt  $t5, 8, FimVerificaItem
    
    # Verifica Colisão Y
    lw   $t1, item_y
    sub  $t5, $t1, $s3
    abs  $t5, $t5
    bgt  $t5, 8, FimVerificaItem
    
    play_midi(85, 200, 80, 127) # Som de PowerUp
    
    li   $t0, 60               # Duração do efeito (aprox. 5 segundos)
    sw   $t0, powerup_timer
    
    # Apaga o item da tela
    lw   $a0, item_x
    lw   $a1, item_y
    jal  ApagaSprite
    
    # Desativa o item (Joga para -100)
    li   $t0, -100
    sw   $t0, item_x

FimVerificaItem:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra


# --- DESENHA O POWER-UP ---
DesenhaItem:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    
    lw   $t0, item_x
    beq  $t0, -100, FimDesenhaItem
    
    move $a0, $t0
    lw   $a1, item_y
    
    lw   $t2, item_tipo
    beq  $t2, 1, UsaPimenta
    
    la   $a2, sprite_gelo    # Tipo 2 = Gelo
    j    DoDesenho
    
UsaPimenta:
    la   $a2, sprite_pimenta # Tipo 1 = Pimenta

DoDesenho:
    jal  DesenhaSprite

FimDesenhaItem:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra
