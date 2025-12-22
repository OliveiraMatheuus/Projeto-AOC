# 🎮 Jogo 2D em Assembly MIPS

![Language](https://img.shields.io/badge/Language-Assembly%20MIPS-blue)
![Simulator](https://img.shields.io/badge/Simulator-MARS%204.5-orange)
![University](https://img.shields.io/badge/University-UNIFESP-green)

Este projeto consiste em um jogo 2D desenvolvido inteiramente em **Assembly MIPS**, executado no simulador **MARS**. O jogo utiliza renderização via Bitmap Display, sprites 8x8, sistema de ondas, física de colisão e reprodução de áudio via MIDI.

---

## 🎓 Contexto Acadêmico

Este jogo foi desenvolvido como **projeto final** da Unidade Curricular de **Arquitetura e Organização de Computadores**, com o objetivo de aplicar na prática conceitos de manipulação de memória, registradores, fluxo de controle e chamadas de sistema (syscalls).

- **Instituição:** Universidade Federal de São Paulo (UNIFESP) – Campus São José dos Campos
- **Curso:** Bacharelado em Ciência e Tecnologia / Engenharia da Computação
- **Docente:** Prof. Fabio Cappabianco
- **Autor:** Matheus Oliveira

---

## 🛠️ Requisitos

Para executar o projeto, você precisará de:

1.  **Java Runtime Environment (JRE)** instalado.
2.  **MARS MIPS Simulator**: [Download aqui](https://courses.missouristate.edu/KenVollmar/mars/).

---

## ⚙️ Configuração Obrigatória (Bitmap Display)

⚠️ **IMPORTANTE:** Para que os gráficos apareçam corretamente, a ferramenta **Bitmap Display** do MARS deve ser configurada **exatamente** com os valores abaixo:

| Configuração | Valor |
| :--- | :--- |
| **Unit Width** | 4 pixels |
| **Unit Height** | 4 pixels |
| **Display Width** | 512 pixels |
| **Display Height** | 512 pixels |
| **Base Address** | **0x10040000 (Heap)** |

---

## ▶️ Como Executar

1. Abra o **MARS 4.5**.
2. Vá em `File` -> `Open` e selecione o arquivo **`jogo1.asm`**.
   > *Certifique-se de que os arquivos `Macros.asm`, `menu.asm`, `game_over.asm` e `game_win.asm` estejam na mesma pasta.*
3. Vá em `Tools` -> `Bitmap Display`.
4. Aplique as configurações listadas na tabela acima.
5. No Bitmap Display, clique em **Connect to MIPS**.
6. No editor do MARS, clique em **Assemble** (ícone de chave de fenda e chave inglesa) ou pressione `F3`.
7. Clique em **Run** (ícone de play) ou pressione `F5`.

---

## ⌨️ Controles e Objetivos

Utilize o teclado para controlar o personagem:

- **`W`**: Mover para Cima
- **`S`**: Mover para Baixo
- **`A`**: Mover para Esquerda
- **`D`**: Mover para Direita

### 🎯 Objetivo
1. **Sobreviver:** Desvie dos inimigos que aparecem em ondas.
2. **Coletar:** Pegue as moedas para aumentar sua pontuação.
3. **Vencer:** Complete todas as ondas para ver a tela de vitória.

---

## 📂 Estrutura do Projeto

O código foi modularizado para facilitar a manutenção e leitura:

- **`jogo1.asm`**: **Arquivo Principal.** Contém o loop do jogo , inicialização de variáveis, controle de estados, física de colisão e lógica das ondas.
- **`Macros.asm`**: Biblioteca de macros para abstrair operações complexas (desenho de pixels, delay, geração de números aleatórios e som).
- **`menu.asm`**:  Dados gráficos da Tela Inicial.
- **`game_over.asm`**; Dados gráficos da Tela de Derrota.
- **`game_win.asm`**: Dados gráficos da Tela de Vitória.

---

## 🎨 Detalhes Técnicos

- **Gráficos:** Renderização direta na memória Heap. Sprites desenhados pixel a pixel (formato 8x8). Cores em hexadecimal (ARGB).
- **Áudio:** Uso de Syscall MIDI (31 e 33) para efeitos sonoros síncronos e assíncronos.
- **Colisão:** Detecção baseada em coordenadas (Bounding Box simples).
- **Otimização:** Uso de macros para reduzir repetição de código e facilitar a leitura do Assembly.

---

## 📝 Licença

Este projeto foi desenvolvido para fins educacionais. Sinta-se à vontade para estudar o código.
