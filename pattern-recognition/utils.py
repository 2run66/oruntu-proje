import os

def get_ravdess_filepaths_and_labels(data_dir="data/RAVDESS"):
    """
    RAVDESS klasöründeki audio-only (modality=03) konuşma dosyalarından
    (Actor_01, Actor_02, …, Actor_24 altındaki) file path ve duygu etiketini çıkarır.
    Döner: [(filepath1, emotion_label1), (filepath2, emotion_label2), ...]
    """

    # RAVDESS’e göre emotion kodları:
    emotion_map = {
        "01": "neutral",
        "02": "calm",
        "03": "happy",
        "04": "sad",
        "05": "angry",
        "06": "fearful",
        "07": "disgust",
        "08": "surprised"
    }

    file_label_list = []
    # data_dir içinde Actor_01, Actor_02, ... Actor_24 klasörleri olmalı
    for actor_folder in os.listdir(data_dir):
        actor_path = os.path.join(data_dir, actor_folder)
        if not os.path.isdir(actor_path):
            continue

        for filename in os.listdir(actor_path):
            if not filename.lower().endswith(".wav"):
                continue

            parts = filename.split("-")
            # İlk parçaya (parts[0]) bakıyoruz:
            # RAVDESS’te audio-only speech dosyaları "03-..." ile başlar
            modality_code = parts[0]
            if modality_code != "03":
                # Yalnızca audio-only (03) konuşma dosyalarını al
                continue

            # Emotion kodu = parts[2]
            emotion_code = parts[2]
            if emotion_code not in emotion_map:
                continue
            emotion_label = emotion_map[emotion_code]

            filepath = os.path.join(actor_path, filename)
            file_label_list.append((filepath, emotion_label))

    return file_label_list
