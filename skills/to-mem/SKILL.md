---
name: to-mem
description: Export key learnings from the current coding session to a .mem note
---

Write a technical memo capturing what was learned in this coding session. Save it to the `.mem/` directory.

## Instructions

1. Review the full conversation to identify:
   - The core problem and solution approach
   - Mathematical derivations or formulas encountered
   - Pipelines, data flow, directory layouts, or state machines worth diagramming
   - Important code snippets or patterns
   - Bugs found and their root causes
   - Non-obvious gotchas or lessons learned
   - Key code patterns worth remembering
2. Write the memo to `.mem/<date>-<topic>.md` where:
   - `<date>` is today in `YYYYMMDD` format
   - `<topic>` is a short kebab-case slug describing the subject (use $ARGUMENTS if provided, otherwise infer from the session)
3. The memo should be:
   - Self-contained (readable without the conversation)
   - Technical and precise, with math (LaTeX) where appropriate. Use `$...$` for inline math and `$$...$$` for standalone/display math — never `\(...\)` or `\[...\]`, and never bare LaTeX without delimiters.
   - Structured with clear headings
   - Focused on **what you'd need to remember** to avoid repeating mistakes or re-deriving things
4. Use ASCII diagrams when they make a relationship clearer than prose. Good candidates:
   - Pipelines / data flow (`A ──► B ──► C`)
   - Directory layouts (tree-style with `├──` / `└──`)
   - State machines, control flow, or decision branches
   - Matrix / tensor shapes and index conventions
   - Memory layouts, packet formats, or on-disk file structures
   Keep diagrams compact and labeled. Don't diagram trivially linear flows that prose handles in one sentence.

