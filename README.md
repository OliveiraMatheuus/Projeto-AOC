🎮 Jogo em Assembly MIPS – MARS

Este projeto consiste em um jogo 2D desenvolvido em Assembly MIPS, executado no simulador MARS, utilizando sprites 8x8, controle por teclado, sistema de ondas, inimigos, moedas, vidas e telas de menu, game over e vitória.

🎓 Contexto Acadêmico

Este jogo foi desenvolvido como projeto final da Unidade Curricular (UC) Arquitetura e Organização de Computadores, com o objetivo de aplicar, na prática, os conceitos estudados ao longo da disciplina.

O projeto foi desenvolvido sob orientação do professor Fabio Cappabianco, docente da Universidade Federal de São Paulo (UNIFESP) – campus São José dos Campos.

🛠️ Requisitos

Para executar o projeto, é necessário:

MARS MIPS Simulator
[https://courses.missouristate.edu/KenVollmar/mars/](https://dpetersanderson.github.io/)

Java instalado

Sistema operacional Windows, Linux ou macOS

▶️ Como executar o projeto

Abra o MARS

Clique em File → Open

Abra o arquivo principal:

jogo1.asm

Certifique-se de que os arquivos Macros.asm, menu.asm, game_over.asm e game_win.asm estejam na mesma pasta

Clique em Assemble

Execute o programa clicando em Run

🖥️ Configuração do Bitmap Display (Obrigatória)

O jogo utiliza o Bitmap Display do MARS para renderização gráfica.
As configurações devem ser exatamente as seguintes:

Unit Width (Pixels): 4

Unit Height (Pixels): 4

Display Width (Pixels): 512

Display Height (Pixels): 512

Base Address: Heap (0x10040000)

Como configurar

No MARS, vá em Tools → Bitmap Display

Configure os valores acima

Clique em Connect to MIPS

Execute o jogo normalmente


⌨️ Controles

Teclas w,a,s,d do teclado para movimentação do jogador

O objetivo do jogador é:

Desviar dos inimigos

Coletar moedas

Sobreviver às ondas

🧩 Estrutura do Projeto
📁 Projeto
 ├── jogo1.asm        # Arquivo principal do jogo
 ├── Macros.asm       # Macros auxiliares (sprites, delay, som, etc.)
 ├── menu.asm         # Tela de menu inicial
 ├── game_over.asm    # Tela de Game Over
 └── game_win.asm     # Tela de vitória

⚙️ Funcionamento do Código
🔹 jogo1.asm

Arquivo principal responsável por:

Inicialização das variáveis globais

Loop principal do jogo

Controle do jogador

Geração e movimentação de inimigos

Geração e coleta de moedas

Sistema de ondas

Controle de vidas

Detecção de colisões

Transição entre estados do jogo (menu, jogo, vitória e derrota)

🔹 Macros.asm

Contém macros que abstraem operações repetitivas, como:

Desenho e remoção de sprites 8x8

Desenho de linhas (bordas)

Geração de valores aleatórios

Controle de FPS (delay_ms)

Execução de sons MIDI (play_midi)

Essas macros tornam o código mais organizado e legível.

🔹 menu.asm

Responsável por exibir a tela inicial do jogo e aguardar a interação do jogador para iniciar a partida.

🔹 game_over.asm

Contém os dados e rotinas necessárias para exibir a tela de Game Over quando o jogador perde todas as vidas.

🔹 game_win.asm

Responsável por exibir a tela de Vitória quando o jogador conclui o jogo com sucesso.

🎨 Gráficos

O jogo utiliza sprites 8x8

As cores são definidas no formato ARGB

A renderização é feita diretamente na memória de vídeo simulada do MARS (Heap)

🔊 Áudio

O jogo utiliza o syscall MIDI do MARS para reprodução de sons durante a execução, enriquecendo a experiência do jogador.
