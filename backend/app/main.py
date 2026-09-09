import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from contextlib import asynccontextmanager
from app.database.mongo import db_manager
from app.routes import health, conditions, first_aid, medicines, symptom_check
from app.config import HOST, PORT

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup - safely connect or fallback
    try:
        await db_manager.connect()
    except Exception as e:
        print(f"Lifespan DB connection warning: {e}")
    yield
    # Shutdown
    try:
        await db_manager.close()
    except Exception:
        pass

app = FastAPI(
    title="MediRescue AI - Emergency First-Aid Assistant API",
    description="Backend REST API providing emergency first-aid guidance, ML symptom checking, medical conditions database, and medicine information.",
    version="1.0.0",
    lifespan=lifespan
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routers with both /api prefix and root for Vercel Serverless Function rewrites
routers = [health.router, conditions.router, first_aid.router, medicines.router, symptom_check.router]
for router in routers:
    app.include_router(router, prefix="/api", tags=["API"])
    app.include_router(router, tags=["Root API"])

# Mount static web directory locally (disabled on Vercel to avoid route collisions)
if not os.environ.get("VERCEL"):
    current_file_dir = os.path.dirname(__file__)  # backend/app
    backend_dir = os.path.dirname(current_file_dir)  # backend
    project_root = os.path.dirname(backend_dir)  # MediRescueAI
    web_dir = os.path.join(project_root, "web")

    if os.path.exists(web_dir):
        app.mount("/", StaticFiles(directory=web_dir, html=True), name="web")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host=HOST, port=PORT, reload=True)
