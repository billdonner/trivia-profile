# TriviaProfile

Swift CLI tool that profiles trivia question data files — category distribution, source breakdown, difficulty spread, hint coverage, question length stats, and answer position analysis.

## Build & Install

```bash
cd ~/trivia-profile
swift build -c release
cp .build/release/TriviaProfile ~/bin/
```

## Usage

```bash
TriviaProfile <file>                        # Full report
TriviaProfile <file> --json                 # Machine-readable JSON output
TriviaProfile <file> --section categories   # Single section only
```

**Sections:** `summary`, `categories`, `sources`, `difficulty`, `hints`, `length`, `answers`

## Input Formats

Auto-detects two JSON formats:
- **Game Data** — object with `id`, `generated`, `challenges` keys
- **Raw** — flat `[TriviaQuestion]` array with `text`, `choices`, `category`, `difficulty`

## Installed CLI Tools

| Tool | Location | Source Project |
|------|----------|----------------|
| TriviaProfile | ~/bin/TriviaProfile | trivia-profile |
