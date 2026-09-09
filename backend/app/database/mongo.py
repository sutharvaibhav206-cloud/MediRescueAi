import json
import os
from typing import Optional, List, Dict, Any
from app.config import MONGODB_URI, DATABASE_NAME

try:
    from motor.motor_asyncio import AsyncIOMotorClient
    HAS_MOTOR = True
except ImportError:
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
        # Find project root directory (MediRescueAI)
        current_dir = os.path.dirname(__file__)  # backend/app/database
        backend_dir = os.path.dirname(os.path.dirname(current_dir))  # backend
        project_root = os.path.dirname(backend_dir)  # MediRescueAI
        
        data_file = os.path.join(project_root, "database", "initial_data.json")
        if os.path.exists(data_file):
            try:
                with open(data_file, "r") as f:
                    self.in_memory_data = json.load(f)
                    print(f"Loaded embedded seed dataset with {len(self.in_memory_data.get('medical_conditions', []))} conditions.")
            except Exception as e:
                print(f"Error loading local seed data: {e}")
        else:
            print(f"Seed data file not found at {data_file}")
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
            self.client.close()
            self.is_connected = False

db_manager = DatabaseManager()
