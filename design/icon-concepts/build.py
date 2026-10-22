"""Urdu wordmark studies, outlined from the app's existing Nastaleeq font.
Run with the fonttools/uharfbuzz environment used for font subsetting.
"""
from pathlib import Path
import uharfbuzz as hb
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.transformPen import TransformPen

root=Path(__file__).resolve().parents[2]
font_path=root/'tool/fonts_src/JameelNooriNastaleeq.ttf'
tt=TTFont(font_path); glyphs=tt.getGlyphSet(); order=tt.getGlyphOrder()
font=hb.Font(hb.Face(font_path.read_bytes()))

def outline(text,x,y,w,h):
 buf=hb.Buffer();buf.add_str(text);buf.direction='rtl';buf.script='arab';buf.language='ur';hb.shape(font,buf)
 paths=[];bounds=[];cursor=0
 for info,pos in zip(buf.glyph_infos,buf.glyph_positions):
  glyph=glyphs[order[info.codepoint]];tx=cursor+pos.x_offset;ty=pos.y_offset
  bp=BoundsPen(glyphs);glyph.draw(TransformPen(bp,(1,0,0,-1,tx,-ty)))
  pen=SVGPathPen(glyphs);glyph.draw(TransformPen(pen,(1,0,0,-1,tx,-ty)))
  if bp.bounds:bounds.append(bp.bounds);paths.append(pen.getCommands())
  cursor+=pos.x_advance
 left=min(b[0] for b in bounds);top=min(b[1] for b in bounds);right=max(b[2] for b in bounds);bottom=max(b[3] for b in bounds)
 scale=min(w/(right-left),h/(bottom-top));dx=x+(w-(right-left)*scale)/2-left*scale;dy=y+(h-(bottom-top)*scale)/2-top*scale
 return f'<g transform="translate({dx:.3f} {dy:.3f}) scale({scale:.6f})">'+''.join(f'<path d="{p}"/>' for p in paths)+'</g>'

# No imported motifs or artwork: only the existing font outlines and custom flourishes.
a=outline('اسماء',83,46,132,82)+outline('الحسنیٰ',40,123,177,87)+'<path d="M63 220 Q128 237 197 211 Q140 249 63 220Z"/>'
b=outline('اسماء الحسنیٰ',25,66,206,119)+'<path d="M49 194 Q134 217 213 169 Q156 235 49 194Z"/>'
c='<path fill-rule="evenodd" d="M128 19 A109 109 0 1 0 128 237 A109 109 0 1 0 128 19 M128 23 A105 105 0 1 1 128 233 A105 105 0 1 1 128 23Z"/>'+outline('اسماء',75,53,121,76)+outline('الحسنیٰ',45,132,169,78)
a='<g transform="translate(-7 -7)">'+a+'</g>'
b='<g transform="translate(0 -8)">'+b+'</g>'
for name,art in [('a-stacked',a),('b-flowing',b),('c-seal',c)]:
 svg='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><title>اسماء الحسنیٰ — Urdu calligraphy concept</title><g fill="#111111">'+art+'</g></svg>'
 (root/f'design/icon-concepts/{name}.svg').write_text(svg)
 (root/f'design/icon-concepts/{name}-colour.svg').write_text(svg.replace('<g fill="#111111">','<rect width="256" height="256" rx="56" fill="#101820"/><g fill="#D9BC89">'))
