
.macro draw_sprite(%x_reg, %y_reg, %sprite_label)
    move $a0, %x_reg
    move $a1, %y_reg
    la   $a2, %sprite_label
    jal  DesenhaSprite
.end_macro

.macro erase_sprite(%x_reg, %y_reg)
    move $a0, %x_reg
    move $a1, %y_reg
    jal  ApagaSprite
.end_macro

.macro linha_v %x, %y_ini, %y_fim, %cor_mem
    li $a0, %x       
    li $t5, %y_ini   
    lw $a2, %cor_mem 
    
    subi $sp, $sp, 4
    sw   $ra, 0($sp)
    
loop_lv:
    bgt  $t5, %y_fim, fim_lv
    move $a1, $t5
    jal  desenha_pixel
    addi $t5, $t5, 1
    j    loop_lv
    
fim_lv:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
.end_macro

.macro linha_h %x_ini, %x_fim, %y, %cor_mem
    li   $a1, %y      
    li   $t5, %x_ini   
    lw   $a2, %cor_mem 
    
    subi $sp, $sp, 4
    sw   $ra, 0($sp)
    
loop_lh:
    bgt  $t5, %x_fim, fim_lh
    move $a0, $t5
    jal  desenha_pixel
    addi $t5, $t5, 1
    j    loop_lh
    
fim_lh:
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
.end_macro


.macro gera_aleatorio %reg_dest, %range, %min
    li   $v0, 42            
    li   $a0, 0             
    li   $a1, %range           
    syscall
    addi %reg_dest, $a0, %min  
.end_macro

.macro delay_ms %tempo
    li   $v0, 32
    li   $a0, %tempo
    syscall
.end_macro

.macro play_midi(%pitch, %dur, %instr, %vol)
    li   $v0, 31
    li   $a0, %pitch      
    li   $a1, %dur        
    li   $a2, %instr      
    li   $a3, %vol        
    syscall
.end_macro
