# train_knn.py

import pickle
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn import metrics

def main():
    # 1) Özellikleri yükle (feature_extraction.py çıktısı)
    with open("speech_features.pkl", "rb") as f:
        X, y, class_names = pickle.load(f)

    # 2) Eğitim/Test ayır (%80 train, %20 test, stratify=y ile sınıf dengesi)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    print(f"Eğitim seti boyutu: {X_train.shape}, Test seti boyutu: {X_test.shape}")

    # 3) KNN sınıflandırıcısı (k=5)
    knn = KNeighborsClassifier(n_neighbors=5)

    # 4) Modeli eğit
    print("KNN (k=5) eğitimi başlıyor...")
    knn.fit(X_train, y_train)

    # 5) Test verisiyle değerlendir
    y_pred = knn.predict(X_test)
    accuracy = np.mean(y_pred == y_test)
    print(f"\nTest Doğruluk Oranı: {accuracy * 100:.2f}%\n")

    print("Sınıf bazlı sınıflandırma raporu:")
    print(metrics.classification_report(
        y_test, y_pred, target_names=class_names, digits=4
    ))

    cm = metrics.confusion_matrix(y_test, y_pred)
    print("Karışıklık Matrisi:\n", cm)

    # 6) Eğitilen modeli ve class_names listesini diske kaydet
    with open("knn_model.pkl", "wb") as f_model:
        pickle.dump(knn, f_model)
    with open("knn_classes.pkl", "wb") as f_names:
        pickle.dump(class_names, f_names)

    print("\nKNN modeli kaydedildi → knn_model.pkl")
    print("Sınıf isimleri kaydedildi → knn_classes.pkl")

if __name__ == "__main__":
    main()
