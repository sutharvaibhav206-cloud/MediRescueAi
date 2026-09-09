from typing import List, Dict, Any, Optional
from app.database.mongo import db_manager

class DataService:
    @staticmethod
    async def get_all_conditions() -> List[Dict[str, Any]]:
        if db_manager.is_connected and db_manager.db is not None:
            cursor = db_manager.db["medical_conditions"].find({}, {"_id": 0})
            return await cursor.to_list(length=100)
        return db_manager.in_memory_data.get("medical_conditions", [])

    @staticmethod
    async def get_condition_by_name(name: str) -> Optional[Dict[str, Any]]:
        if db_manager.is_connected and db_manager.db is not None:
            doc = await db_manager.db["medical_conditions"].find_one({"name": {"$regex": f"^{name}$", "$options": "i"}}, {"_id": 0})
            if doc:
                return doc
        
        # Fallback search in memory
        name_lower = name.lower()
        for cond in db_manager.in_memory_data.get("medical_conditions", []):
            if cond["name"].lower() == name_lower:
                return cond
        return None

    @staticmethod
    async def get_all_first_aid() -> List[Dict[str, Any]]:
        if db_manager.is_connected and db_manager.db is not None:
            cursor = db_manager.db["first_aid_guides"].find({}, {"_id": 0})
            return await cursor.to_list(length=100)
        return db_manager.in_memory_data.get("first_aid_guides", [])

    @staticmethod
    async def get_first_aid_by_category(category: str) -> List[Dict[str, Any]]:
        if db_manager.is_connected and db_manager.db is not None:
            cursor = db_manager.db["first_aid_guides"].find({"category": {"$regex": category, "$options": "i"}}, {"_id": 0})
            return await cursor.to_list(length=100)
        
        cat_lower = category.lower()
        results = []
        for item in db_manager.in_memory_data.get("first_aid_guides", []):
            if cat_lower in item.get("category", "").lower():
                results.append(item)
        return results

    @staticmethod
    async def search_medicines(query: str = "") -> List[Dict[str, Any]]:
        if db_manager.is_connected and db_manager.db is not None:
            filter_query = {}
            if query:
                filter_query = {"name": {"$regex": query, "$options": "i"}}
            cursor = db_manager.db["medicines"].find(filter_query, {"_id": 0})
            return await cursor.to_list(length=100)
        
        all_meds = db_manager.in_memory_data.get("medicines", [])
        if not query:
            return all_meds
        
        q_lower = query.lower()
        return [med for med in all_meds if q_lower in med["name"].lower() or any(q_lower in use.lower() for use in med.get("common_uses", []))]
