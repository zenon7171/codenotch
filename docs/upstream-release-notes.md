# Upstream release notes

Original English release notes from vinzdg/codenotch v1.5.0.

## 1.5.0

Two more providers, and a live account plan that was silently dropped.

### Grok is a new ring

SuperGrok's weekly Grok Build allowance, read from the same billing endpoint the CLI uses, with the session in ~/.grok/auth.json.

### OpenCode's Go plan is a new ring

Reads the Go plan's official usage endpoint with the key OpenCode itself stores on sign-in — no second sign-in.

### A real Codex account went unmetered

Codex's live reading only recognised a 5-hour and a 7-day window. A free-plan account's real limit was a 30-day one, which fell through unnoticed and showed as nothing metered on an account that was genuinely tracked.

### Switching a provider off now really stops it

Opening Settings could still read a switched-off provider's account, and a reply already in flight could restore a reading you had just asked it to forget.

### Contributors can build without a certificate

make build and make test now sign themselves automatically when the maintainer's Developer ID isn't present — no Apple account needed to work on this.

## 1.4.1

Waking from sleep no longer erases a reading.

### A ring survives waking your Mac

A brief window right after sleep, where macOS won't allow a keychain prompt yet, was mistaken for being signed out — which erased the reading and left "waiting for the first reading" on screen. It now ages the number instead of throwing it away, and picks back up on its own.

## 1.4.0

Two more accounts, four community fixes, and honest duplicates.

### Multiple Claude Code accounts

Keep a work login apart with CLAUDE_CONFIG_DIR? It now gets its own ring, its own limits, and its own row in Settings, beside your personal one.

### GLM added

Z.ai's Coding Plan reads live now too, with a key borrowed from whichever tool already holds one.

### A stuck Claude ring recovers on its own

One momentary failure — the Mac waking from sleep, most often — used to lock the ring until the app restarted. It now clears itself on the next check.

### Cursor sessions stop reporting work that already ended

A crashed or abandoned chat could read as "still working" for a day or more. It now notices when the writing has actually stopped.

### A months-old duplicate can no longer win

Claude Code files a new keychain entry on every token rotation. An account signed in for a while could pick an old, expired one at random and show "waiting for the first reading" forever.

### A stray click no longer pins the notch open

Clicking near the screen edge before the notch had even opened could leave it stuck open with nothing on screen explaining why.

## 1.3.0

Codex reads live, and Always show stays on.

### Codex is read live instead of from a log

The figure came from a file Codex writes during a turn, so it was as old as the last time you used it — three days stale in one case. Codenotch now asks Codex itself, and matches its own panel.

### The Codex ring notices the desktop app

It only ever watched the files the CLI and the VS Code extension write, so work done in the desktop app never made it spin.

### Always show no longer turns itself off

Clicking the notch toggled the same flag the setting used, so a stray click quietly put it back to showing on hover.

### Far fewer keychain prompts

Once a token expired, every check went back to the keychain — a prompt a minute. It now reads the secret only when the owning app has changed it, and never retries a refusal on a timer.

### A paused limit is shown as paused

Some limits are reached while the headline still shows room. The ring reads as spent and says when it lifts.

### Long messages are no longer cut off

A tooltip with something to explain reserved one line for it however much it said.

## 1.2.0

Every session, and a tooltip that fits on the screen.

### Tooltips are no longer cut off

A card is centred on the ring it belongs to, so the first and last providers threw half of it past the end of the panel — and what fell off was the title. The panel now keeps room for it.

### As many sessions as your screen can hold

The list was capped at four whatever you were running on. It is now solved for the display: ten on a large one, and "and N more" only when there is genuinely no room for the rest.

### The ones that need you come first

Waiting, then busy, then idle — so if anything is summarised away, it is what matters least.

## 1.1.0

Antigravity's real numbers, and a switch that stays off.

### Antigravity shows its actual quota

Google will not answer Codenotch directly, so it asks Antigravity's own language server instead — the same place Antigravity's usage panel gets its figure.

### Usage reads both ways

"12% used · 88% left", so a reading lines up with whichever end your vendor happens to show.

### A way back from a declined keychain prompt

Declining no longer looks like being signed out, and Allow access… asks macOS again.

### Switching a provider off now sticks

It stopped being read but its last reading was kept, so the ring came back at the next launch.

### Distant resets show a date

A limit renewing in four weeks said "Mon", which read as this Monday. It says "28 Sep".

## 1.0.0

The first release.

### Put the notch anywhere

Right, left, top or bottom. It keeps clear of the Dock and the menu bar, and follows when the Dock moves.

### It joins your Mac's own notch

On the top edge it takes the hardware's shape, so the two read as one rather than as a bar parked underneath.

### Claude, Cursor, Codex and Gemini

Each read from the tool already signed in on this Mac. Codenotch never asks for a password.

### Choose where Codenotch appears

In the Dock, in the menu bar, or nowhere at all.
