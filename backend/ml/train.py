import os
import pickle
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score

def train_model():
    base_dir = os.path.dirname(__file__)
    csv_path = os.path.join(base_dir, "dataset.csv")
    model_dir = os.path.join(base_dir, "model")
    
    os.makedirs(model_dir, exist_ok=True)
    
    print(f"Loading dataset from {csv_path}...")
    df = pd.read_csv(csv_path)
    
    X = df["symptom_text"].astype(str).str.lower()
    y = df["condition"]
    
    print(f"Dataset shape: {df.shape}")
    print(f"Unique conditions ({len(y.unique())}): {list(y.unique())}")
    
    # Feature Extraction with TF-IDF
    vectorizer = TfidfVectorizer(ngram_range=(1, 2), min_df=1)
    X_vec = vectorizer.fit_transform(X)
    
    # Fit model on entire dataset to maximize class coverage
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_vec, y)
    
    # Evaluate self accuracy
    y_pred = clf.predict(X_vec)
    accuracy = accuracy_score(y, y_pred)
    print("\n--- Model Evaluation ---")
    print(f"Training Accuracy: {accuracy * 100:.2f}%")
    
    # Save artifacts
    model_path = os.path.join(model_dir, "symptom_model.pkl")
    vec_path = os.path.join(model_dir, "vectorizer.pkl")
    
    with open(model_path, "wb") as f:
        pickle.dump(clf, f)
    with open(vec_path, "wb") as f:
        pickle.dump(vectorizer, f)
        
    print(f"\nModel saved to {model_path}")
    print(f"Vectorizer saved to {vec_path}")

if __name__ == "__main__":
    train_model()
