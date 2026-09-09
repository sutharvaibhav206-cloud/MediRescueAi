import json
import os
from typing import Optional, List, Dict, Any
from app.config import MONGODB_URI, DATABASE_NAME

try:
    from motor.motor_asyncio import AsyncIOMotorClient
    HAS_MOTOR = True
except Exception:
    HAS_MOTOR = False

class DatabaseManager:
    def __init__(self):
        self.client = None
        self.db = None
        self.is_connected = False
        self.in_memory_data = {}
        self.load_local_data()

    def load_local_data(self):
        """Loads seed data from local seed files as fallback."""
        current_dir = os.path.dirname(__file__)  # backend/app/database
        backend_dir = os.path.dirname(os.path.dirname(current_dir))  # backend
        project_root = os.path.dirname(backend_dir)  # MediRescueAI
        
        possible_paths = [
            os.path.join(project_root, "database", "initial_data.json"),
            os.path.join(backend_dir, "database", "initial_data.json"),
            os.path.abspath(os.path.join(current_dir, "..", "..", "..", "database", "initial_data.json")),
            os.path.abspath(os.path.join(current_dir, "..", "..", "database", "initial_data.json")),
        ]

        data_file = None
        for p in possible_paths:
            if os.path.exists(p):
                data_file = p
                break

        if data_file:
            try:
                with open(data_file, "r", encoding="utf-8") as f:
                    self.in_memory_data = json.load(f)
                    print(f"Loaded embedded seed dataset from {data_file}")
            except Exception as e:
                print(f"Error loading local seed data: {e}")
        else:
            print("Seed data file not found. Using fallback in-memory dataset.")
            self.in_memory_data = {
                "medical_conditions": [],
                "first_aid_guides": [],
                "medicines": []
            }

    async def connect(self):
        if HAS_MOTOR:
            try:
                self.client = AsyncIOMotorClient(MONGODB_URI, serverSelectionTimeoutMS=1000)
                await self.client.admin.command('ping')
                self.db = self.client[DATABASE_NAME]
                self.is_connected = True
                print(f"Successfully connected to MongoDB database '{DATABASE_NAME}'.")
                return
            except Exception as e:
                print(f"MongoDB connection failed ({e}). Falling back to embedded local dataset driver.")
                self.is_connected = False
        else:
            print("Motor not available. Using local embedded dataset driver.")
            self.is_connected = False

    async def close(self):
        if self.client:
            try:
                self.client.close()
            except Exception:
                pass

db_manager = DatabaseManager()
