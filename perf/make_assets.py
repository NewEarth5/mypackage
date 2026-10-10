"""Generate placeholder assets so report.tex can be compiled without the
original images / bibliography.  Every image referenced by report.tex is
recreated with the same name and a comparable pixel size, so the compile
time measured here is representative of the real report.

Usage: python3 make_assets.py <target-dir>
"""
import sys, os, random
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw

target = sys.argv[1]
img = os.path.join(target, "images")
os.makedirs(img, exist_ok=True)
os.makedirs(os.path.join(target, "sources"), exist_ok=True)
os.makedirs(os.path.join(target, "code"), exist_ok=True)

png = """champs_vitesse champs_vitesse_low_32deg champs_vitesse_low_39deg
champs_vitesse_low_60deg champs_vitesse_low_74deg champs_vitesse_low_78deg
champs_vitesse_med_3deg champs_vitesse_med_82deg champs_vitesse_med_90deg
dessin_paravent domain gradient_vitesse maillage maillage_zoom mesh_final
mesh_init pressure_coef_med_82deg schema_plaque area_high area_low
area_med""".split()
jpg = ["alex_sgn", "romeo_sgn"]
svg = """CFL_CD CFL_relativeCD CFL_time FTT_CD FTT_relativeCD angl_zones
baseSize_CD baseSize_relativeCD config_cond domain_CD domain_relativeCD
dragHig82 dragLow82 dragMed82 fsa_text_fr lengthFM_CD lengthFM_relativeCD
opti_angl pre_drag_force sizeFM_CD sizeFM_relativeCD""".split()

random.seed(1)
for name in png:
    # ~1600x900 colourful field, similar weight to a CFD screenshot
    w, h = 1600, 900
    im = Image.new("RGB", (w, h), (20, 40, 120))
    d = ImageDraw.Draw(im)
    for _ in range(400):
        x, y = random.randrange(w), random.randrange(h)
        r = random.randrange(5, 80)
        d.ellipse((x - r, y - r, x + r, y + r),
                  fill=tuple(random.randrange(256) for _ in range(3)))
    d.text((20, 20), name, fill=(255, 255, 255))
    im.save(os.path.join(img, name + ".png"))
for name in jpg:
    im = Image.new("RGB", (600, 250), (255, 255, 255))
    d = ImageDraw.Draw(im)
    d.line([(20, 200), (150, 50), (300, 180), (580, 60)], fill=(0, 0, 120), width=6)
    im.save(os.path.join(img, name + ".jpg"), quality=90)
for name in svg:
    fig, ax = plt.subplots(figsize=(6, 3.5))
    xs = [i / 10 for i in range(200)]
    ax.plot(xs, [((i * 7) % 13) / 13 + 0.1 * (i % 5) for i in range(200)])
    ax.set_title(name.replace("_", " "))   # no underscores: Inkscape LaTeX export
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    fig.tight_layout()
    fig.savefig(os.path.join(img, name + ".svg"))
    plt.close(fig)

# --- bibliography: one entry per key, spread over every category -------------
entries = {
    "starccm": "manual", "grid_indep": "article", "meca_flu": "book",
    "meca_flu_enonce": "misc", "reynolds": "online", "rans_models": "online",
    "strouhal_litterature": "report", "GridPro": "online", "CFL": "article",
    "FTT": "online", "MIT_turb": "online", "windfinder": "online",
    "vitesse_moy_irm": "online", "station_meteo": "online",
    "Turbulence_modeling": "book", "dimension_domain": "thesis",
    "maskell_formula": "report", "ai_chart": "online",
    "MECA0025": "misc",
}
with open(os.path.join(target, "sources", "sources.bib"), "w") as f:
    for i, (key, typ) in enumerate(entries.items()):
        f.write(f"@{typ}{{{key},\n  author = {{Author, A{i}}},\n"
                f"  title = {{Title for {key.replace('_', ' ')}}},\n"
                f"  year = {{20{10 + i % 15}}},\n")
        if typ == "article":
            f.write("  journal = {Journal of Tests},\n  volume = {1},\n  pages = {1--10},\n")
        if typ == "book":
            f.write("  publisher = {Publisher},\n")
        if typ in ("report", "thesis"):
            f.write("  institution = {Institution},\n  type = {Technical report},\n")
        if typ == "online":
            f.write(f"  url = {{https://example.org/{key}}},\n  urldate = {{2025-10-01}},\n")
        f.write("}\n\n")

with open(os.path.join(target, "code", "hello.py"), "w") as f:
    f.write("def hello(name):\n    \"\"\"Say hello.\"\"\"\n    return f'Hello {name}'\n\n"
            + "\n".join(f"x{i} = hello('{i}')" for i in range(12)) + "\n")
with open(os.path.join(target, "code", "main.c"), "w") as f:
    f.write("#include <stdio.h>\n\nint main(void) {\n    printf(\"hi\\n\");\n    return 0;\n}\n")
print("assets written to", target)
