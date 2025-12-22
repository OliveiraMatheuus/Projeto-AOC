from PIL import Image

# CONFIGURAÇÕES
IMAGE_PATH = "Fotos\game_over.png"     
OUTPUT_PATH = "game_over.asm"    
MAX_WIDTH = 128               
MAX_HEIGHT = 128              

# Abre a imagem
img = Image.open(IMAGE_PATH).convert("RGB")

# Redimensiona 
img = img.resize((MAX_WIDTH, MAX_HEIGHT), Image.NEAREST)

pixels = img.load()

with open(OUTPUT_PATH, "w") as f:
    f.write(".data\n")
    f.write("sprite_gameover:\n")

    for y in range(MAX_HEIGHT):
        line_words = []
        for x in range(MAX_WIDTH):
            r, g, b = pixels[x, y]

            color = f"0x00{r:02X}{g:02X}{b:02X}"
            line_words.append(color)

        f.write("    .word " + ", ".join(line_words) + "\n")

