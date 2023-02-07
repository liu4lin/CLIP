import torch
import clip
import time
from PIL import Image

device = "cuda" if torch.cuda.is_available() else "cpu"

start = time.time()
model, preprocess = clip.load("ViT-B/32", device=device, download_root='./')

image = preprocess(Image.open("CLIP.png")).unsqueeze(0).to(device)
text = clip.tokenize(["a diagram", "a dog", "a cat"]).to(device)

with torch.no_grad():
    image_features = model.encode_image(image)
    text_features = model.encode_text(text)
    
    logits_per_image, logits_per_text = model(image, text)
    probs = logits_per_image.softmax(dim=-1).cpu().numpy()
end = time.time()

print("Label probs:", probs, "by", device)  # prints: [[0.9927937  0.00421068 0.00299572]]
print("Elapsed time:", end - start)