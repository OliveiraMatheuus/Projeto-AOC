from PIL import Image

# CONFIGURAÇÕES
IMAGE_PATH = "Fotos\game_win.png"     # imagem de entrada
OUTPUT_PATH = "game_win.asm"    # arquivo gerado
MAX_WIDTH = 128               # largura máxima do bitmap do MARS
MAX_HEIGHT = 128              # altura máxima do bitmap do MARS

# Abre a imagem
img = Image.open(IMAGE_PATH).convert("RGB")

# Redimensiona se necessário
img = img.resize((MAX_WIDTH, MAX_HEIGHT), Image.NEAREST)

pixels = img.load()

with open(OUTPUT_PATH, "w") as f:
    f.write(".data\n")
    f.write("game_win:\n")

    for y in range(MAX_HEIGHT):
        line_words = []
        for x in range(MAX_WIDTH):
            r, g, b = pixels[x, y]

            # Formato ARGB (AA = 00)
            color = f"0x00{r:02X}{g:02X}{b:02X}"
            line_words.append(color)

        # escreve uma linha inteira de pixels
        f.write("    .word " + ", ".join(line_words) + "\n")

print("Arquivo sprite.asm gerado com sucesso!")
