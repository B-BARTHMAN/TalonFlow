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

Follows [Flutter's official app architecture guide](https://docs.flutter.dev/app-architecture/guide),
with Cubit replacing ViewModel.

### Layers

```
UI (View + Cubit)  →  Repository  →  Service
```

- **View** — widgets and screens. Reads state from a Cubit, calls Cubit methods. No logic.
- **Cubit** — feature state and the methods that change it. Depends on repositories only.
- **Repository** — plain class. Orchestrates services. The only thing Cubits talk to.
- **Service** — plain class. Raw I/O against one source (filesystem). Throws on error.

Only Cubits hold UI-observable state. Repositories and services are stateless plain classes.

### Error handling
Services throw. Repositories catch and rethrow (or wrap when needed). Cubits catch and emit error states.

### Cubit scope
- **App-wide** — provided once at the app root via `BlocProvider`. State that must outlive any single screen.
  - `DiagramListCubit`
- **Feature-scoped** — provided at the screen level, disposed on pop.
  - `DiagramEditorCubit`

Repositories are always app-wide via `RepositoryProvider`. They have no state, only methods.

### Folder structure

```
lib/
  main.dart
  app.dart
  config/
    routing/
    theme/
  core/
    models/          # Freezed data classes shared across features
    services/        # Raw I/O — one source per service
    repositories/    # Orchestration — what Cubits depend on
    errors/          # Failure sealed class (add when needed)
    widgets/         # Shared UI widgets
  features/
    <feature>/
      cubit/
      ui/
        screens/
        widgets/
```

### Data flow

```
JSON file on disk
  ↕  (DiagramFileService: load/save)
DiagramRepository
  ↕  (exposes clean API, handles errors)
Cubit (holds current state, exposes intent-named methods)
  ↕
UI (reads state, calls cubit methods)
```

## Data model (`lib/core/models/`)
Five files, all Freezed 3.x with `json_serializable`:

- **`diagram.dart`** — `id`, `name`, `List<Entity>`, `List<Relation>`
- **`entity.dart`** — `id`, `name`, `x`/`y` (canvas pos), `List<EntityField>`,
  optional `comment`
- **`entity_field.dart`** — `id`, `name`, `FieldType type`, plus flags:
  `isPrimaryKey`, `isNullable`, `isUnique`, `isAutoIncrement`, and optional
  `defaultValue`, `check`, `comment`. FK-ness is derived from relations.
- **`field_type.dart`** — sealed union of SQL types. Parameterised where it
  matters: `varchar(length)`, `decimal(precision, scale)`,
  `enumeration(values)`. Serialized with `unionKey: 'type'`, `unionValueCase: FreezedUnionCase.snake`.
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
- **Simple changes** — state what to add and where, no need to reprint the whole file.

### Code style
- One class per file, keep files small.
- Use Freezed 3.x syntax (`abstract class` / `sealed class`, not bare `class`).
- Exhaustive `switch` on sealed unions — never use a default/wildcard case.
- Follow very_good_analysis lint rules.
- Prefer `const` constructors.
- Cubits expose intent-named methods (`loadDiagrams()`, `addDiagram(...)`). No setters, no `BuildContext`.
- Side effects (navigation, snackbars) are the View's job via `BlocListener`.

### What NOT to do
- No `createdAt` / `updatedAt` / `modifiedBy` or any metadata fields unless
  explicitly asked. This is a local-only app.
- No fields "that might be useful later" — only what's needed right now.
- No `json_key`, no `JsonConverter` unless strictly necessary.
- No hardcoded pixel values for layout — use theme, fractions, or flex.
- No over-engineered abstractions beyond the three-layer architecture above.
- Don't suggest adding packages I haven't approved.
- Don't reorganize my folder structure without asking.

### Communication
- Keep explanations short. If I need more detail I'll ask.
- When showing code, show the full file — no "// ... rest unchanged" elisions.
- Simple changes: state what to add/change and where, skip reprinting the file.
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
    services/        # next: diagram_file_service.dart
    repositories/    # next: diagram_repository.dart
  features/
    home/
      ui/
        screens/
          home_screen.dart
    sidebar/
      ui/
        widgets/
          diagram_list.dart
          sidebar.dart
          sidebar_card.dart
          sidebar_footer.dart
          sidebar_header.dart
```