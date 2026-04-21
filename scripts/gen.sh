#!/usr/bin/env bash
# gen.sh <type> <prompt>
set -e
TYPE="$1"
PROMPT="$2"
OUTDIR_WIN="C:/Users/shaun/animated-website/PokeWeb/images"
RESULT_WIN="C:/Users/shaun/AppData/Local/Temp/${TYPE}_result.json"

mkdir -p "$OUTDIR_WIN"

JSON=$(printf '%s' "$PROMPT" | python -c 'import json,sys; prompt=sys.stdin.read(); print(json.dumps({"prompt":prompt,"aspect_ratio":"16:9","resolution":"2K"}))')

echo "[$TYPE] generating..."
infsh app run google/gemini-3-1-flash-image-preview --input "$JSON" --save "$RESULT_WIN" --json > /dev/null 2>&1

URL=$(python -c "import json; print(json.load(open(r'${RESULT_WIN}'))['output']['images'][0])")
echo "[$TYPE] url=$URL"

curl -sSL "$URL" -o "$OUTDIR_WIN/$TYPE.png"
SIZE=$(wc -c < "$OUTDIR_WIN/$TYPE.png")
echo "[$TYPE] saved $SIZE bytes"
