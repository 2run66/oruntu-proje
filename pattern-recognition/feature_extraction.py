# feature_extraction.py

import numpy as np
import librosa
import pickle
from tqdm import tqdm
from utils import get_ravdess_filepaths_and_labels

def extract_features(filepath, n_mfcc=13):
    """
    Bir .wav dosyasından MFCC, Chroma, Spectral Contrast ve Tonnetz özelliklerini çıkarır.
    Dönen vektör uzunluğu: 2*n_mfcc (MFCC ort+std) + 24 (Chroma ort+std) + 14 (Contrast ort+std) + 12 (Tonnetz ort+std) = 76
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
    #    Önce harmonik (harmonic) kısmı çıkart
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


def build_dataset(data_dir="data/RAVDESS", save_path="speech_features.pkl"):
    """
    RAVDESS içindeki tüm konuşma dosyalarından özellik çıkarır ve
    X (özellik matrisi), y (etiketler) ve class_names listesini pickle olarak kaydeder.
    """
    file_label_list = get_ravdess_filepaths_and_labels(data_dir)
    n_samples = len(file_label_list)
    print(f"Toplam {n_samples} kayıt bulundu.")

    # Duygu etiketlerini sayısala dönüştür
    class_names = sorted(list(set([label for (_, label) in file_label_list])))
    class_to_index = {label: idx for idx, label in enumerate(class_names)}
    print(f"Sınıflar (etiketler): {class_names}")

    X = []
    y = []
    for filepath, label in tqdm(file_label_list, desc="Özellik çıkarılıyor"):
        feats = extract_features(filepath)
        if feats is None:
            continue
        X.append(feats)
        y.append(class_to_index[label])

    X = np.array(X)
    y = np.array(y)
    print(f"Özellik matrisi boyutu: {X.shape}, Etiket boyutu: {y.shape}")

    with open(save_path, "wb") as f:
        pickle.dump((X, y, class_names), f)
    print(f"Özellikler kaydedildi → {save_path}")
    return X, y, class_names


if __name__ == "__main__":
    build_dataset()
