from flask import Flask, request, jsonify
import pickle
import numpy as np
import librosa
import tempfile
import os

def extract_features(filepath, n_mfcc=13):
    try:
        y, sr = librosa.load(filepath, sr=None, mono=True)
    except Exception:
        return None

    mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=n_mfcc)
    mfcc_mean = np.mean(mfcc, axis=1)
    mfcc_std  = np.std(mfcc, axis=1)

    stft = np.abs(librosa.stft(y))
    chroma = librosa.feature.chroma_stft(S=stft, sr=sr)
    chroma_mean = np.mean(chroma, axis=1)
    chroma_std  = np.std(chroma, axis=1)

    spec_contrast = librosa.feature.spectral_contrast(S=stft, sr=sr)
    contrast_mean = np.mean(spec_contrast, axis=1)
    contrast_std  = np.std(spec_contrast, axis=1)

    y_harmonic = librosa.effects.harmonic(y)
    tonnetz = librosa.feature.tonnetz(y=y_harmonic, sr=sr)
    tonnetz_mean = np.mean(tonnetz, axis=1)
    tonnetz_std  = np.std(tonnetz, axis=1)

    return np.concatenate([
        mfcc_mean, mfcc_std,
        chroma_mean, chroma_std,
        contrast_mean, contrast_std,
        tonnetz_mean, tonnetz_std
    ])

app = Flask(__name__)

with open("knn_tuned_model.pkl", "rb") as f_model:
    knn_model = pickle.load(f_model)
with open("knn_tuned_classes.pkl", "rb") as f_cls:
    class_names = pickle.load(f_cls)


@app.route("/",methods=["GET"])
def hello():
    return jsonify({"message": "Hello Umit"})
@app.route("/predict", methods=["POST"])
def predict_emotion():
    if "file" not in request.files:
        return jsonify({"error": "No file part. Use form‐field name 'file'."}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "Empty filename. Please upload a valid .wav file."}), 400

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp_path = tmp.name
        file.save(tmp_path)

    features = extract_features(tmp_path)
    try:
        os.remove(tmp_path)
    except OSError:
        pass

    if features is None:
        return jsonify({"error": "Failed to extract features. Is it a valid WAV?"}), 400

    X_new = features.reshape(1, -1)
    try:
        pred_index = knn_model.predict(X_new)[0]
    except Exception as e:
        return jsonify({"error": f"Prediction failed: {str(e)}"}), 500

    return jsonify({"emotion": class_names[pred_index]})
