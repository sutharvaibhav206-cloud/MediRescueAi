import os
import pickle
import sys

def predict_symptoms(symptom_text):
    base_dir = os.path.dirname(__file__)
    model_path = os.path.join(base_dir, "model", "symptom_model.pkl")
    vec_path = os.path.join(base_dir, "model", "vectorizer.pkl")

    if not os.path.exists(model_path) or not os.path.exists(vec_path):
        print("Model files not found. Please run train.py first.")
        return

    with open(model_path, "rb") as f:
        model = pickle.load(f)
    with open(vec_path, "rb") as f:
        vectorizer = pickle.load(f)

    X_vec = vectorizer.transform([symptom_text.lower()])
    probs = model.predict_proba(X_vec)[0]
    classes = model.classes_

    ranked = sorted(zip(classes, probs), key=lambda x: x[1], reverse=True)

    print(f"\nSymptom Input: '{symptom_text}'")
    print("Top Predicted Conditions:")
    for condition, prob in ranked[:3]:
        print(f" - {condition}: {prob * 100:.1f}% confidence")

if __name__ == "__main__":
    query = sys.argv[1] if len(sys.argv) > 1 else "I have fever, headache and body pain"
    predict_symptoms(query)
