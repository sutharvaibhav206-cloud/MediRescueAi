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
    # Startup
    await db_manager.connect()
    yield
    # Shutdown
    await db_manager.close()

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

# Include API routers FIRST
app.include_router(health.router, prefix="/api", tags=["Health"])
app.include_router(conditions.router, prefix="/api", tags=["Conditions"])
app.include_router(first_aid.router, prefix="/api", tags=["First Aid"])
app.include_router(medicines.router, prefix="/api", tags=["Medicines"])
app.include_router(symptom_check.router, prefix="/api", tags=["Symptom Checker"])

# Mount static web directory at root / so all HTML/CSS/JS files load seamlessly
current_file_dir = os.path.dirname(__file__)  # backend/app
backend_dir = os.path.dirname(current_file_dir)  # backend
project_root = os.path.dirname(backend_dir)  # MediRescueAI
web_dir = os.path.join(project_root, "web")

if os.path.exists(web_dir):
    app.mount("/", StaticFiles(directory=web_dir, html=True), name="web")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host=HOST, port=PORT, reload=True)
