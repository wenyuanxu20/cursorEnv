---
name: novel-continuity
description: >-
  Long-novel continuity workflow for Cursor: wiki/novel as source of truth,
  agentmemory only for hard constraints. Use when writing or continuing a
  novel, checking character consistency, timeline, foreshadowing, 长篇,
  续写, 人设, 时间线, 伏笔, 记忆丢失, or when the user says 构建小说wiki /
  搭建小说知识库 / build novel wiki.
---

# Novel continuity

Long fiction does **not** live in agentmemory. Canon is files: `wiki/novel/` + `manuscript/`.

## When

- User is writing / continuing a chapter
- User asks about character facts, timeline, unpaid guns, rejected plots
- User says 构建小说wiki / 搭建小说知识库 / build novel wiki → follow the bootstrap rule, then this skill
- User asks whether memory will keep the story consistent

## Source of truth (mandatory order)

Before writing or answering plot questions:

1. `wiki/novel/00-continuity-now.md` — current state (who knows what, where, open threads)
2. Relevant of: `01-characters.md` · `02-timeline.md` · `03-foreshadowing.md` · `04-rejected.md` · `05-voice.md`
3. Last 1–2 files in `manuscript/` (or the chapter the user named)
4. `wiki/novel/memory-policy.md` if unsure what to save

Do **not** treat `memory_recall` as the plot bible. Recall is optional and only for tagged hard constraints (`project` = novel folder name).

If `wiki/novel/` is missing: tell the user to say **构建小说wiki** in this workspace (or copy templates from this skill). Do not invent a bible in chat.

## Continuity checks (before new prose)

- Names, body marks, ages, relationships match `01-characters.md`
- Clock / location match `02-timeline.md` and `00-continuity-now.md`
- Do not re-fire a gun listed as already paid in `03-foreshadowing.md`
- Do not revive a plot in `04-rejected.md`
- POV / tense / distance match `05-voice.md`

If the draft would break a row, **stop and say so** — do not silently patch canon.

## After a writing session

1. Update `00-continuity-now.md` if location, knowledge, or relationships changed
2. Add unpaid / paid guns to `03-foreshadowing.md`
3. Append timeline beats to `02-timeline.md`
4. `wiki/log.md` one bullet: chapter file + what canon changed
5. `memory_save` **only** if a hard constraint was decided (see memory-policy). Type `decision` or `fact`. `project` = workspace folder slug, **not** a path. Concepts: novel slug + character or rule name.

## agentmemory: save / do not save

**Save (short, stable):**

- POV / tense / language rules that must never drift
- Physical facts that will not be revised (scars, dead/alive, secret already public)
- User “do it this way” (no purple prose, chapter length, 禁止系统文)

**Do not save:**

- Chapter summaries, outlines, full character sheets (those stay in wiki)
- Prose drafts
- Superseded plot (move to `04-rejected.md`, do not also remember the old version as fact)
- Coding/cursorEnv memories mixed into the novel `project`

Never enable global `AGENTMEMORY_INJECT_CONTEXT` for this workflow.

## Templates

Copy from this skill’s `templates/` (or `cursorEnv/skills/novel-continuity/templates/`). Bootstrap rule does the copy.

## Related

- Hub: `cursorEnv/NOVEL-WRITING.md`
- Wiki: `cursorEnv/wiki/novel-writing/`
