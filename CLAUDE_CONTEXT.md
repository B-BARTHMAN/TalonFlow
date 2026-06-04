# TalonFlow — Architecture & Conventions

## What this app does
ER diagram editor in crow's-foot notation. Create diagrams, place entity nodes
on a canvas, define their fields (name, SQL type, constraints, PK), and draw
relations with cardinality, referential actions, and identifying/non-identifying
distinction. In short: visually define a relational schema.

## Platforms
macOS, Windows, Linux, iOS, Android. No web.

## Stack
- **Flutter / Dart 3** (SDK ^3.11.5). Material 3 is the default — don't set
  `useMaterial3`.
- **flutter_bloc** — Cubit for everything; reach for Bloc only if an event
  history genuinely needs tracing.
- **go_router** — plain routes, no shell. Entity detail is a child route.
- **freezed** — immutable models and sealed state unions. Run
  `dart run build_runner build --delete-conflicting-outputs` after changing any
  `@freezed` type.
- **json_serializable** — JSON for the models that persist.
- **very_good_analysis** — strict lints; follow them.

## The big picture
One screen (the editor) hosts a canvas; a drawer lists diagrams. Two cubits own
all UI state and are provided once at the root. Each diagram persists as one
JSON file.

### Layers — strict, one direction
View (widgets)  →  Cubit  →  Repository  →  Service  →  disk
- **View** — widgets/screens. Reads state from a Cubit, calls intent-named Cubit
  methods, and performs side effects (navigation, snackbars) via `BlocListener`.
  No business logic, no I/O.
- **Cubit** — owns one feature's UI-observable state and the intent-named methods
  that change it. Depends only on repositories. Catches errors and turns them
  into states. No `BuildContext`, no setters.
- **Repository** — plain, stateless class. Orchestrates services and generates
  ids (`Id.generate()`). The only thing a Cubit talks to. Forwards/wraps service
  errors.
- **Service** — plain, stateless class. Raw I/O against one source (filesystem).
  Throws on failure.

Only Cubits hold UI-observable state. Repositories and services are stateless.

### State is a sealed union
Each feature's UI-observable state is a Freezed `sealed class` with one variant
per real situation — never a single class with a status enum plus nullable
fields. Impossible states ("loaded but null diagram") become unrepresentable,
and the UI `switch`es exhaustively with no force-unwraps and no wildcard cases.

```dart
@freezed
sealed class DiagramEditorState with _$DiagramEditorState {
  const factory DiagramEditorState.initial() = DiagramEditorInitial;
  const factory DiagramEditorState.loading() = DiagramEditorLoading;
  const factory DiagramEditorState.loaded(Diagram diagram, {String? saveError})
      = DiagramEditorLoaded;
  const factory DiagramEditorState.error(String message) = DiagramEditorError;

  const DiagramEditorState._();

  Diagram? get diagramOrNull => switch (this) {
        DiagramEditorLoaded(:final diagram) => diagram,
        DiagramEditorInitial() ||
        DiagramEditorLoading() ||
        DiagramEditorError() => null,
      };
}
```
Add the `const X._();` private constructor only when a state needs a convenience
getter; keep such getters small and exhaustive. The View switches on the state
itself, destructuring fields (`DiagramEditorLoaded(:final diagram)`).

### Cubit method shape
Methods are intent-named (`openDiagram`, `addEntity`, `renameEntity`) and
one-liners where possible. The real data work lives in pure transforms, so the
Cubit just picks one, emits, and persists:
```dart
Future<void> deleteEntity(String id) => _edit((d) => d.removeEntity(id));
```
`_edit` reads the current diagram, applies the transform, emits the new state
optimistically, then saves.

### Model transforms are pure extensions
Models (`core/models/`) are pure data — Freezed only, no logic. Anything that
*changes* a model is a pure extension that returns a new value and does no I/O.
Editor transforms live in `features/editor/cubit/diagram_edits.dart`:
```dart
extension DiagramEdits on Diagram {
  Diagram removeEntity(String id) => copyWith(
        entities: entities.where((e) => e.id != id).toList(),
        relations: relations
            .where((r) => r.parent.entityId != id && r.child.entityId != id)
            .toList(),
      );
}
```
These are unit-testable without Flutter or bloc.

### Persistence
No SQLite/Drift. One JSON file per diagram under the app documents directory.
`DiagramFileService` does the (fully async) file I/O and throws on error; a
single corrupt file is skipped, not fatal. `DiagramRepository` adds id
generation and convenience (rename = `copyWith` + save).

### Error handling — end to end
Service throws → Repository forwards → Cubit catches and emits a state:
- a load failure becomes an `error` state (the canvas shows the message);
- a *save* failure keeps the diagram on screen but attaches `saveError`, which
  the editor screen surfaces as a snackbar via `BlocListener`. Saves are never
  silently swallowed.

### Provisioning
Both cubits are app-wide, created once in `app.dart` under a `RepositoryProvider`
+ `MultiBlocProvider`. There's one open diagram at a time, so the editor cubit is
effectively a singleton; `closeDiagram()` resets it rather than disposing.

### Routing
`go_router`, plain routes — no `StatefulShellRoute`, no shell scaffold. The
editor is `/`; entity detail is the child route `/entity/:id`, reached with
`context.push`. Push/pop is a View side effect, done in `BlocListener`s.

## Folder structure
lib/
main.dart
app.dart                     # providers + MaterialApp.router
config/
routing/{router,routes}.dart
theme/app_theme.dart
core/
id.dart                    # Id.generate()
models/                    # pure Freezed data
services/                  # raw I/O, throws
repositories/              # orchestration — the Cubit's only dependency
widgets/                   # shared dialogs (ConfirmDialog, NameInputDialog)
features/
<feature>/
cubit/                   # cubit + sealed state (+ pure transforms)
ui/
screens/
widgets/
Current features: `diagrams` (the collection + drawer browser), `editor` (the
open diagram: canvas, entities, fields).

## Data model (`core/models/`)
- **diagram.dart** — `id`, `name`, `List<Entity>`, `List<Relation>`.
- **entity.dart** — `id`, `name`, `x`/`y`, `List<EntityField>`, optional `comment`.
- **entity_field.dart** — `id`, `name`, `FieldType type`, flags (`isPrimaryKey`,
  `isNullable`, `isUnique`, `isAutoIncrement`), optional `defaultValue`/`check`/
  `comment`. FK-ness is derived from relations, never stored.
- **field_type.dart** — sealed union of SQL types; parameterised where it matters
  (`varchar(length)`, `decimal(precision, scale)`, `enumeration(values)`).
  `unionKey: 'type'`, snake-cased values.
- **relation.dart** — `parent`/`child` `RelationEnd`s, `List<FieldLink>`,
  `onDelete`/`onUpdate`, `isIdentifying`, optional `name`; the `Cardinality` and
  `ReferentialAction` enums live here too.

## Rules for Claude — follow without being asked

### Architecture
- Respect the layer direction: View → Cubit → Repository → Service. Never skip a
  layer (no I/O in a widget, no `BuildContext` in a Cubit).
- State is always a sealed Freezed union with explicit variants — never a
  status-enum-plus-nullable-fields. UI switches exhaustively; never force-unwrap
  (`!`) a state field.
- Model-changing logic is a pure extension returning a new value, in the owning
  feature. Models themselves stay logic-free.
- Side effects (navigation, snackbars) belong in the View via `BlocListener`,
  never in a Cubit.

### Code style
- One class per file; keep files small (~50 lines). The only exception is a
  single cohesive control that would get harder to read if split (e.g. the
  field-type picker).
- Freezed 3.x: `abstract class` for single classes, `sealed class` for unions.
- Exhaustive `switch` on unions — never a `default`/wildcard `_`.
- Prefer `const`. Intent-named Cubit methods; no setters.
- Follow very_good_analysis.

### What NOT to do
- No `createdAt`/`updatedAt`/metadata fields, ever, unless asked.
- No fields, params, or abstractions "for later." Build only what's needed now.
- No new layers beyond the four above.
- No `JsonConverter`/`json_key` unless strictly necessary.
- No hardcoded pixels for responsive layout — use theme, fractions, or flex
  (fixed spacing constants are fine).
- Don't add packages or reorganise folders without asking.

### Communication
- Keep explanations short.
- Show the full file when showing code — no "// ... unchanged" elisions.
- For a simple change, say what to change and where; don't reprint the file.
- One file at a time unless I ask for more.
- If something's ambiguous, ask one question; don't guess.