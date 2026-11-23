"""Generate the blue shell icon with uncompressed ICO frames usable on XP."""
from pathlib import Path
import struct
from PIL import Image, ImageDraw


def make_icon(path):
    image = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((16, 28, 240, 228), radius=28, fill="#1262be")
    draw.rounded_rectangle((24, 36, 232, 220), radius=22, fill="#1976d2")
    draw.line((26, 76, 230, 76), fill="#80bdff", width=4)
    for x in (44, 64, 84):
        draw.ellipse((x-4, 52, x+4, 60), fill="#d7edff")
    draw.line((62, 110, 99, 143, 62, 176), fill="white", width=14, joint="curve")
    draw.line((124, 177, 184, 177), fill="white", width=13)
    frames = []
    sizes = (16, 24, 32, 48, 64, 128, 256)
    for size in sizes:
        frame = image.resize((size, size), Image.Resampling.LANCZOS)
        # BITMAPINFOHEADER followed by bottom-up BGRA and the 1-bit AND mask.
        pixels = frame.transpose(Image.Transpose.FLIP_TOP_BOTTOM).tobytes("raw", "BGRA")
        stride = ((size + 31) // 32) * 4
        mask = bytearray(stride * size)
        for y in range(size):
            for x in range(size):
                if frame.getpixel((x, size - 1 - y))[3] == 0:
                    mask[y * stride + x // 8] |= 0x80 >> (x % 8)
        header = struct.pack("<IIIHHIIIIII", 40, size, size * 2, 1, 32, 0, len(pixels), 0, 0, 0, 0)
        frames.append(header + pixels + mask)
    offset = 6 + 16 * len(frames)
    result = bytearray(struct.pack("<HHH", 0, 1, len(frames)))
    for size, frame in zip(sizes, frames):
        result += struct.pack("<BBBBHHII", size % 256, size % 256, 0, 0, 1, 32, len(frame), offset)
        offset += len(frame)
    path.write_bytes(result + b"".join(frames))
    return image


if __name__ == "__main__":
    make_icon(Path(__file__).with_name("shell.ico"))
