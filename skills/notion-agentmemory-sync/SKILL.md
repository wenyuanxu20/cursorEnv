---
name: notion-agentmemory-sync
description: >-
  Syncs Notion pages shared with the xwy-notion integration into local
  agentmemory. Use at every session start, when Notion pages changed, when
  the user mentions Notion wiki/AiRec updates, or to keep agentmemory aligned
  with Notion. Incremental by default; --full re-ingests all readable pages.
---

# Notion → agentmemory sync

Do **not** wait for the user to say "sync Notion". This skill is the how-to; the global Cursor rule `notion-agentmemory-sync.mdc` requires it on every session.

## When

- Session start (after `memory_recall`)
- User edited Notion / asked to refresh wiki / mentioned AiRec
- After creating or updating a Notion page in this conversation

## How

Run the script (incremental unless the user asked for a full rebuild):

```powershell
python "$env:USERPROFILE\.cursor\skills\notion-agentmemory-sync\scripts\sync.py"
```

Full rebuild:

```powershell
python "$env:USERPROFILE\.cursor\skills\notion-agentmemory-sync\scripts\sync.py" --full
```

Requires: `NOTION_TOKEN` (user env), agentmemory `http://127.0.0.1:3111` live. The script clears `ALL_PROXY`/`HTTPS_PROXY` so Notion TLS is direct.

Skip silently if token missing or livez fails — do not block the user's task.

## What it writes

- One agentmemory fact per Notion page (`project=notion`)
- Checkpoint: `%USERPROFILE%\.agentmemory\notion-sync-state.json`
- Store files: `cursorEnv/data/state_store.db/mem%3Amemories.bin` (plus BM25 index)

Never echo `NOTION_TOKEN`. Never ingest `.env` / secrets.

## Memory file (this machine)

| Role | Path |
|------|------|
| Memories blob | `C:\Users\xwy12\Desktop\my-project\cursorEnv\data\state_store.db\mem%3Amemories.bin` |
| Lessons | `…\mem%3Alessons.bin` |
| BM25 index | `…\mem%3Aindex%3Abm25.bin` |
| Sync checkpoint | `%USERPROFILE%\.agentmemory\notion-sync-state.json` |
| Viewer | http://127.0.0.1:3113 |
