# Moonlight Windows modernization

This fork keeps Moonlight's protocol and streaming engine close to upstream while rebuilding the Windows product experience around it.

See [WINDOWS_BUILD.md](WINDOWS_BUILD.md) for the Windows x64/ARM64 build baseline.

## Principles

1. **Stay upstream-friendly.** Keep Moonlight protocol, pairing, networking, codec, and renderer changes isolated whenever possible so upstream fixes remain easy to merge.
2. **Windows is the product target.** Prioritize Windows 11 behavior, native x64/ARM64 builds, touch, high refresh displays, HDR, controllers, Surface-class devices, and modern desktop/tablet UX.
3. **Measure before optimizing.** Instrument receive, decode, queue, presentation, and input paths before changing frame pacing or renderer behavior.
4. **Touch is first-class.** Controls must work with mouse, keyboard, controller, and touch without treating touch as a fake mouse.
5. **No mystery network behavior.** New online services, telemetry, ads, wallpaper APIs, or third-party content require explicit design review and opt-in where appropriate.

## Layering

### 1. Streaming core

- moonlight-common-c
- Sunshine/GameStream protocol
- Pairing and host discovery
- Network transport

Change sparingly.

### 2. Windows stream engine

- FFmpeg
- D3D11VA / DXGI
- Frame pacing and presentation
- Audio
- Keyboard, mouse, touch, pen, and controller input

Instrument first, then optimize.

### 3. Windows product layer

- QML application shell
- Host and app library
- Settings
- Profiles
- Touch controls
- Quick settings
- Diagnostics
- Windows/Surface integration

This is the primary modernization surface.

## Roadmap

### Phase 0 — foundation

- [x] Create a modernization branch from `master`
- [x] Add shared Windows design tokens
- [x] Replace legacy Material-era app chrome with a responsive Windows-style shell
- [x] Modernize reusable toolbar/navigation controls while preserving keyboard and gamepad focus behavior
- [ ] Keep x64 and native ARM64 CI green
- [x] Add build/contribution notes for this fork

### Phase 1 — library and settings

- [x] Touch-friendly host cards
- [ ] Responsive app/game library
- [ ] Search, favorites, recent apps
- [ ] Split the monolithic settings screen into maintainable components
- [ ] Per-game streaming profiles
- [ ] LAN / remote / Tailscale-oriented network profiles
- [ ] Profile import/export

### Phase 2 — in-stream UX

- [ ] Modern quick-settings overlay
- [ ] Rich performance HUD
- [ ] Controller-driven radial controls
- [ ] Touch trackpad/mouse gestures
- [ ] Customizable virtual controller
- [ ] Hide virtual controls automatically when a physical controller is active

### Phase 3 — Windows hardware features

- [ ] Surface/Windows sensor gyro mapping where available
- [ ] Surface Pen pressure/tilt support
- [ ] Better Windows soft-keyboard and IME handling
- [ ] HDR/high-refresh/display auto-detection and recommendations

### Phase 4 — measured latency and rendering work

- [ ] Establish Windows ARM64 and x64 baselines
- [ ] Instrument receive → decode → queue → present timing
- [ ] Audit D3D11VA copies/conversions
- [ ] Audit DXGI frame queue and fullscreen/borderless presentation latency
- [ ] Add Lowest Latency / Smooth / Auto frame-pacing presets
- [ ] Benchmark every performance change

## Initial non-goals

- Replacing Moonlight's streaming protocol stack
- Rewriting the app in WinUI before the existing Qt path is exhausted
- Frame interpolation
- Foundation-only Sunshine protocol extensions
- Large renderer changes without measurements
