#!/bin/bash
set -euo pipefail
APP_NAME="${PROJECT_NAME}"
install_node_deps() {
  if [ -f package-lock.json ] || [ -f npm-shrinkwrap.json ]; then
    echo "[DISAL] Installing with npm ci (lockfile found)"
    npm ci
  else
    echo "[DISAL] Installing with npm install (no lockfile found)"
    npm install
  fi
}
cd frontend
install_node_deps
npm run build
cd ..
rm -rf backend/static
cp -r frontend/dist backend/static
python3 -m venv .venv
source .venv/bin/activate
pip install --quiet --no-cache-dir -r backend/requirements.txt
pm2 delete "${APP_NAME}" 2>/dev/null || true
if command -v pm2 &>/dev/null; then
  pm2 start ".venv/bin/uvicorn backend.main:app --host 0.0.0.0 --port ${ASSIGNED_PORT}" --name "${APP_NAME}" --interpreter none --cwd "$(pwd)"
  pm2 save --force
else
  nohup .venv/bin/uvicorn backend.main:app --host 0.0.0.0 --port "${ASSIGNED_PORT}" > "/tmp/disal-${APP_NAME}.log" 2>&1 &
fi
sleep 3
curl -fsS "http://127.0.0.1:${ASSIGNED_PORT}/api/health"
echo "[DISAL] Monorepo test is live on ${ASSIGNED_PORT}"
