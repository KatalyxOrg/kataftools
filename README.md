# 🛠️ Katalyx Flutter Tools (kataftools)

**Le package de référence pour vos applications Flutter chez Katalyx**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.6+-02569B?style=flat&logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?style=flat&logo=dart)](https://dart.dev/)
[![Tests](https://github.com/KatalyxOrg/kataftools/actions/workflows/test.yml/badge.svg)](https://github.com/KatalyxOrg/kataftools/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/KatalyxOrg/kataftools/branch/master/graph/badge.svg)](https://codecov.io/gh/KatalyxOrg/kataftools)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## 📖 À propos

**Katalyx Flutter Tools** est le package fondamental pour tous les projets Flutter développés chez Katalyx. Il fournit des widgets réutilisables, des utilitaires, des composants de formulaires et des modèles de données suivant les principes de Clean Architecture.

### 🏢 Katalyx

Chez Katalyx, nous aidons les entreprises B2B à transformer leur écosystème digital en moteur de croissance.

Nous ne sommes pas une agence d'exécution : nous sommes votre partenaire stratégique, capable de concevoir, structurer et piloter votre performance digitale à chaque étape.

---

## ✨ Fonctionnalités

### 🎨 Widgets réutilisables

- ✅ `LoadingOverlay` - Indicateur de chargement global
- ✅ `ErrorSnackbar` / `SuccessSnackbar` - Notifications utilisateur
- ✅ `MonthSelector` - Sélecteur de mois avec navigation

### 📝 Composants de formulaires

- ✅ `SearchableDropdown<T>` - Dropdown avec recherche et création
- ✅ `ImageInput` / `ImageInputRound` - Upload d'images avec validation
- ✅ `DocumentInput` - Upload de documents PDF
- ✅ `FormSection` - Sections de formulaires responsive
- ✅ `FormLayout` - Layout cohérent pour les formulaires
- ✅ `CheckboxBadge` - Badges cliquables pour sélection multiple

### ✔️ Validation de formulaires

- ✅ `FormValidator` - Validateurs réutilisables
  - Email, téléphone, nombres, entiers
  - Champs requis avec messages personnalisés
  - Support de `phone_form_field` pour validation téléphone

### 📊 Modèles de données

- ✅ `PageInfo` - Informations de pagination
- ✅ `PageCursor<T>` - Curseurs génériques pour pagination Relay
- ✅ `PaginatedObject<T>` - Conteneur d'objets paginés
- ✅ Utilisation de `freezed` pour immutabilité
- ✅ Sérialisation JSON avec `json_serializable`

### 🎯 Utilitaires

- ✅ `ScreenHelper` - Breakpoints responsive (mobile/tablet/desktop)
- ✅ Extensions de chaînes (`StringExtension`)
- ✅ Gestion des permissions
- ✅ Constantes globales
- ✅ Sérialiseurs personnalisés (dates)
- ✅ Clipboard HTML (web)

### 🎭 Dialogs

- ✅ `ClosableDialog` - Dialog de base avec fermeture
- ✅ `ConfirmationDialog` - Dialog de confirmation avec validation/annulation
- ✅ `SizeLimitDialog` - Dialog d'avertissement pour fichiers trop volumineux
- ✅ `DialogHeader` - En-tête standardisé

---

## 🏗️ Architecture

```
lib/
├── kataftools.dart               # Exports publics
└── src/
    ├── models/                   # Modèles de données
    │   ├── page_info/           # PageInfo (freezed)
    │   ├── page_cursor/         # PageCursor<T> (freezed)
    │   └── paginated_object/    # PaginatedObject<T>
    ├── widgets/                  # Widgets réutilisables
    │   ├── error_snackbar.dart
    │   ├── success_snackbar.dart
    │   ├── loading_overlay.dart
    │   └── month_selector.dart
    ├── forms/                    # Composants de formulaires
    │   ├── searchable_dropdown.dart
    │   ├── image_input.dart
    │   ├── image_input_round.dart
    │   ├── document_input.dart
    │   ├── form_section.dart
    │   ├── form_layout.dart
    │   ├── form_large_field.dart
    │   └── badges/
    │       └── checkbox_badge.dart
    ├── dialogs/                  # Composants de dialogs
    │   ├── closable_dialog.dart
    │   ├── confirmation_dialog.dart
    │   ├── size_limit_dialog.dart
    │   └── dialog_header.dart
    ├── clipboard/                # Utilitaires clipboard
    │   ├── html_clipboard.dart
    │   └── html_clipboard_stub.dart
    ├── utils.dart                # Fonctions utilitaires
    ├── dates.dart                # Utilitaires de dates
    ├── constants.dart            # Constantes globales
    ├── permission.dart           # Gestion des permissions
    ├── form_validator.dart       # Validateurs de formulaires
    ├── serializers.dart          # Sérialiseurs personnalisés
    └── screen_helper.dart        # Helper responsive
```

### Principes architecturaux

- **Clean Architecture** : Séparation domaine/présentation/infrastructure
- **Widgets stateless** : Performance optimale avec `const`
- **Généricité** : Types génériques (`PageCursor<T>`, `SearchableDropdown<T>`)
- **Immutabilité** : Modèles `freezed` pour sécurité
- **Responsive** : Breakpoints cohérents (mobile/tablet/desktop)
- **Thème** : Intégration Material Design 3

---

## 🚀 Démarrage rapide

### Installation

Ajoutez à votre pubspec.yaml :

```yaml
dependencies:
  kataftools:
    path: ../kataftools # Ou votre chemin vers le package
```

Puis :

```bash
flutter pub get
```

### Utilisation de base

```dart
import 'package:kataftools/kataftools.dart';

// ✅ Snackbar d'erreur
ErrorSnackbar.show(context, "Une erreur est survenue");

// ✅ Snackbar de succès
SuccessSnackbar.show(context, "Opération réussie");

// ✅ Validation de formulaire
TextFormField(
  validator: FormValidator.emailValidator,
  decoration: const InputDecoration(labelText: "Email"),
)

// ✅ Dropdown avec recherche
SearchableDropdown<User>(
  label: "Utilisateur",
  optionsBuilder: (text) async => await fetchUsers(text.text),
  displayStringForOption: (user) => user.name,
  onSelected: (user) => setState(() => selectedUser = user),
)
```

---

## 📚 Documentation détaillée

### 🎨 Widgets

#### LoadingOverlay

Affiche un indicateur de chargement global sur toute l'application.

```dart
// Wrapper votre app
MaterialApp(
  home: LoadingOverlay(
    child: MyHomePage(),
  ),
)

// Afficher/masquer
LoadingOverlay.of(context).show();
LoadingOverlay.of(context).hide();
```

#### MonthSelector

Sélecteur de mois avec navigation et dropdown.

```dart
MonthSelector(
  selectedMonth: DateTime(2025, 1),
  onMonthSelected: (newMonth) {
    setState(() => currentMonth = newMonth);
  },
)
```

---

### 📝 Formulaires

#### SearchableDropdown

Dropdown générique avec recherche et création optionnelle.

```dart
SearchableDropdown<Product>(
  label: "Produit",
  isRequired: true,
  value: currentProduct,
  optionsBuilder: (text) async {
    final results = await searchProducts(text.text);
    return results;
  },
  displayStringForOption: (product) => product.name,
  onSelected: (product) {
    setState(() => selectedProduct = product);
  },
  onCreate: (name) async {
    final newProduct = await createProduct(name);
    setState(() => selectedProduct = newProduct);
  },
  fakeOnCreate: (name) => Product(id: 0, name: name),
)
```

**Paramètres** :

- `optionsBuilder` : Fonction async retournant les options
- `displayStringForOption` : Conversion objet → texte
- `onSelected` : Callback de sélection
- `onCreate` : Callback de création (optionnel)
- `fakeOnCreate` : Factory pour option "Créer..." (requis si `onCreate`)
- `isRequired` : Validation requise
- `shouldResetOnTap` : Réinitialiser au focus

---

#### ImageInput / ImageInputRound

Upload d'images avec prévisualisation.

```dart
// Rectangulaire
ImageInput(
  networkImageUrl: user.avatarUrl,
  imageFile: newAvatar,
  onChanged: (imageFile) {
    setState(() => newAvatar = imageFile);
  },
  height: 217,
)

// Circulaire
ImageInputRound(
  networkImageUrl: user.avatarUrl,
  imageFile: newAvatar,
  onChanged: (imageFile) {
    setState(() => newAvatar = imageFile);
  },
  size: 92,
)
```

**Validation** : Limite de 5 Mo, affiche `SizeLimitDialog` si dépassée.

---

#### FormSection

Section de formulaire responsive (2 colonnes sur desktop/tablet, 1 colonne sur mobile).

```dart
FormSection(
  title: "Informations personnelles",
  isSmall: false,
  actions: [
    IconButton(icon: Icon(Icons.help), onPressed: () {}),
  ],
  children: [
    TextFormField(
      decoration: InputDecoration(labelText: "Prénom"),
    ),
    TextFormField(
      decoration: InputDecoration(labelText: "Nom"),
    ),
    FormLargeField( // Prend toute la largeur
      child: TextFormField(
        decoration: InputDecoration(labelText: "Adresse"),
      ),
    ),
  ],
)
```

**Breakpoints** :

- Desktop : > 768px (2 colonnes)
- Tablet : 481px - 768px (2 colonnes)
- Mobile : < 481px (1 colonne)

---

#### FormValidator

Validateurs prêts à l'emploi.

```dart
TextFormField(
  validator: FormValidator.emailValidator, // Email valide
)

TextFormField(
  validator: (value) => FormValidator.requiredValidator(value), // Requis
)

TextFormField(
  validator: (value) => FormValidator.numberValidator(value, isRequired: true), // Nombre
)

PhoneFormField(
  validator: (value) => FormValidator.phoneValidator(value, isRequired: true),
)
```

**Validateurs disponibles** :

- `emailValidator` - Email RFC valide
- `phoneValidator` - Téléphone international
- `numberValidator` - Nombre décimal (français)
- `intValidator` - Entier
- `requiredValidator` - Champ non vide
- `requiredDateValidator` - Date non nulle

---

### 🎭 Dialogs

#### ConfirmationDialog

Dialog de confirmation avec action destructive optionnelle.

```dart
// Confirmation standard
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => ConfirmationDialog(
    title: "Sauvegarder les modifications ?",
    content: "Voulez-vous enregistrer les changements ?",
    validationButtonLabel: "Sauvegarder",
  ),
);

if (confirmed == true) {
  // Sauvegarder
}

// Confirmation de suppression (bouton rouge)
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => ConfirmationDialog(
    title: "Supprimer l'utilisateur",
    content: "Cette action est irréversible.",
    isDeletationConfirmation: true,
  ),
);
```

---

### 📊 Modèles de données

#### Pagination Relay-style

```dart
// Modèle de page
@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required bool hasNextPage,
    required String endCursor,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, Object?> json) =>
    _$PageInfoFromJson(json);
}

// Curseur générique
@Freezed(genericArgumentFactories: true)
class PageCursor<T> with _$PageCursor<T> {
  const factory PageCursor({
    required String cursor,
    required T node,
  }) = _PageCursor;

  factory PageCursor.fromJson(
    Map<String, Object?> json,
    T Function(Object?) fromJsonT,
  ) => _$PageCursorFromJson(json, fromJsonT);
}

// Objet paginé
class PaginatedObject<T> {
  final List<PageCursor<T>> edges;
  final PageInfo? pageInfo;

  PaginatedObject({required this.edges, this.pageInfo});

  factory PaginatedObject.fromJson(
    Map<String, Object?> json,
    T Function(Object?) fromJsonT,
  ) {
    return PaginatedObject(
      edges: (json['edges'] as List)
          .map((e) => PageCursor.fromJson(e, fromJsonT))
          .toList(),
      pageInfo: json['pageInfo'] != null
          ? PageInfo.fromJson(json['pageInfo'] as Map<String, Object?>)
          : null,
    );
  }
}
```

**Utilisation** :

```dart
// Désérialisation GraphQL
final data = PaginatedObject<User>.fromJson(
  response['users'],
  (json) => User.fromJson(json as Map<String, Object?>),
);

// Itération
for (final edge in data.edges) {
  print(edge.node.name);
}

// Pagination
if (data.pageInfo?.hasNextPage == true) {
  fetchMore(cursor: data.pageInfo!.endCursor);
}
```

---

### 🎯 Utilitaires

#### ScreenHelper

Gestion des breakpoints responsive.

```dart
// Initialisation (dans build)
void didChangeDependencies() {
  super.didChangeDependencies();
  ScreenHelper.instance.setValues(MediaQuery.of(context).size.width);
}

// Utilisation
final isMobile = ScreenHelper.instance.isMobile;
final padding = ScreenHelper.instance.horizontalPadding;

// Breakpoints
if (width > ScreenHelper.breakpointPC) {
  // Desktop : > 768px
} else if (width > ScreenHelper.breakpointTablet) {
  // Tablet : 481px - 768px
} else {
  // Mobile : < 481px
}
```

#### Extensions de chaînes

```dart
import 'package:kataftools/kataftools.dart';

// Capitalisation
"bonjour".capitalize(); // "Bonjour"

// Parsing nombres français
tryParseFrenchDouble("12,5"); // 12.5
tryParseFrenchDouble("1 234,56"); // 1234.56
```

---

## 🎨 Thèmes

Tous les widgets utilisent `Theme.of(context)` pour respecter le thème de l'application.

```dart
// Exemple de thème
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 16),
  ),
)
```

Les widgets s'adaptent automatiquement aux thèmes **light** et **dark**.

---

## 🧪 Tests

```bash
# Lancer les tests
flutter test

# Avec couverture
flutter test --coverage
```

**Structure de tests** :

```
test/
├── kataftools_test.dart          # Point d'entrée
├── models/
│   └── page_info_test.dart
├── widgets/
│   └── error_snackbar_test.dart
└── forms/
    └── form_validator_test.dart
```

---

## 🔧 Génération de code

Pour les modèles `freezed` et `json_serializable` :

```bash
# Générer une fois
flutter pub run build_runner build

# Watch mode (régénération automatique)
flutter pub run build_runner watch

# Forcer la régénération
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🤝 Contribution

### Workflow

1. Créer une branche : `git checkout -b feature/nouveau-widget`
2. Développer en suivant les conventions
3. Ajouter des tests
4. Générer le code : `flutter pub run build_runner build`
5. Exporter dans `kataftools.dart`
6. Formater : `dart format .`
7. Analyser : `flutter analyze`
8. Commit et push
9. Créer une Pull Request

### Checklist avant commit

- [ ] Code formaté (`dart format .`)
- [ ] Pas d'erreurs d'analyse (`flutter analyze`)
- [ ] Tests passent (`flutter test`)
- [ ] Code généré à jour (`build_runner`)
- [ ] Exports ajoutés dans kataftools.dart
- [ ] Documentation ajoutée

---

## 📊 Stack technique

| Composant                | Package           | Version |
| ------------------------ | ----------------- | ------- |
| **Framework**            | Flutter           | 3.35.6+ |
| **Langage**              | Dart              | 3.9.2+  |
| **Immutabilité**         | freezed           | 3.2.3   |
| **JSON**                 | json_serializable | 6.11.1  |
| **Formulaires**          | phone_form_field  | 10.0.12 |
| **Fichiers**             | file_picker       | 10.3.3  |
| **Internationalisation** | intl              | 0.20.2  |
| **Linting**              | flutter_lints     | 5.0.0   |

---

## 📝 Conventions

### Nommage

- **Classes** : `PascalCase` (`LoadingOverlay`, `FormValidator`)
- **Fichiers** : `snake_case.dart` (`loading_overlay.dart`)
- **Variables** : `camelCase` (`selectedUser`)
- **Constantes** : `kPascalCase` (`kMaxFileSize`)

### Structure de fichiers

```dart
import 'package:flutter/material.dart';

/// Documentation du widget
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

### Exports

**❌ Mauvais** :

```dart
import 'package:kataftools/src/utils.dart';
```

**✅ Bon** :

```dart
import 'package:kataftools/kataftools.dart';
```

---

## 🛡️ Bonnes pratiques

### Performance

- ✅ `const` partout où possible
- ✅ `ListView.builder` pour listes longues
- ✅ Éviter `setState` global
- ✅ Optimiser les images (compression, cache)

### Accessibilité

- ✅ Contraste suffisant
- ✅ Labels pour les formulaires
- ✅ Taille tactile minimale (44x44)
- ✅ Support clavier/lecteur d'écran

### Sécurité

- ✅ Validation côté client ET serveur
- ✅ Limite de taille fichiers (5 Mo)
- ✅ Sanitisation des entrées utilisateur
- ✅ Gestion des erreurs réseau

---

## 🆘 Support

### Documentation

- Instructions Copilot complètes
- Exemples dans le code source

### Questions fréquentes

**Q : Comment personnaliser les validateurs ?**

> R : Créez vos propres fonctions de validation en suivant le pattern de `FormValidator` :

```dart
static String? customValidator(String? value) {
  if (value == null || value.isEmpty) return "Champ requis";
  if (!myCustomCheck(value)) return "Format invalide";
  return null;
}
```

**Q : Comment ajouter un nouveau widget ?**

> R : Créez un fichier dans widgets, implémentez le widget, ajoutez l'export dans kataftools.dart, écrivez les tests dans `test/widgets/`.

**Q : Les images ne s'affichent pas sur Web**

> R : Vérifiez les CORS de votre backend. Pour les images locales, utilisez `Image.asset()` au lieu de `Image.network()`.

---

## 🎓 Ressources d'apprentissage

- [Documentation Flutter officielle](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Freezed documentation](https://pub.dev/packages/freezed)
- [GORM documentation](https://pub.dev/packages/json_serializable)
- [Clean Architecture Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

---

## 🚀 Roadmap

### Phase 1 : Fondations ✅

- [x] Widgets de base (Snackbar, Loading, MonthSelector)
- [x] Formulaires (SearchableDropdown, ImageInput, Validation)
- [x] Dialogs (Closable, Confirmation, SizeLimit)
- [x] Modèles de pagination (Relay-style)
- [x] Utilitaires (ScreenHelper, Extensions)

### Phase 2 : En cours

- [ ] Tests unitaires (widgets)
- [ ] Tests d'intégration (formulaires)
- [ ] Composants de tableaux
- [ ] Graphiques/charts

### Phase 3 : Prévu

- [ ] Animations avancées
- [ ] Composants de navigation
- [ ] Templates de pages
- [ ] Support i18n complet
- [ ] Composants de calendrier

---

## 👥 Équipe

Développé et maintenu par **Katalyx**.

**Contact** : [contact@katalyx.fr](mailto:contact@katalyx.fr)

---

<div align="center">

**Documentation** • **Exemples** • **Tests**

Made with ❤️ by Katalyx

</div>
