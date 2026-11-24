# cv_flutter_grace

Application mobile Flutter de Muhindo Munduwandi Grace présentant mon **CV**, ma **famille** et mes **coordonnées**.

## Fonctionnalités

- Page de **connexion** (identifiant + mot de passe masqué)
- Page **Accueil** : CV complet (photo, profil, formation, expériences, compétences, langues, centres d'intérêt)
- Page **Famille** : membres de la famille (nom, photo, lien de parenté, profession)
- Page **Contact** : téléphone, e-mail, adresse, LinkedIn, GitHub (**liens cliquables**)
- Navigation par **barre de navigation inférieure**

**Identifiants de test :** `admin` / `1234`

## TP2 – Intégration de l'API REST

L'application est connectée à l'API https://github.com/espoirbaraka/api-test (PHP + MySQL, XAMPP).

- **Authentification réelle** : création de compte et connexion via l'API (`/accounts/register`, `/accounts/login`)
- **Gestion des membres de la famille** : consultation, ajout (avec photo), modification et suppression, enregistrés en base de données (`/famille-membres`)

### Vidéo de démonstration

[▶ Voir la vidéo de démonstration](demo/demo.mp4)

### Configuration

1. Démarrer Apache et MySQL dans XAMPP et importer `api.sql` dans la base `api`.
2. Mettre l'adresse IP du PC dans `lib/config.dart`.
3. Lancer l'application sur un téléphone connecté au même Wi-Fi que le PC : `flutter run`.

## Captures d'écran

| Connexion | Accueil |
|:---:|:---:|
| ![Connexion](screenshots/login.png) | ![Accueil](screenshots/home.png) |

| Famille | Contact |
|:---:|:---:|
| ![Famille](screenshots/family.png) | ![Contact](screenshots/contact.png) |

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Structure

```
lib/
├── main.dart
├── data/profile_data.dart      # toutes les informations personnelles
├── pages/                      # login, accueil, famille, contact
└── widgets/avatar_image.dart
```
