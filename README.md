# Pat The Ice Fairy

Recovered source for **Pat The Ice Fairy**, a Touhou-themed Godot game originally distributed
as a single Windows executable. This repository contains the decompiled GDScript source,
scenes, and project configuration — assets are intentionally excluded (see
[What's in the repo](#whats-in-the-repo)).

| | |
|---|---|
| Engine | Godot **3.2.4** (stable) |
| Original build | `PatTheIceFairy64.exe` (47.6 MB, PCK embedded) |
| Main scene | `res://Scenes/UI/Splash.tscn` |
| Display | 1440×1080, GLES2, 2D stretch `keep_height` |
| Physics layers | 2 = `cirno`, 3 = `hand` |
| Autoloads | `SceneManager`, `Globals`, `MusicManager`, `AudioManager` |
| Files in original PCK | 311 |

## How this was recovered

The original `.gde` script files were compiled GDScript encrypted with AES-256, the standard
Godot script encryption. GDRE Tools cannot decompile them without the key, and the key is
baked into the export template binary at compile time (see `core/SCsub` → `script_encryption_key`),
so it is not present as a readable string anywhere in the executable.

The key was recovered by scanning every 32-byte window of the executable's `.data` and
`.rdata` sections and attempting an AES-256-ECB decrypt of a known `.gde` header block
(the plaintext starts with the `GDSC` bytecode magic). The single matching window was
confirmed against the stored MD5 of the decrypted file:

```
9a518733893f23c71ce521f5c4623fb749721b026f84eae86fe59e10a39abd26
```

With that key, GDRE Tools v2.6.4 recovered all **12 scripts** plus 311 files total.
The scripts in this repo are the decompiled GDScript output — they are plain text and no
longer depend on the encryption key.

## What's in the repo

Tracked (60 files, ~173 KB):

```
Scenes/          all scenes and their scripts
Assets/          (directory marker only - asset files are gitignored)
project.godot    project settings
.gitignore
```

Ignored, because they are binary, generated, or auto-derived:

| Ignored | Why |
|---|---|
| `.import/` | compiled asset cache (`.stex`, `.oggstr`, `.sample`) — 19.6 MB, regenerated on first open |
| `Assets/**` `*.png` `*.ogg` `*.wav` `*.ttf` `*.ico` `*.svg` | raw art and audio (~25 MB) |
| `.autoconverted/` | editor-generated binary `.tscn.converted.res`, regenerated from the text scenes |
| `*.gde`, `*.gdc`, `*.remap` | the original recovered bytecode and remaps, not source |
| `export_presets.cfg` | contains the Android keystore password |
| `*.exe` `*.apk` `*.pck` | build output |

**This repository is code-only.** Cloning it gives you the scripts and scenes but not the
art or audio — the project will load with missing-resource errors until you supply the
artwork from the original executable (extract them again with GDRE Tools, or copy them
from a local build).

## Opening the project

1. Install Godot **3.2.4** (standard build, not .NET/Mono):
   <https://github.com/godotengine/godot/releases/download/3.2.4-stable/Godot_v3.2.4-stable_win64.exe.zip>
2. Open the Godot Project Manager → **Import** → select `project.godot` in this folder.
3. On first open the editor re-imports assets. Files missing from the repo will be reported
   as errors; that is expected.
4. Run with the ▶ button, or `F5`.

Use the exact 3.2.4 editor. Opening the project in 3.3+ triggers a project-settings
conversion that rewrites `project.godot`, and export templates only load when their version
matches the editor.

## Building

Export templates must match the editor version exactly
(`Godot_v3.2.4-stable_export_templates.tpz` → `editor_data/templates/3.2.4.stable/`).
Export presets are gitignored because the Android preset holds a keystore password — create
your own in **Project → Export** and supply your own keystore before shipping.

Builds produced during recovery (not committed):

| Artifact | Size |
|---|---|
| `PatTheIceFairy64.exe` — Windows x64, icon + version info, embedded PCK | 48.26 MB |
| `PatTheIceFairy64.apk` — Android arm64-v8a, signed | 29.43 MB |

Notes for rebuilding:

- **Icon:** patch it into the export *template* before exporting. Running `rcedit` during
  export instead rewrites the executable after the PCK is appended and strips the overlay
  footer, producing a file whose embedded pack can no longer be found.
- **Android:** the project renders with GLES2, so `rendering/vram_compression/import_etc`
  must be `true` in `project.godot` or the editor refuses to export for Android.
- **Signing:** the recovery build used the local debug keystore
  (`~/.android/debug.keystore`, alias `androiddebugkey`, password `android`) and JDK 11+
  for `apksigner`. Fine for sideloading, not for store publishing.

## Project layout

```
Scenes/
  AutoLoad/    AudioManager, Globals, MusicManager, SceneManager
  Ending/      Ending, Opening
  Game/        Camera2D, Cirno, Hand, PatTest
  Transition/  Transition
  UI/          LoadingScreen, Score, Splash, Title, Manual, Credits,
              Credits_Text, Afterword
  MainViewport.tscn
```

Script highlights: `Hand.gd` follows the mouse cursor and hides itself while overlapping
an `Area2D`, `Cirno.gd` drives the character animation, `Score.gd` tracks the score,
`AudioManager.gd` / `MusicManager.gd` handle the sound buses.

## Tools used

- GDRE Tools v2.6.4 — PCK extraction, script decryption and decompilation
- Godot 3.2.4 — export templates, project import, packaging
- rcedit 2.0.0 — Windows icon and version resource patching