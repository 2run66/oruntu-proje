# train_ann.py

import pickle
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn import metrics

def main():
    # 1) Özellikleri yükle
    with open("speech_features.pkl", "rb") as f:
        X, y, class_names = pickle.load(f)

    # 2) Eğitim/Test ayırma (%80–20, stratify=y)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    print(f"Eğitim boyutu: {X_train.shape}, Test boyutu: {X_test.shape}")

    # 3) MLPClassifier (ANN)
    clf = MLPClassifier(
        hidden_layer_sizes=(64, 32),
        activation='relu',
        solver='adam',
        alpha=1e-4,
        max_iter=300,
        random_state=1
    )

    # 4) Eğitim
    print("ANN (MLPClassifier) eğitimi başlıyor...")
    clf.fit(X_train, y_train)

    # 5) Tahmin ve Değerlendirme
    y_pred = clf.predict(X_test)
    accuracy = np.mean(y_pred == y_test)
    print(f"\nTest Doğruluk Oranı: {accuracy * 100:.2f}%\n")
    print("Sınıf bazlı sınıflandırma raporu:")
    print(metrics.classification_report(
        y_test, y_pred, target_names=class_names, digits=4
    ))
    cm = metrics.confusion_matrix(y_test, y_pred)
    print("Karışıklık Matrisi:\n", cm)

    # 6) Modeli diske kaydet
    with open("mlp_model.pkl", "wb") as f_model:
        pickle.dump(clf, f_model)
    # class_names listesini de saklayalım
    with open("mlp_classes.pkl", "wb") as f_names:
        pickle.dump(class_names, f_names)

    print("\nANN modeli kaydedildi → mlp_model.pkl")
    print("Sınıf isimleri kaydedildi → mlp_classes.pkl")

if __name__ == "__main__":
    main()
