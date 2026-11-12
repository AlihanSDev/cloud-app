#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="cloud-app:cicd"
CONTAINER_NAME="cloud-app-cicd"
HOST_PORT="5002"

echo "========================================="
echo "  ЗАПУСК CI/CD PIPELINE (ЛОКАЛЬНЫЙ)"
echo "========================================="

echo "[1/5] Checkout code..."
echo "Код уже в папке $(pwd)"

echo "[2/5] Installing dependencies..."
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
./.venv/bin/python -m pip install --upgrade pip -q
./.venv/bin/python -m pip install -r requirements.txt -q

echo "[3/5] Running tests..."
if ! ./.venv/bin/python -m pytest tests/ -v; then
  echo "❌ ТЕСТЫ ПРОВАЛИЛИСЬ! Остановка пайплайна."
  exit 1
fi
echo "✅ Тесты прошли успешно!"

echo "[4/5] Building Docker image..."
docker build -t "$IMAGE_NAME" .

echo "[5/5] Deploying application..."
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
docker run -d --name "$CONTAINER_NAME" -p "${HOST_PORT}:5000" "$IMAGE_NAME"

echo "Проверяем, что приложение отвечает..."
for i in $(seq 1 20); do
  if curl -fsS "http://localhost:${HOST_PORT}/" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

curl -fsS "http://localhost:${HOST_PORT}/" | grep -q "Cloud Technologies Laboratory"
echo "========================================="
echo "  УСПЕХ! Приложение доступно на http://localhost:${HOST_PORT}"
echo "========================================="
