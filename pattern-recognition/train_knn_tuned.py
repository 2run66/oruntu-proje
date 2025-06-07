import pickle
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV, StratifiedKFold
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.decomposition import PCA
from sklearn import metrics

def main():
    with open("speech_features.pkl", "rb") as f:
        X, y, class_names = pickle.load(f)
    print(f"Loaded features: X.shape={X.shape}, y.shape={y.shape}")

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    print(f"Train size: {X_train.shape}, Test size: {X_test.shape}\n")

    pipeline = Pipeline([
        ("scaler", StandardScaler()),
        ("pca", PCA()),
        ("knn", KNeighborsClassifier())
    ])

    param_grid = [
        {
            "pca": [PCA(n_components=20), PCA(n_components=30), "passthrough"],
            "knn__n_neighbors": [3, 5, 7, 9, 11],
            "knn__weights": ["uniform", "distance"],
            "knn__p": [1, 2]
        }
    ]

    cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

    grid = GridSearchCV(
        estimator=pipeline,
        param_grid=param_grid,
        cv=cv,
        scoring="accuracy",
        n_jobs=1,
        verbose=2
    )

    print("Starting GridSearchCV for KNN hyperparameters...\n")
    grid.fit(X_train, y_train)

    print(f"\nBest cross‐val score: {grid.best_score_:.4f}")
    print("Best parameters:")
    print(grid.best_params_)

    best_model = grid.best_estimator_
    y_pred = best_model.predict(X_test)
    test_acc = np.mean(y_pred == y_test)
    print(f"\nTest set accuracy: {test_acc * 100:.2f}%\n")

    print("Classification report on test set:")
    print(metrics.classification_report(
        y_test, y_pred, target_names=class_names, digits=4
    ))
    print("Confusion matrix:")
    print(metrics.confusion_matrix(y_test, y_pred))

    with open("knn_tuned_model.pkl", "wb") as f_mod:
        pickle.dump(best_model, f_mod)
    with open("knn_tuned_classes.pkl", "wb") as f_cl:
        pickle.dump(class_names, f_cl)

    print("\nSaved tuned KNN model → knn_tuned_model.pkl")
    print("Saved class names → knn_tuned_classes.pkl")

if __name__ == "__main__":
    main()
