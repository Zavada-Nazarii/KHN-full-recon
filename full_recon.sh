#!/bin/bash

# Перевірка аргументів
if [ "$#" -ne 2 ]; then
  echo "Використання: $0 <url> <output_file>"
  exit 1
fi

TARGET_URL=$1
OUTPUT_FILE=$2

TMP_ENDPOINTS=$(mktemp)
LIVE_ENDPOINTS=$(mktemp)

echo "[+] Запускаємо Katana на $TARGET_URL ..."
katana -u "$TARGET_URL" -headless -d 3 -silent -o "$TMP_ENDPOINTS"

echo "[i] Katana знайдено $(wc -l < $TMP_ENDPOINTS) endpoint(ів):"
cat "$TMP_ENDPOINTS"

echo "[+] Перевіряємо через httpx ..."
cat "$TMP_ENDPOINTS" | httpx --silent --status-code --no-color | tee "$LIVE_ENDPOINTS"

echo "[i] httpx живих endpoint-ів: $(wc -l < $LIVE_ENDPOINTS)"

# Витягнути лише URL без статусу
URLS_CLEANED=$(mktemp)
cut -d ' ' -f1 "$LIVE_ENDPOINTS" > "$URLS_CLEANED"

echo "[+] Запускаємо nuclei на $(wc -l < $URLS_CLEANED) URL..."
nuclei -l "$URLS_CLEANED" -severity info,low,medium,high,critical -o "$OUTPUT_FILE"

echo "[✔] Готово! Результати збережено в $OUTPUT_FILE"

# DEBUG: Показати результати, якщо файл непустий
if [ -s "$OUTPUT_FILE" ]; then
  echo "[+] Виявлено вразливості:"
  cat "$OUTPUT_FILE"
else
  echo "[!] Нічого не знайдено."
fi

# Прибирання тимчасових файлів
rm -f "$TMP_ENDPOINTS" "$LIVE_ENDPOINTS" "$URLS_CLEANED"

