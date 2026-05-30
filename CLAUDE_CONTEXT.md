# TalonFlow — Project Context

## What this app does
ER diagram editor in crow's foot notation. You create diagrams, place entity
nodes on a canvas, define their fields (name, type, constraints, PK, etc.),
and draw relations between them with cardinality, referential actions, and
identifying/non-identifying distinction. Basically: visually define a
relational database schema.

## Platforms
macOS, Windows, Linux, iOS, Android. No web.

## Stack
- **Flutter / Dart 3** (SDK ^3.11.5)
- **flutter_bloc** — Cubit for simple state, Bloc for complex (prefer Cubit
  when there's no meaningful event history to trace)
- **go_router** — routing, StatefulShellRoute for the shell scaffold
- **freezed + freezed_annotation** — immutable data classes. Freezed 3.x
  syntax: `abstract class` for single classes, `sealed class` for unions.
  Run `dart run build_runner build --delete-conflicting-outputs` after changes.
- **json_serializable** — for serializing Freezed models to/from JSON
- **very_good_analysis** — strict linting, follow it
- **Material 3** — use default M3 widgets, no custom design system

## Persistence
**No Drift / no SQLite.** Each diagram is a single JSON file saved via
`path_provider`. The in-memory state is a `Diagram` object; save = serialize
to JSON file, load = deserialize from JSON file. Keep it simple.

## Architecture

### Folder structure
```
lib/
  app.dart
  main.dart
  config/
    routing/
    theme/
  core/
    models/          # Freezed data classes (shared across features)
    services/        # File I/O, serialization
  features/
    <feature>/
      ui/
        screens/
        widgets/
      bloc/          # or cubit/
```

### Data flow
```
JSON file on disk
  ↕  (service: load/save)
Diagram model (immutable Freezed object)
  ↕  (Cubit/Bloc: holds current diagram, exposes mutations)
UI (reads state, calls cubit methods)
```

No repository layer — there's no database to abstract over. A simple
`DiagramFileService` handles reading/writing JSON files.

### IDs
UUID v4 strings (use the `uuid` package). Generated client-side when creating
entities, fields, or relations.

## Data model (lib/core/models/)
Five files, all Freezed 3.x:

- **`diagram.dart`** — `id`, `name`, `List<Entity>`, `List<Relation>`
- **`entity.dart`** — `id`, `name`, `x`/`y` (canvas pos), `List<EntityField>`,
  optional `comment`
- **`entity_field.dart`** — `id`, `name`, `FieldType type`, plus flags:
  `isPrimaryKey`, `isNullable`, `isUnique`, `isAutoIncrement`, and optional
  `defaultValue`, `check`, `comment`. FK-ness is derived from relations.
- **`field_type.dart`** — sealed union of SQL types. Parameterised where it
  matters: `varchar(length)`, `decimal(precision, scale)`,
  `enumeration(values)`.
- **`relation.dart`** — `parent` and `child` `RelationEnd`s (each with
  `entityId` + `Cardinality`), `List<FieldLink>` for FK column mapping,
  `onDelete`/`onUpdate` `ReferentialAction`, `isIdentifying`, optional `name`.
  Enums for `Cardinality` and `ReferentialAction` live in this file too.

## UX decisions
- **Sidebar** — collapsible, lists diagrams. Create / rename / delete / select.
- **Canvas** — `InteractiveViewer` with draggable entity nodes and relation
  connectors drawn between them.
- **Editing an entity** — tap it on canvas → navigates to a detail page
  (via go_router) where you edit fields, types, constraints.
- **Export** — SQL DDL (`CREATE TABLE` statements) is the priority export.
  PNG/SVG maybe later.

## Rules for Claude — follow without being asked

### Scoping
- **One file at a time.** Never dump a whole feature. I'll ask for the next
  file when I'm ready.

### Code style
- One class per file, keep files small.
- Use Freezed 3.x syntax (`abstract class` / `sealed class`, not bare `class`).
- Exhaustive `switch` on sealed unions — never use a default/wildcard case.
- Follow very_good_analysis lint rules.
- Prefer `const` constructors.

### What NOT to do
- No `createdAt` / `updatedAt` / `modifiedBy` or any metadata fields unless I
  explicitly ask. This is a local-only app.
- No fields "that might be useful later" — only what's needed right now.
- No `json_key`, no `JsonConverter` unless strictly necessary.
- No hardcoded pixel values for layout — use theme, fractions, or flex.
- No over-engineered abstractions (no repository pattern wrapping a single
  file read, no dependency injection framework).
- Don't suggest adding packages I haven't approved.
- Don't reorganize my folder structure without asking.

### Communication
- Keep explanations short. If I need more detail I'll ask.
- When showing code, show the full file — no "// ... rest unchanged" elisions.
- If something is ambiguous, ask one question, don't guess.

## Current file tree
```
lib/
  app.dart
  main.dart
  config/
    routing/
      router.dart
      routes.dart
      shell.dart
    theme/
      app_theme.dart
  core/
    models/
      diagram.dart
      entity.dart
      entity_field.dart
      field_type.dart
      relation.dart
  features/
    home/
      ui/
        screens/
          home_screen.dart
        widgets/
          sidebar.dart
```