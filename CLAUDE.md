# TriviaProfile

Swift CLI tool for managing trivia questions — imports JSON files into SQLite, normalizes categories, deduplicates questions, and provides reporting/export.

## Build & Install

```bash
cd ~/trivia-profile
swift build -c release
cp .build/release/TriviaProfile ~/bin/
```

## Dependencies

- **swift-argument-parser** (1.3.0+) — CLI framework
- **GRDB.swift** (7.0.0+) — SQLite database layer

## Usage

```bash
# Import JSON files into SQLite (deduplicates automatically)
TriviaProfile import ~/trivia-ai.raw.json ~/trivia-game.raw.json ...
TriviaProfile import <files> --dry-run          # Preview without writing

# Report from database (default subcommand)
TriviaProfile report                            # Full report from ~/trivia.db
TriviaProfile report --json                     # JSON output
TriviaProfile report --section categories       # Single section

# Report from JSON files (backward compat)
TriviaProfile report <file> [<file>...]

# Quick stats
TriviaProfile stats

# List categories with counts and SF Symbols
TriviaProfile categories

# Export filtered questions to JSON
TriviaProfile export /tmp/out.json --format raw --category History --difficulty hard --limit 100
TriviaProfile export --format gamedata          # Export as game data format
```

**Report sections:** `summary`, `categories`, `sources`, `difficulty`, `hints`, `length`, `answers`

**Default database:** `~/trivia.db` (override with `--db path`)

## SQLite Schema

- **categories** — id, name (unique), pic (SF Symbol)
- **category_aliases** — alias (PK) → category_id (maps 40 raw names → 20 canonical)
- **questions** — id, text, text_hash (SHA-256 dedup), choices_json, correct_index, category_id, difficulty, explanation, hint, source, imported_from, created_at

## Input Formats

Auto-detects two JSON formats:
- **Game Data** — object with `id`, `generated`, `challenges` keys
- **Raw** — flat `[RawQuestion]` array with `text`, `choices`, `category`, `difficulty`

## Installed CLI Tools

| Tool | Location | Source Project |
|------|----------|----------------|
| TriviaProfile | ~/bin/TriviaProfile | trivia-profile |
