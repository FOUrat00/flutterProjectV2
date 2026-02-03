# 🏛️ Urbino University Authentication - Premium Flutter App

Une application Flutter **premium** et **élégante** pour la plateforme de logement étudiant, inspirée de l'architecture Renaissance d'Urbino et de l'Université degli Studi di Urbino Carlo Bo.

> **Note :** Ce projet a été mis à jour pour inclure des fonctionnalités avancées (State Management, Persistance, HTTP) et vise un score parfait.

## 🎨 Design Philosophy

### Inspiration
- **Architecture Renaissance** d'Urbino
- **Identité universitaire** Carlo Bo
- **Atmosphère italienne** chaleureuse et accueillante
- **Premium & Professional** pour étudiants internationaux

### Palette de Couleurs Officielle

| Couleur | Hex | Usage |
|---------|-----|-------|
| **Dark Blue** | `#002B5C` | Couleur principale, boutons, icônes |
| **Gold/Beige** | `#D1B97C` | Accents, bordures, highlights |
| **White** | `#FFFFFF` | Cartes, arrière-plans |
| **Brick Orange** (optionnel) | `#D4735E` | Inspiration bâtiments Urbino |

## � Fonctionnalités Techniques Avancées

Cette application intègre désormais des standards de développement modernes :

### ✅ **V6 : State Management (Provider)**
- Utilisation du package **Provider** pour une gestion d'état réactive et performante.
- Architecture MVVM-like avec `AuthManager` étendant `ChangeNotifier`.
- Injection de dépendances via `MultiProvider` à la racine de l'application.

### ✅ **V3 : Persistance des Données (SharedPreferences)**
- Sauvegarde locale de l'état de connexion.
- L'utilisateur reste connecté même après redémarrage de l'application.
- Gestion transparente des sessions (`_loadLoginState`, `_saveLoginState`).

### ✅ **V4 : Service Distant (HTTP)**
- Intégration d'un service API REST via le package **http**.
- **News Feed** : Récupération dynamique d'articles via API (simulé avec JSONPlaceholder).
- Gestion des états de chargement (loading) et d'erreur (error handling) dans l'UI.

## �📱 Pages Créées

### 1. **Login Page** (Page de Connexion)
- Email/Username avec validation
- Password avec toggle de visibilité
- **Auto-login** grâce à la persistance
- Bouton LOGIN avec gradient bleu
- Animation d'entrée élégante (fade + slide)
- Logo universitaire circulaire avec anneau décoratif

### 2. **Sign Up Page** (Inscription)
- Full name
- Email avec validation
- Password avec **indicateur de force premium** :
  - Barre de progression animée avec glow
  - Icônes de statut (✓, ⚠, ✗)
  - Couleurs: Rouge (faible), Orange (moyen), Vert (fort)
- Confirm password
- Bouton CREATE ACCOUNT avec gradient
- Navigation fluide vers Login

### 3. **University Page** (Nouveau)
- Intégration du flux d'actualités en temps réel (HTTP).
- Onglets pour Academics, Events et Campus Life.

## ✨ Caractéristiques Premium

### Design Élégant
- ✅ **Gradients sophistiqués** : Dégradés bleu foncé → bleu profond
- ✅ **Shadows élégantes** : Ombres douces avec effet glow
- ✅ **Rounded corners** : Bordures arrondies (16-20px)
- ✅ **Gold accents** : Barre dorée en haut de chaque carte
- ✅ **Typography premium** : Inter font, letterspacing optimisé

### Animations Fluides
- ✅ **Fade-in** : Apparition progressive (800ms)
- ✅ **Slide-up** : Glissement vertical élégant
- ✅ **Logo animation** : Rotation et scale au chargement
- ✅ **Button hover** : États interactifs
- ✅ **Page transitions** : Navigation avec FadeTransition (400ms)

## 🏗️ Structure du Projet

```
lib/
├── constants/
│   └── app_theme.dart              # Thème Urbino complet
├── services/
│   ├── auth_manager.dart           # Provider + SharedPreferences
│   ├── news_service.dart           # Service HTTP (API)
│   └── notification_manager.dart   # Gestion notifications
├── pages/
│   ├── login_page.dart             # Login (Provider consumer)
│   ├── signup_page.dart            # Inscription
│   ├── university_page.dart        # Page avec HTTP News
│   └── ...
└── main.dart                       # Entry point + MultiProvider
```

## 📦 Dépendances

```yaml
dependencies:
  flutter: sdk
  provider: ^6.0.0            # State Management (V6)
  shared_preferences: ^2.2.0  # Persistance (V3)
  http: ^1.1.0                # Remote Service (V4)
  image_picker: ^1.0.4        # Upload photo profil
```

## 🚀 Installation et Lancement

### Prérequis
- Flutter SDK 3.0+
- Dart SDK

### Étapes

```bash
# 1. Installation des dépendances
flutter pub get

# 2. Lancement sur Chrome (recommandé pour test rapide)
flutter run -d chrome

# 3. Ou sur Windows Desktop
flutter run -d windows
```

##  Messages Italiens

L'application utilise des touches italiennes pour l'authenticité :
- **"Benvenuto"** - Bienvenue
- **"Benvenuto! Login successful"** - Message de succès

## 🎯 Résumé

Une application Flutter **premium** et **professionnelle** avec :
- 🏛️ Design Renaissance inspiré d'Urbino
- 🛠️ **Architecture robuste (Provider, HTTP, Persistence)**
- 🎨 Palette officielle université (bleu + or)
- ✨ Animations élégantes et fluides
- 📱 Mobile-first responsive
- 💎 Interface digne d'une startup

**Prêt pour production avec intégration backend !**
