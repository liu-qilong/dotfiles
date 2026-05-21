---
name: review-paper-edits
description: Review recent LaTeX paper edits for grammar errors, notation consistency, language style, and clarity. Universal skill for academic paper writing.
---

# Skill: review-paper-edits

## Description
Review recent LaTeX paper edits for grammar errors, notation consistency, language style, and clarity. Universal skill for academic paper writing.

## Invocation
User-invocable via `/review-paper-edits`

## Instructions

When this skill is invoked:

1. **Identify what changed.** Run `git diff` and `git diff --cached` to find all modified `.tex` files. If the working tree is clean, use `git diff HEAD~1` to review the latest commit. Read the full file context around each change to understand surrounding conventions.

2. **Check for errors across three categories**, reporting each finding with its file path and line number:

### A. Grammar & Language
- Subject-verb agreement.
- Article-noun agreement (e.g., "a maps" → "a map").
- Tense consistency within each section — flag shifts between present and past tense.
- Dangling modifiers, run-on sentences, comma splices.
- Missing terminal punctuation on `\item` entries in `enumerate` / `itemize` environments.
- Spelling errors and typos.

### B. Notation Consistency
- Check that every symbol is used consistently with its first definition (same letter, sub/superscript style, font command).
- Verify matrix/vector dimensions are compatible in equations — especially products and compositions.
- Flag any symbol introduced without definition.
- Check that subscript/superscript ordering conventions are consistent across all occurrences.
- Verify matching delimiters and balanced braces in math environments.

### C. Style & Clarity
- Non-breaking space `~` before `\cite{}` and `\cref{}` / `\ref{}`.
- Prefer `\textbf{}` / `\textit{}` over deprecated `\bf` / `\it`.
- Flag placeholder or TODO markers left in the text.
- Prefer active voice and concise phrasing.
- Flag redundant hedging ("it is worth noting that", "it should be mentioned").
- Flag overly long sentences (>40 words) that could be split.
- Check that enumerated steps are logically ordered and self-contained.

3. **Output format.** Present findings grouped by category (A–C). For each issue:
   - Quote the problematic text
   - State the file and line number
   - Explain the issue briefly
   - Suggest a fix

4. **Offer to apply fixes.** After presenting the review, ask the user if they want you to apply all fixes, selected fixes, or none.
