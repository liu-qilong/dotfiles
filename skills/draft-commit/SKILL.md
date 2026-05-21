---
name: draft-commit
description: Review git changes and create a commit with confirmation
disable-model-invocation: true
---

- Review the git changes in the current repository and create a commit message based on the changes
- Generate a commit message with:
  - A concise summary line describing the overall change
  - A blank line followed by a per-file breakdown listing each changed file and what was modified.

Example:

```
Add IoU retry fallback for grounding pipelines and session memos

animer_grounding_run.py & sam3d_grounding_run.py:

- Progressively lower iou_threshold by 0.1 on failure until success or exhaustion

- Log failed meshes to failed.txt in the output directory

- process_single_mesh now raises RuntimeError on no valid views instead of silently returning

- Add os import for file operations

Detailed breakdown:

1. New files: 
  - .claude/skills/to-mem/SKILL.md — new skill for exporting session learnings to .mem/ notes
  - .mem/20260215-animer-inference.md — memo on AniMer inference pipeline and camera math
  - .mem/20260219-animer-kps-3d-to-2d.md — memo on AniMer 3D-to-2D keypoint projection

2. animer_grounding_run.py & sam3d_grounding_run.py:
  - Added IoU threshold retry logic: when processing fails, the IoU threshold is progressively lowered by 0.1 until success or exhaustion
  - Failed meshes are logged to failed.txt in the output directory
  - process_single_mesh now raises RuntimeError on no valid views instead of silently returning

3. queue-cuda-1.sh:
  - Added conda activate commands to switch environments between sam3d and AniMer runs
```

- Present the full commit message to the user for confirmation
- If the user confirms, create the commit with the generated message
- Ask the user whether to push the commit to the remote repository. If confirmed, push the commit
