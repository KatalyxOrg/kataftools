# Contributing to Katalyx Flutter Tools

Merci de votre intérêt pour contribuer à **kataftools** ! 🎉

Ce guide vous aidera à contribuer efficacement au projet.

---

## 📋 Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Standards de code](#standards-de-code)
- [Process de développement](#process-de-développement)
- [Tests](#tests)
- [Documentation](#documentation)
- [Pull Requests](#pull-requests)

---

## 🤝 Code de conduite

En participant à ce projet, vous acceptez de maintenir un environnement respectueux et professionnel.

---

## 💡 Comment contribuer

### Signaler un bug

1. Vérifiez qu'il n'existe pas déjà une issue pour ce bug
2. Utilisez le template d'issue "Bug Report"
3. Fournissez un exemple de code minimal pour reproduire
4. Incluez les logs d'erreur et votre environnement

### Proposer une fonctionnalité

1. Ouvrez une issue avec le template "Feature Request"
2. Décrivez clairement le cas d'usage
3. Proposez une API si possible
4. Attendez la discussion avant de développer

### Soumettre du code

1. Fork le repository
2. Créez une branche depuis `master`
3. Développez votre fonctionnalité
4. Soumettez une Pull Request

---

## 📏 Standards de code

### Architecture

Suivez les principes de **Clean Architecture** :

```
lib/
├── src/
│   ├── models/       # Domain entities (freezed)
│   ├── widgets/      # Presentation layer
│   ├── forms/        # Form components
│   ├── dialogs/      # Dialog components
│   └── utils/        # Utilities
└── kataftools.dart   # Public exports
```

### Conventions de nommage

- **Classes** : `PascalCase`
- **Fichiers** : `snake_case.dart`
- **Variables** : `camelCase`
- **Constantes** : `kPascalCase`
- **Membres privés** : `_leadingUnderscore`

### Widgets

````dart
import 'package:flutter/material.dart';

/// Documentation du widget avec description détaillée.
///
/// Exemple d'utilisation :
/// ```dart
/// MyWidget(
///   title: 'Hello',
///   onTap: () => print('Tapped'),
/// )
/// ```
class MyWidget extends StatelessWidget {
  /// Crée un [MyWidget].
  const MyWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  /// Le titre affiché dans le widget.
  final String title;

  /// Callback appelé lors du tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
````

### Bonnes pratiques

✅ **DO** :

- Utiliser `const` partout où possible
- Utiliser `Theme.of(context)` pour les couleurs
- Documenter les APIs publiques
- Écrire des tests pour chaque composant
- Suivre les breakpoints de `ScreenHelper`
- Exporter via `kataftools.dart`

❌ **DON'T** :

- Ne pas hardcoder les couleurs
- Ne pas importer depuis `lib/src/`
- Ne pas ignorer les warnings d'analyse
- Ne pas soumettre de code non formaté
- Ne pas modifier les fichiers générés (.g.dart, .freezed.dart)

---

## 🔧 Process de développement

### 1. Setup initial

```bash
# Fork et clone
git clone https://github.com/VOTRE_USERNAME/kataftools.git
cd kataftools

# Installer les dépendances
flutter pub get

# Générer le code (si nécessaire)
flutter pub run build_runner build
```

### 2. Créer une branche

```bash
git checkout -b feature/ma-nouvelle-fonctionnalite
# ou
git checkout -b fix/mon-bug-fix
```

Conventions de nommage des branches :

- `feature/` - Nouvelles fonctionnalités
- `fix/` - Corrections de bugs
- `docs/` - Documentation
- `refactor/` - Refactoring
- `test/` - Ajout de tests

### 3. Développer

#### Pour un nouveau widget

1. Créer `lib/src/widgets/mon_widget.dart`
2. Implémenter le widget
3. Ajouter l'export dans `lib/kataftools.dart`
4. Créer `test/widgets/mon_widget_test.dart`
5. Écrire les tests

#### Pour un nouveau modèle

1. Créer `lib/src/models/mon_modele/`
2. Créer `mon_modele.dart` avec annotations `@freezed`
3. Générer le code : `flutter pub run build_runner build`
4. Ajouter l'export dans `lib/kataftools.dart`
5. Créer et écrire les tests

### 4. Tests

```bash
# Lancer tous les tests
flutter test

# Tests avec couverture
flutter test --coverage

# Tests spécifiques
flutter test test/widgets/mon_widget_test.dart
```

**Couverture minimale requise** : 85%

### 5. Validation

```bash
# Formatter le code
dart format .

# Analyser le code
flutter analyze

# Vérifier qu'il n'y a pas d'erreurs
flutter analyze --fatal-infos
```

### 6. Commit

Nous utilisons le standard **[Gitmoji](https://gitmoji.dev/)** pour les messages de commit.

```bash
git add .
git commit -m "✨ add new MonthPicker widget"
git commit -m "🐛 correct validation in SearchableDropdown"
git commit -m "📝 update README with new examples"
git commit -m "✅ add tests for LoadingOverlay"
```

**Gitmojis principaux** :

- ✨ `:sparkles:` - Nouvelle fonctionnalité
- 🐛 `:bug:` - Correction de bug
- 📝 `:memo:` - Documentation
- 🎨 `:art:` - Amélioration de la structure/format du code
- ⚡️ `:zap:` - Amélioration des performances
- 🔥 `:fire:` - Suppression de code ou fichiers
- ✅ `:white_check_mark:` - Ajout ou mise à jour de tests
- 🔒️ `:lock:` - Correction de problèmes de sécurité
- ♻️ `:recycle:` - Refactoring du code
- 🚚 `:truck:` - Déplacement ou renommage de fichiers
- 💄 `:lipstick:` - Mise à jour de l'UI/style
- 🔧 `:wrench:` - Modification de fichiers de configuration
- 🚀 `:rocket:` - Déploiement
- 🔖 `:bookmark:` - Release / tags de version
- 🌐 `:globe_with_meridians:` - Internationalisation et localisation
- ♿️ `:wheelchair:` - Amélioration de l'accessibilité
- 💡 `:bulb:` - Ajout ou mise à jour de commentaires dans le code
- 🚧 `:construction:` - Travaux en cours
- ⬆️ `:arrow_up:` - Mise à jour de dépendances
- ⬇️ `:arrow_down:` - Downgrade de dépendances
- 📦️ `:package:` - Mise à jour de fichiers ou packages compilés
- 👷 `:construction_worker:` - Ajout ou mise à jour de CI/CD
- 📈 `:chart_with_upwards_trend:` - Ajout ou mise à jour d'analytics/tracking
- ➕ `:heavy_plus_sign:` - Ajout d'une dépendance
- ➖ `:heavy_minus_sign:` - Suppression d'une dépendance

Consultez [gitmoji.dev](https://gitmoji.dev/) pour la liste complète.

---

## ✅ Tests

### Structure des tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';

void main() {
  group('MyWidget', () {
    testWidgets('displays title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyWidget(title: 'Test Title'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyWidget(
              title: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
```

### Types de tests

1. **Tests unitaires** - Fonctions utilitaires, validateurs
2. **Tests de widgets** - Widgets UI
3. **Tests d'intégration** - Flux complets

### Bonnes pratiques de test

- ✅ Tester tous les cas d'usage
- ✅ Tester les cas limites
- ✅ Tester les erreurs
- ✅ Utiliser des noms descriptifs
- ✅ Un test = un comportement

---

## 📚 Documentation

### Documenter les widgets

````dart
/// Un bouton personnalisé avec icône et label.
///
/// Ce widget combine une icône et un texte dans un bouton
/// qui respecte le thème de l'application.
///
/// Exemple :
/// ```dart
/// IconButton(
///   icon: Icons.save,
///   label: 'Sauvegarder',
///   onPressed: () => save(),
/// )
/// ```
class IconButton extends StatelessWidget {
  /// Crée un [IconButton].
  ///
  /// Le paramètre [icon] et [label] sont requis.
  const IconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  /// L'icône affichée dans le bouton.
  final IconData icon;

  /// Le texte du label.
  final String label;

  /// Callback appelé lors du tap.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
````

### Documenter les fonctions

````dart
/// Parse un nombre au format français.
///
/// Accepte les virgules comme séparateur décimal.
///
/// Retourne `null` si la chaîne n'est pas un nombre valide.
///
/// Exemple :
/// ```dart
/// tryParseFrenchDouble('12,5'); // 12.5
/// tryParseFrenchDouble('abc');  // null
/// ```
double? tryParseFrenchDouble(String? value) {
  if (value == null) return null;
  return double.tryParse(value.replaceAll(',', '.'));
}
````

---

## 🔄 Pull Requests

### Checklist avant soumission

- [ ] Code formaté (`dart format .`)
- [ ] Analyse sans erreurs (`flutter analyze`)
- [ ] Tous les tests passent (`flutter test`)
- [ ] Couverture ≥ 85%
- [ ] Code généré à jour (`build_runner`)
- [ ] Exports ajoutés dans `kataftools.dart`
- [ ] Documentation ajoutée
- [ ] README mis à jour (si nécessaire)

### Template de PR

Utilisez le template automatique qui inclut :

- Description des changements
- Type de changement
- Checklist de validation
- Tests effectués
- Screenshots (si applicable)

### Review process

1. Les tests CI doivent passer (GitHub Actions)
2. Review par au moins 1 mainteneur
3. Approval requis avant merge
4. Merge via "Squash and merge"

### CI/CD

Le workflow GitHub Actions vérifie :

- ✅ Formatage du code
- ✅ Analyse statique
- ✅ Exécution des tests
- ✅ Couverture de code (85% minimum)
- ✅ Upload sur Codecov

---

## 🎯 Priorités actuelles

Consultez les [issues GitHub](https://github.com/KatalyxOrg/kataftools/issues) pour :

- Bugs prioritaires (label `priority: high`)
- Features demandées (label `enhancement`)
- Good first issues (label `good first issue`)

---

## ❓ Questions

Si vous avez des questions :

1. Consultez la [documentation](README.md)
2. Cherchez dans les [issues existantes](https://github.com/KatalyxOrg/kataftools/issues)
3. Ouvrez une nouvelle issue si nécessaire

---

## 📞 Contact

**Katalyx**  
Email: contact@katalyx.fr  
GitHub: [@KatalyxOrg](https://github.com/KatalyxOrg)

---

Merci de contribuer à **kataftools** ! 🚀
