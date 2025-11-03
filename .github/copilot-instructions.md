# Katalyx Flutter Tools - Copilot Agent Instructions

## Project Overview

This is `kataftools`, a Flutter package providing core utilities, widgets, forms, and models for Katalyx Flutter applications. It serves as a foundation package for all Katalyx Flutter projects, promoting code reuse and consistent architecture.

## Architecture Principles

### Clean Architecture

This package follows Flutter Clean Architecture principles:

1. **Separation of Concerns**: Code is organized by feature and responsibility
2. **Dependency Rule**: Dependencies point inward (infrastructure → domain)
3. **Independent of Frameworks**: Core business logic is framework-agnostic
4. **Testable**: All components should be unit testable
5. **Independent of UI**: Business logic is separate from presentation

### Package Structure

```
lib/
├── src/
│   ├── models/          # Data models (domain entities)
│   ├── widgets/         # Reusable UI components
│   ├── forms/           # Form-related widgets and utilities
│   ├── dialogs/         # Dialog components
│   ├── clipboard/       # Platform-specific utilities
│   ├── utils.dart       # Utility functions
│   ├── constants.dart   # App constants
│   ├── permission.dart  # Permission management
│   └── ...
└── kataftools.dart      # Public API exports
```

## Code Guidelines

### 1. Model Layer

- Use `freezed` for immutable data classes (`PageInfo`, `PageCursor`)
- Use `json_serializable` for JSON serialization
- Keep models in `lib/src/models/<model_name>/` directory
- Include `.dart`, `.freezed.dart`, and `.g.dart` files

**Example:**

```dart
@freezed
abstract class PageInfo with _$PageInfo {
  const factory PageInfo({
    required bool hasNextPage,
    required String endCursor,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, Object?> json) =>
    _$PageInfoFromJson(json);
}
```

### 2. Widget Layer

- Create stateless widgets when possible
- Use `const` constructors for better performance
- Follow Material Design 3 guidelines
- Widgets should be reusable and configurable

**Widget Naming:**

- Descriptive names: `LoadingOverlay`, `ErrorSnackbar`
- Use `Dialog` suffix for dialogs: `ConfirmationDialog`
- Use `Input` suffix for form inputs: `ImageInput`

### 3. Form Components

- Use `TextFormField` with validators
- Implement `FormValidator` for common validation rules
- Support required/optional fields
- Provide clear error messages
- Use `FormSection` and `FormLayout` for consistent layouts

### 4. Utilities

- Group related utilities in separate files
- Use extensions for enhancing existing types (`StringExtension` in utils.dart)
- Keep platform-specific code isolated (see `html_clipboard.dart` pattern)

### 5. Responsive Design

- Use `ScreenHelper` for responsive breakpoints
- Support mobile, tablet, and desktop layouts
- Define breakpoints as constants:
  - Mobile: < 481px
  - Tablet: 481px - 768px
  - Desktop: > 768px

### 6. Theme Integration

- Always use `Theme.of(context)` for colors and text styles
- Support both light and dark themes
- Use `colorScheme` properties instead of hardcoded colors

**Example:**

```dart
Text(
  message,
  style: TextStyle(
    color: Theme.of(context).colorScheme.onErrorContainer
  ),
)
```

### 7. State Management

- Use `StatefulWidget` only when necessary
- Prefer callback functions for state changes
- Use `setState` for local UI state
- Pass data down through constructor parameters

### 8. File Organization

- One widget per file (unless tightly coupled)
- Match file name to class name in snake_case
- Place related files in subdirectories
- Use part files for generated code

### 9. Error Handling

- Provide user-friendly error messages
- Use `ErrorSnackbar` and `SuccessSnackbar` for notifications
- Validate user input before processing
- Handle null values gracefully

### 10. Performance

- Use `const` constructors everywhere possible
- Avoid rebuilding widgets unnecessarily
- Use `ListView.builder` for long lists
- Optimize images (5MB limit in `ImageInput`)

## Code Style

### Naming Conventions

- Classes: `PascalCase`
- Files: `snake_case.dart`
- Variables/functions: `camelCase`
- Constants: `kPascalCase` (see `constants.dart`)
- Private members: `_leadingUnderscore`

### Documentation

- Add doc comments for public APIs
- Explain non-obvious implementation details
- Document parameters and return values
- Include usage examples for complex widgets

### Formatting

- Use `dart format` for code formatting
- Follow analysis_options.yaml linting rules
- Keep line length under 120 characters
- Use trailing commas for better diffs

## Common Patterns

### 1. Platform-Specific Code

Use conditional imports for platform-specific implementations:

```dart
import 'html_clipboard_stub.dart'
  if (dart.library.html) 'html_clipboard_web.dart' as impl;
```

### 2. Dialog Pattern

```dart
showDialog(
  context: context,
  builder: (context) => ConfirmationDialog(
    title: "Confirm Action",
    onConfirm: () {
      // Handle confirmation
    },
  ),
);
```

### 3. Snackbar Notifications

```dart
ErrorSnackbar.show(context, "Error message");
SuccessSnackbar.show(context, "Success message");
```

### 4. Loading States

```dart
LoadingOverlay(
  child: YourContent(),
)
// Access via:
LoadingOverlay.of(context).show();
LoadingOverlay.of(context).hide();
```

### 5. Form Validation

```dart
TextFormField(
  validator: FormValidator.emailValidator,
  // or
  validator: (value) =>
    FormValidator.requiredValidator(value),
)
```

## Testing

- Write unit tests for utilities and validators
- Write widget tests for UI components
- Mock external dependencies
- Test edge cases and error conditions
- Aim for high code coverage

## Dependencies

Core dependencies (from pubspec.yaml):

- `flutter`: Framework
- `freezed_annotation`: Immutable models
- `json_annotation`: JSON serialization
- `file_picker`: File selection
- `intl`: Internationalization
- `phone_form_field`: Phone number input

## Export Strategy

All public APIs are exported through kataftools.dart. Never import from internal files directly.

```dart
// ✅ Correct
import 'package:kataftools/kataftools.dart';

// ❌ Wrong
import 'package:kataftools/src/utils.dart';
```

## When Adding New Features

1. Determine the appropriate category (widget, form, dialog, utility, model)
2. Create files in the correct directory structure
3. Follow existing patterns and naming conventions
4. Add exports to kataftools.dart
5. Write tests
6. Update documentation
7. Ensure code passes `flutter analyze`

## Questions to Ask Before Implementation

1. Is this feature reusable across multiple Katalyx projects?
2. Does it follow Flutter best practices?
3. Is it properly documented?
4. Does it support theming and responsiveness?
5. Are there similar widgets/utilities already in the package?
6. Does it handle errors gracefully?
7. Is it accessible and user-friendly?

---

**Remember**: This package is the foundation for all Katalyx Flutter applications. Maintain high code quality, consistency, and documentation standards.
