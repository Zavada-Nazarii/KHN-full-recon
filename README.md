
# 🔍 full_recon.sh

Цей скрипт автоматизує розвідку веб-додатку з використанням **Katana**, **httpx** та **nuclei**. Ідеально підходить для фаз **Reconnaissance** та **Pre-Exploitation** у пентестах або Bug Bounty.

---

## ⚙️ Інструменти, що використовуються

- [`katana`](https://github.com/projectdiscovery/katana) — високопродуктивний crawler з підтримкою headless-режиму (JavaScript crawling)
- [`httpx`](https://github.com/projectdiscovery/httpx) — перевірка живих endpoint-ів
- [`nuclei`](https://github.com/projectdiscovery/nuclei) — сканер вразливостей за шаблонами

---

## 🚀 Як використовувати

### 1. Зроби скрипт виконуваним:

```bash
chmod +x full_recon.sh
```

### 2. Запусти:

```bash
./full_recon.sh <target_url> <output_file>
```

📌 **Приклад:**

```bash
./full_recon.sh https://example.com report.txt
```

---

## 📄 Що робить скрипт

1. Запускає `katana` з `-headless` та глибиною обходу 3
2. Пропускає всі знайдені endpoint-и через `httpx` для перевірки статусу
3. Передає живі endpoint-и до `nuclei` (шаблони `cves/`)
4. Зберігає звіт про знайдені вразливості у файл

---

## 🧰 Вимоги

- Go ≥ 1.17
- Встановлені `katana`, `httpx`, `nuclei`
- Актуальні шаблони nuclei (оновити через `nuclei -update-templates`)

---

## 📌 Примітки

- Можна розширити підтримку проксі або Telegram-повідомлень
- Можливо інтегрувати у CI/CD або recon-автоматизацію
