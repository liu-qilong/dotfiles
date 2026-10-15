---
name: walkthrough
description: Walk me through the uncommitted changes in the repository, or any specific module, implementation, or pipeline I point to. Explain the implementation through a clear, linear narrative, exposing design decisions, assumptions, and trade-offs rather than merely summarizing code.
---

# Walkthrough

Help me understand an implementation well enough to reconstruct its mental model, evaluate its design decisions, and confidently modify it myself.

By default, review all relevant uncommitted changes, including staged, unstaged, and untracked files. If I specify a module, pipeline, or other target, focus on that instead.

## Core philosophy

Reading unfamiliar code is cognitively expensive because its logic is distributed across files, functions, abstractions, and execution paths. I easily get lost when trying to reconstruct the big picture from these fragmented pieces.

Your job is to transform this nonlinear collection of implementation details into a coherent, linear narrative.

Think of yourself as a journalist writing an in-depth investigative report: you have examined the scattered source materials, established how the pieces fit together, identified the important decisions, and reconstructed the underlying story. The reader should be able to follow that story from beginning to end without repeatedly jumping between files to recover missing context.

Do not simply summarize the diff, enumerate modified files, or paraphrase individual functions. Explain the implementation as a connected system.

## Narrative structure

Organize the walkthrough according to conceptual and execution dependencies, not file order.

1. **Motivation and context.** Explain what problem the implementation addresses, what the previous approach did, and why the changes were introduced. Distinguish documented motivations from motivations inferred from the code.

2. **Big picture.** Establish the overall architecture and the main execution or data flow before introducing implementation details. Explain how the major components fit together and what responsibilities they have.

3. **Step-by-step walkthrough.** Follow the actual execution or data flow in a natural order. Explain what enters each stage, what happens to it, what comes out, and how that output connects to the next stage. Introduce relevant functions, classes, data structures, and mathematical operations where they become necessary to the story.

4. **Design decisions and assumptions.** Explain the important choices made by the implementation, the alternatives they exclude, and the assumptions on which they depend. Integrate these explanations into the narrative where the decisions occur, rather than relegating them to an isolated checklist.

5. **Implications and critical review.** Explain how the implementation changes the system's behavior, capabilities, limitations, or research assumptions. Identify important uncertainties, potential failure modes, and design decisions that deserve reconsideration.

Adapt this structure to the complexity of the target. Small changes do not need five separate sections, while substantial pipelines may require more detailed explanations.

## Expose hidden decisions and assumptions

An important purpose of this walkthrough is to surface decisions that would otherwise remain implicit in the implementation.

Pay particular attention to:

- **Architectural decisions:** Why are responsibilities divided this way? What abstractions, dependencies, or interfaces have been introduced or changed?
- **Algorithmic decisions:** Why does the implementation perform these operations, in this order? What alternatives would be possible?
- **Research assumptions:** What hypotheses, priors, approximations, or constraints does the implementation implicitly impose? Under what conditions might they fail?
- **Data semantics:** What do the inputs, outputs, intermediate representations, dimensions, masks, and normalization conventions actually mean?
- **Behavioral changes:** What is different from the previous implementation? Are there changes in semantics beyond what the stated objective requires?
- **Trade-offs:** What is gained or sacrificed in simplicity, flexibility, accuracy, efficiency, or generality?

Do not invent rationales that cannot be established from the implementation or available context. Clearly distinguish documented intentions, observable behavior, and your own interpretations.

Be especially attentive to seemingly minor implementation details that encode consequential assumptions.

The goal is not merely to understand how the code works, but to make its underlying design available for conscious evaluation.

## Writing principles

**Clarity takes precedence over brevity.** Do not sacrifice readability to reduce the number of words or tokens.

- Use precise, explicit, and unambiguous language. Prefer complete sentences and natural prose over telegraphic writing, compressed phrases, or excessive abbreviations.
- Explain unfamiliar concepts before relying on them. Define mathematical symbols, tensor dimensions, and technical terminology when they are introduced.
- Preserve logical continuity. Each paragraph should build on the preceding explanation without requiring the reader to reconstruct omitted intermediate steps.
- Use concrete examples, ASCII diagrams, readable mathematical expressions, pseudocode, and small code excerpts whenever they help establish the mental model. Choose the representation that communicates the underlying idea most clearly, rather than defaulting to code.
- Reference relevant source files, functions, and line numbers so that I can inspect the implementation myself. These references should support the narrative, not replace it.
- Focus on the important implementation details without reproducing every line of code. Be comprehensive about the reasoning, not exhaustive about incidental syntax.
- Avoid generic praise, filler, repetitive summaries, and speculative recommendations unrelated to the implementation.

Prefer coherent paragraphs over fragmented bullet points when explaining mechanisms and causal relationships.

## Interaction and output

Deliver the walkthrough directly in the conversation by default. Do not create files, notebooks, or other artifacts unless explicitly requested.

For especially important pipelines, I may separately request an interactive Jupyter Notebook walkthrough. Such notebooks should be reserved for cases where executable examples, intermediate visualizations, or hands-on inspection provide substantial additional value.

Treat the walkthrough as a read-only investigation. Do not modify the implementation while reviewing it.

The ultimate goal is to transfer understanding and ownership of the implementation back to me, rather than merely assure me that the code works.

## Terminal-friendly presentation

The walkthrough is primarily read in a CLI environment. All explanations, diagrams, and mathematical expressions must remain readable in a plain-text terminal without requiring Markdown or LaTeX rendering.

### Diagrams

Use ASCII diagrams instead of Mermaid or other formats that require rendering.

Prefer simple, clearly labeled diagrams to illustrate architecture, data flow, execution order, and relationships between components.

For example:

```text
Input point clouds (X, Y)
            |
            v
     PointNet++ Encoder
            |
            v
       Point Features
            |
            v
    Cross-Attention DiT
            |
            v
    Correspondence Scores
            |
            v
      Final Matching
```

Use branching diagrams when necessary to explain parallel components or information exchange. Keep diagrams compact enough to fit comfortably within a typical terminal window.

Every diagram should clarify the accompanying explanation rather than replace it. Introduce important components and explain relationships that may not be obvious from the diagram alone.

Do not use Mermaid syntax. Prefer plain ASCII characters for maximum terminal compatibility.

### Mathematical notation

Write mathematical expressions in readable plain text rather than LaTeX, which may appear as unrendered source code in the terminal.

For example, prefer:

```text
P = A @ B

A: [N, K]  Point-to-marker assignments
B: [K, M]  Marker-to-point assignments
P: [N, M]  Resulting correspondence scores
```

Over:

`$P = AB,\quad A \in \mathbb{R}^{N \times K},\quad B \in \mathbb{R}^{K \times M}$`

For more complicated expressions, use multiline plain-text notation, intermediate steps, and accompanying explanations.

- Define every important symbol, tensor dimension, and mathematical operation when it first appears.
- Distinguish mathematical operations from their implementation-specific equivalents when necessary. For example, clarify whether `@` represents matrix multiplication and whether `*` represents element-wise multiplication.
- Preserve mathematical precision. Do not omit important indices, conditions, normalization terms, or intermediate steps merely to simplify notation.
- Explain what each operation accomplishes and why it is needed, rather than only presenting the formula.
- Avoid dense symbolic expressions when a sequence of simpler expressions would be easier to follow.
- Use code excerpts when they express an operation more clearly than mathematical notation.

The goal is to make mathematical reasoning understandable without sacrificing technical rigor.

### Formatting

Use Markdown headings, paragraphs, lists, and fenced code blocks where appropriate, but do not depend on advanced Markdown rendering.

Keep diagrams and mathematical expressions within a reasonable terminal width. Do not impose hard line wrapping on ordinary prose.

Prefer visual simplicity and clear information hierarchy over elaborate formatting.
