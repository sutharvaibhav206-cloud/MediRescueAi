import os
import json
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(os.path.dirname(__file__)), "backend", ".env"))

MONGODB_URI = os.getenv("MONGODB_URI", "mongodb://localhost:27017")
DATABASE_NAME = os.getenv("DATABASE_NAME", "medirescue_db")

def seed():
    try:
        import pymongo
        print(f"Connecting to MongoDB at '{MONGODB_URI}'...")
        client = pymongo.MongoClient(MONGODB_URI, serverSelectionTimeoutMS=3000)
        client.admin.command('ping')
        
        db = client[DATABASE_NAME]
        
        json_path = os.path.join(os.path.dirname(__file__), "initial_data.json")
        with open(json_path, "r") as f:
            data = json.load(f)
            
        # Seed medical_conditions
        cond_coll = db["medical_conditions"]
        cond_coll.delete_many({})
        if data.get("medical_conditions"):
            cond_coll.insert_many(data["medical_conditions"])
            cond_coll.create_index("name", unique=True)
            print(f"Seeded {len(data['medical_conditions'])} medical conditions.")

        # Seed first_aid_guides
        fa_coll = db["first_aid_guides"]
        fa_coll.delete_many({})
        if data.get("first_aid_guides"):
            fa_coll.insert_many(data["first_aid_guides"])
            fa_coll.create_index("title")
            fa_coll.create_index("category")
            print(f"Seeded {len(data['first_aid_guides'])} first-aid guides.")

        # Seed medicines
        med_coll = db["medicines"]
        med_coll.delete_many({})
        if data.get("medicines"):
            med_coll.insert_many(data["medicines"])
            med_coll.create_index("name", unique=True)
            print(f"Seeded {len(data['medicines'])} medicines.")

        print("Database seeding completed successfully!")

    except Exception as e:
        print(f"Failed to seed MongoDB ({e}). Local embedded JSON fallback will be used by backend automatically.")

if __name__ == "__main__":
    seed()
