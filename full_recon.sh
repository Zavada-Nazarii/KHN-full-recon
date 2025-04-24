#!/bin/bash

# Перевірка аргументів
if [ "$#" -ne 2 ]; then
  echo "Використання: $0 <url> <output_file>"
  exit 1
fi

TARGET_URL=$1
OUTPUT_FILE=$2
TMP_ENDPOINTS=$(mktemp)

echo "[+] Запускаємо Katana на $TARGET_URL ..."
katana -u "$TARGET_URL" -headless -d 3 -silent -o "$TMP_ENDPOINTS"

echo "[+] Перевіряємо знайдені endpoint-и через httpx ..."
LIVE_ENDPOINTS=$(mktemp)
cat "$TMP_ENDPOINTS" | httpx -silent -status-code -no-color | cut -d ' ' -f1 > "$LIVE_ENDPOINTS"

echo "[+] Запускаємо nuclei на живих endpoint-ах ..."
nuclei -l "$LIVE_ENDPOINTS" -t cves/ -silent -o "$OUTPUT_FILE"

echo "[✔] Готово! Результати збережено в $OUTPUT_FILE"

# Прибирання тимчасових файлів
rm -f "$TMP_ENDPOINTS" "$LIVE_ENDPOINTS"

