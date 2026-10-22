"""Compile the approved outlined SVG into dependency-free Flutter paths.
Requires fonttools (already used by tool/subset_fonts.py).
"""
from pathlib import Path
import re
import xml.etree.ElementTree as ET
from fontTools.misc.transform import Transform
from fontTools.pens.recordingPen import RecordingPen
from fontTools.pens.transformPen import TransformPen
from fontTools.svgLib.path import parse_path

root = Path(__file__).resolve().parents[2]
svg = ET.parse(root / 'design/brand/wordmark.svg').getroot()
commands=[]
def visit(el, parent=Transform()):
 t=Transform()
 for kind,values in re.findall(r'(translate|scale)\(([^)]+)\)',el.get('transform','')):
  v=[float(x) for x in re.split(r'[ ,]+',values.strip())]
  t=t.translate(v[0],v[1] if len(v)>1 else 0) if kind=='translate' else t.scale(v[0],v[1] if len(v)>1 else v[0])
 t=parent.transform(t)
 if el.tag.endswith('path'):
  pen=RecordingPen();parse_path(el.attrib['d'],TransformPen(pen,t))
  for op,args in pen.value:
   method={'moveTo':'moveTo','lineTo':'lineTo','qCurveTo':'quadraticBezierTo','curveTo':'cubicTo','closePath':'close','endPath':'close'}[op]
   coords=', '.join(f'{v:.3f}' for pt in args for v in pt)
   commands.append(f'    ..{method}({coords})')
 for child in el:visit(child,t)
visit(svg)
out="// Generated from design/brand/wordmark.svg by tool/icon/build_wordmark.py.\n// Urdu: اسماء الحسنیٰ. Keep the approved outlines as the source of truth.\nimport 'dart:ui';\n\nPath createWordmarkPath() => Path()\n"+'\n'.join(commands)+';\n'
(root/'lib/src/ui/wordmark_path.dart').write_text(out)
