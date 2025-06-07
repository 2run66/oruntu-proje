# predict_knn_tuned.py

import sys
import pickle
import numpy as np
import librosa

def extract_features(filepath, n_mfcc=13):
    """
    Daha önce kullandığımız feature_extraction.py fonksiyonunun aynısı.
    """
    try:
        y, sr = librosa.load(filepath, sr=None, mono=True)
    except Exception as e:
        print(f"Dosya okunamadı: {filepath} → {e}")
        return None

    # 1) MFCC
    mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=n_mfcc)
    mfcc_mean = np.mean(mfcc, axis=1)
    mfcc_std  = np.std(mfcc, axis=1)

    # 2) Chroma
    stft = np.abs(librosa.stft(y))
    chroma = librosa.feature.chroma_stft(S=stft, sr=sr)
    chroma_mean = np.mean(chroma, axis=1)
    chroma_std  = np.std(chroma, axis=1)

    # 3) Spectral Contrast
    spec_contrast = librosa.feature.spectral_contrast(S=stft, sr=sr)
    contrast_mean = np.mean(spec_contrast, axis=1)
    contrast_std  = np.std(spec_contrast, axis=1)

    # 4) Tonnetz
    y_harmonic = librosa.effects.harmonic(y)
    tonnetz = librosa.feature.tonnetz(y=y_harmonic, sr=sr)
    tonnetz_mean = np.mean(tonnetz, axis=1)
    tonnetz_std  = np.std(tonnetz, axis=1)

    feature_vector = np.concatenate([
        mfcc_mean, mfcc_std,
        chroma_mean, chroma_std,
        contrast_mean, contrast_std,
        tonnetz_mean, tonnetz_std
    ])
    return feature_vector

def main():
    if len(sys.argv) != 2:
        print("Kullanım: python predict_knn_tuned.py <tahmin_edilecek_wav_dosyası>")
        sys.exit(1)

    wav_path = sys.argv[1]

    # 1) Tuned KNN modelini ve class_names listesini yükle
    try:
        with open("knn_tuned_model.pkl", "rb") as f_mod:
            knn = pickle.load(f_mod)
        with open("knn_tuned_classes.pkl", "rb") as f_cls:
            class_names = pickle.load(f_cls)
    except FileNotFoundError:
        print("knn_tuned_model.pkl veya knn_tuned_classes.pkl bulunamadı. Önce train_knn_tuned.py'yi çalıştırın.")
        sys.exit(1)

    # 2) WAV dosyasının özniteliklerini çıkar
    feats = extract_features(wav_path)
    if feats is None:
        print("Özellik çıkarma başarısız. Çıkılıyor.")
        sys.exit(1)

    # 3) Bir örnek için shape=(1,76)
    X_new = feats.reshape(1, -1)

    # 4) Tahmin yap
    pred_index = knn.predict(X_new)[0]
    pred_label = class_names[pred_index]

    print(f"DOSYA: {wav_path}")
    print(f"Tahmin Edilen Duygu (tuned KNN): {pred_label}")

if __name__ == "__main__":
    main()
