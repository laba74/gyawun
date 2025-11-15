# Guide de Compilation et Exécution - Windows

Ce document explique comment compiler et exécuter **Gyawun Music** sur Windows.

---

## ⚠️ IMPORTANT - Première Installation

**Avant de compiler ou d'exécuter l'application pour la première fois**, vous devez initialiser le support Windows :

### Initialisation Automatique (RECOMMANDÉ)

Double-cliquer sur `setup-windows.bat` ou exécuter :
```cmd
setup-windows.bat
```

**Ou avec PowerShell :**
```powershell
.\setup-windows.ps1
```

**Ce script va :**
1. ✅ Vérifier l'installation de Flutter
2. ✅ Activer le support Windows desktop
3. ✅ Créer les fichiers de configuration Windows
4. ✅ Télécharger les dépendances

### Initialisation Manuelle

Si vous préférez le faire manuellement :
```cmd
# 1. Activer Windows desktop
flutter config --enable-windows-desktop

# 2. Créer les fichiers Windows
flutter create --platforms=windows .

# 3. Télécharger les dépendances
flutter pub get
```

**⚠️ Cette étape n'est nécessaire qu'UNE SEULE FOIS lors de la première installation.**

---

## 📋 Prérequis

### 1. Installer Flutter

1. Télécharger Flutter SDK depuis : https://flutter.dev/docs/get-started/install/windows
2. Extraire le fichier ZIP dans un emplacement (ex: `C:\src\flutter`)
3. Ajouter Flutter au PATH :
   - Ouvrir "Modifier les variables d'environnement système"
   - Cliquer sur "Variables d'environnement"
   - Dans "Variables système", trouver "Path" et cliquer "Modifier"
   - Ajouter le chemin vers `flutter\bin` (ex: `C:\src\flutter\bin`)
   - Cliquer OK pour sauvegarder

4. Vérifier l'installation :
   ```cmd
   flutter doctor
   ```

### 2. Installer Visual Studio

Flutter Windows nécessite Visual Studio 2022 ou plus récent :

1. Télécharger Visual Studio Community : https://visualstudio.microsoft.com/downloads/
2. Pendant l'installation, sélectionner :
   - ✅ **Développement Desktop en C++**
   - ✅ **SDK Windows 10/11**

3. Vérifier avec :
   ```cmd
   flutter doctor
   ```

### 3. Activer le support Windows Desktop

```cmd
flutter config --enable-windows-desktop
```

---

## 🚀 Méthodes de Compilation et Exécution

### ⚡ Première Utilisation

**Si c'est la première fois que vous compilez le projet :**

1. **Exécuter `setup-windows.bat`** (une seule fois)
2. Attendre la fin de l'initialisation
3. Ensuite, utiliser `run.bat` ou `build.bat` normalement

---

### Méthode 1 : Scripts Batch (.bat) - **RECOMMANDÉ**

#### Exécuter en mode développement (Debug)
Double-cliquer sur `run.bat` ou :
```cmd
run.bat
```

**Avantages :**
- Hot reload activé (rechargement à chaud)
- Modifications du code visibles instantanément
- Debugging actif
- Idéal pour le développement

#### Compiler en mode Release (Production)
Double-cliquer sur `build.bat` ou :
```cmd
build.bat
```

**Résultat :**
- Exécutable optimisé : `build\windows\x64\runner\Release\gyawun.exe`
- Taille réduite
- Performance maximale
- À distribuer aux utilisateurs

#### Compiler en mode Debug (avec symboles)
Double-cliquer sur `build-debug.bat` ou :
```cmd
build-debug.bat
```

**Résultat :**
- Exécutable de debug : `build\windows\x64\runner\Debug\gyawun.exe`
- Avec informations de debugging
- Plus rapide à compiler que Release

---

### Méthode 2 : Scripts PowerShell (.ps1)

#### Activer l'exécution de scripts PowerShell

**IMPORTANT** : Avant d'exécuter des scripts .ps1, autoriser leur exécution :

```powershell
# Ouvrir PowerShell en tant qu'Administrateur et exécuter :
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Exécuter en mode développement
Clic droit sur `run.ps1` → "Exécuter avec PowerShell" ou :
```powershell
.\run.ps1
```

#### Compiler en mode Release
Clic droit sur `build.ps1` → "Exécuter avec PowerShell" ou :
```powershell
.\build.ps1
```

---

### Méthode 3 : Lignes de Commande Manuelles

#### Préparation initiale (une seule fois)
```cmd
# Activer le support Windows
flutter config --enable-windows-desktop

# Télécharger les dépendances
flutter pub get
```

#### Exécuter en mode Debug
```cmd
flutter run -d windows
```

Options utiles :
- `flutter run -d windows --release` - Mode release (plus rapide)
- `flutter run -d windows --verbose` - Mode verbose pour debugging
- `flutter run -d windows --no-sound-null-safety` - Si problèmes de null safety

#### Compiler pour production
```cmd
# Nettoyer les builds précédents
flutter clean

# Compiler en Release
flutter build windows --release

# L'exécutable sera dans :
# build\windows\x64\runner\Release\gyawun.exe
```

#### Compiler en mode Debug
```cmd
flutter clean
flutter build windows --debug

# L'exécutable sera dans :
# build\windows\x64\runner\Debug\gyawun.exe
```

---

## 🔧 Commandes Utiles

### Diagnostics
```cmd
# Vérifier l'installation Flutter et dépendances
flutter doctor -v

# Lister les appareils disponibles
flutter devices

# Analyser le projet
flutter analyze

# Formater le code
flutter format .
```

### Gestion des Dépendances
```cmd
# Télécharger les dépendances
flutter pub get

# Mettre à jour les dépendances
flutter pub upgrade

# Nettoyer le cache
flutter clean
flutter pub cache clean
```

### Build et Performance
```cmd
# Build avec profiling
flutter build windows --profile

# Build avec rapport de taille
flutter build windows --release --analyze-size

# Build avec logs détaillés
flutter build windows --release --verbose
```

---

## 📦 Structure de Build

Après compilation, la structure sera :

```
build/
└── windows/
    └── x64/
        └── runner/
            ├── Release/           # Build Release (Production)
            │   ├── gyawun.exe    # ← Exécutable principal
            │   ├── data/         # Assets de l'app
            │   └── *.dll         # DLLs nécessaires
            │
            └── Debug/            # Build Debug
                ├── gyawun.exe
                ├── data/
                └── *.dll
```

### Distribution

Pour distribuer l'application :

1. Copier **tout le dossier** `Release/` (pas seulement .exe)
2. Ou créer un installeur avec :
   - [Inno Setup](https://jrsoftware.org/isinfo.php)
   - [NSIS](https://nsis.sourceforge.io/)
   - [Advanced Installer](https://www.advancedinstaller.com/)

---

## ⚠️ Résolution de Problèmes

### Erreur : "No Windows desktop project configured"
```
Error: No Windows desktop project configured.
```

**Solution :**
```cmd
# Exécuter le script d'initialisation
setup-windows.bat

# Ou manuellement :
flutter create --platforms=windows .
```

Cette erreur signifie que les fichiers de configuration Windows n'ont pas été créés. Exécutez `setup-windows.bat` une fois pour les générer.

---

### Erreur : "Flutter not found"
```cmd
# Vérifier que Flutter est dans le PATH
where flutter

# Si non trouvé, ajouter au PATH (voir Prérequis)
```

### Erreur : "Visual Studio not found"
```cmd
# Vérifier l'installation
flutter doctor

# Réinstaller Visual Studio avec les bons composants
```

### Erreur : "Unable to find suitable Visual Studio toolchain"
```cmd
# Forcer la détection
flutter doctor -v

# Reconfigurer
flutter config --enable-windows-desktop
```

### Erreur de compilation : "pub get failed"
```cmd
# Nettoyer et réessayer
flutter clean
flutter pub cache clean
flutter pub get
```

### Application crash au démarrage
```cmd
# Vérifier que tous les fichiers DLL sont présents
# Reconstruire en mode debug pour voir les erreurs
flutter build windows --debug
```

### Hot Reload ne fonctionne pas
```cmd
# Relancer l'app
r  # dans le terminal Flutter

# Restart complet
R  # dans le terminal Flutter

# Si toujours bloqué, relancer : flutter run -d windows
```

---

## 🎯 Workflow Recommandé

### Pour le Développement :
1. Exécuter avec `run.bat`
2. Modifier le code
3. Sauvegarder (le hot reload s'active automatiquement)
4. Tester

### Pour la Distribution :
1. Nettoyer : `flutter clean`
2. Compiler : `build.bat` (ou `flutter build windows --release`)
3. Tester l'exécutable dans `build\windows\x64\runner\Release\`
4. Créer un installeur ou distribuer le dossier

### Pour le Debug Avancé :
1. Compiler en debug : `build-debug.bat`
2. Utiliser Visual Studio pour debugger :
   ```cmd
   # Ouvrir la solution
   build\windows\gyawun.sln
   ```
3. Utiliser les breakpoints et le debugger Visual Studio

---

## 📊 Comparaison des Modes

| Mode | Taille | Vitesse Build | Performance | Debug | Usage |
|------|--------|---------------|-------------|-------|-------|
| **Debug** | ~200MB | Rapide (1-2 min) | Moyenne | ✅ Oui | Développement |
| **Release** | ~50MB | Lent (3-5 min) | Maximale | ❌ Non | Production |
| **Profile** | ~100MB | Moyen (2-3 min) | Haute | ⚠️ Limité | Profiling perf |

---

## 🔗 Ressources

- [Documentation Flutter Windows](https://docs.flutter.dev/platform-integration/windows/building)
- [Flutter Desktop Embedder](https://github.com/flutter/flutter/wiki/Desktop-shells)
- [Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/)
- [Flutter Community](https://flutter.dev/community)

---

## 💡 Astuces

### Accélérer les Builds
```cmd
# Utiliser le cache pub
flutter pub get --offline

# Compiler seulement si nécessaire
flutter build windows --release --no-tree-shake-icons
```

### Réduire la Taille de l'Exécutable
```cmd
# Activer l'obfuscation (optionnel)
flutter build windows --release --obfuscate --split-debug-info=./debug-info
```

### Debug Console
Pendant l'exécution en mode debug, utilisez :
- `r` : Hot reload
- `R` : Hot restart
- `p` : Afficher la hiérarchie des widgets
- `o` : Activer/désactiver le mode plateforme
- `q` : Quitter

---

**Dernière mise à jour** : 2025-11-15
**Version de Flutter testée** : 3.4.1+
**Visual Studio testé** : 2022
