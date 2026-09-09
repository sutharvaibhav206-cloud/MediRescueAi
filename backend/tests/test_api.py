import os
import sys
import unittest
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(__file__))))

from app.main import app

class TestMediRescueAPI(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.client = TestClient(app)

    def test_1_health_endpoint(self):
        response = self.client.get("/api/health")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["status"], "healthy")
        self.assertIn("database_connected", data)
        self.assertIn("ml_model_loaded", data)

    def test_2_get_conditions(self):
        response = self.client.get("/api/conditions")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)
        self.assertIn("name", data[0])

    def test_3_get_condition_by_name(self):
        response = self.client.get("/api/conditions/Viral Fever")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["name"], "Viral Fever")
        self.assertIn("first_aid", data)

    def test_4_get_condition_not_found(self):
        response = self.client.get("/api/conditions/UnknownConditionXYZ")
        self.assertEqual(response.status_code, 404)

    def test_5_get_first_aid_guides(self):
        response = self.client.get("/api/first-aid")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)

    def test_6_get_first_aid_by_category(self):
        response = self.client.get("/api/first-aid?category=Injuries")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)

    def test_7_search_medicines(self):
        response = self.client.get("/api/medicines?q=Paracetamol")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)
        self.assertIn("Paracetamol", data[0]["name"])

    def test_8_symptom_check_normal(self):
        payload = {
            "symptoms_text": "I have fever, headache and body pain",
            "selected_symptoms": ["Fever", "Headache"],
            "age": 25,
            "gender": "Male",
            "duration": "2 days"
        }
        response = self.client.post("/api/symptom-check", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertFalse(data["is_emergency"])
        self.assertGreater(len(data["possible_conditions"]), 0)
        self.assertIn("first_aid", data)
        self.assertIn("disclaimer", data)

    def test_9_symptom_check_emergency_trigger(self):
        payload = {
            "symptoms_text": "Severe chest pain radiating to arm and difficulty breathing",
            "selected_symptoms": ["Chest Pain"],
            "age": 50,
            "gender": "Male",
            "duration": "30 minutes"
        }
        response = self.client.post("/api/symptom-check", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertTrue(data["is_emergency"])
        self.assertIn("EMERGENCY", data["emergency_warning"])
        self.assertIn("CRITICAL", data["severity"])
        self.assertGreater(len(data["first_aid"]), 0)

    def test_10_symptom_check_empty(self):
        payload = {
            "symptoms_text": "",
            "selected_symptoms": []
        }
        response = self.client.post("/api/symptom-check", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertFalse(data["is_emergency"])

if __name__ == "__main__":
    unittest.main()
