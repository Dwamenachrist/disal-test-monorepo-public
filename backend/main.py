from pathlib import Path
from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

app = FastAPI(title="DISAL Monorepo Test")
static_dir = Path(__file__).parent / "static"

@app.get("/api/health")
def health():
    return {"ok": True, "service": "react-fastapi-monorepo"}

if static_dir.exists():
    app.mount("/assets", StaticFiles(directory=static_dir / "assets"), name="assets")

@app.get("/{path:path}")
def spa(path: str):
    index = static_dir / "index.html"
    if index.exists():
        return FileResponse(index)
    return {"message": "Frontend build not found. Run deploy.sh."}
