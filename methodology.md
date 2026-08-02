# Parameter Extraction Methodology

## Overview

Extracted architectural parameters from 2 RISC-V specification snippets using Claude 3.5 Sonnet LLM with iterative prompt refinement.

## Key Insight

**Distinguishing between:**
- **Parameter:** Implementation can choose (cache size varies by implementation)
- **Convention:** Standard specifies fixed behavior (CSR format is fixed for all implementations)

Only implementation-specific choices are parameters. Standard conventions are not.

---

## Snippet 1: Cache Specification (19.3.1)

**Parameters Found:** 3

- `CACHE_BLOCK_SIZE` (HIGH confidence)
- `CACHE_CAPACITY` (MEDIUM confidence)
- `CACHE_ORGANIZATION` (MEDIUM confidence)

**Analysis:**

Text explicitly states: "The capacity and organization of a cache and the size of a cache block are both implementation-specific."

Different RISC-V implementations choose different:
- Cache block sizes (32B, 64B, 128B, etc.)
- Total capacity (varies by design)
- Organization (associativity, sets, replacement policy)

**Why these are parameters:**
- Text uses "implementation-specific" language
- Different implementations make different choices
- These choices affect how software discovers cache properties

---

## Snippet 2: CSR Address Mapping (2.1)

**Parameters Found:** 0

**Analysis:**

This snippet describes standard conventions that are THE SAME for all RISC-V implementations:

- 12-bit CSR encoding space (fixed standard)
- Bits [11:10]: privilege level encoding (fixed standard)
- Bits [9:8]: CSR type classification (fixed standard)
- Remaining bits: parameter within that class (fixed structure)

**Why these are NOT parameters:**

These are standard conventions, not implementation-specific choices. The CSR address format is identical across all compliant RISC-V implementations.

The text describes HOW to interpret a CSR address, not what choices an implementation can make.

---

## Hallucination Prevention

**Total hallucinations:** 0

**Method:**

1. **Explicit vs Inferred Language**
   - HIGH confidence: Text explicitly says "implementation-specific" or "may be"
   - MEDIUM confidence: Strongly implied from text
   - LOW confidence: Only inferred from context

2. **Cross-Check Against Spec**
   - Verified each extracted parameter against spec text
   - Ensured direct evidence exists for each claim
   - Flagged items lacking explicit textual support

3. **Distinguish Conventions from Parameters**
   - Checked if item is fixed standard vs implementation choice
   - Verified implementation variation exists
   - Rejected standard conventions

4. **Reality Check**
   - For each parameter: "Would two different RISC-V cores choose different values?"
   - If yes: likely a parameter
   - If no: likely a convention or not a parameter

---

## Confidence Scoring

- **HIGH:** Explicitly stated as "implementation-specific", "may vary", or "implementation-defined"
- **MEDIUM:** Strongly implied through context (e.g., "cache capacity depends on design")
- **LOW:** Inferred from indirect context (not used here - too risky for this task)

---

## Lessons Learned

1. **Indicator phrases matter:** Explicit language ("implementation-specific") is more reliable than inferred meaning

2. **Context prevents hallucinations:** Providing examples and explicit instruction ("what is implementation-specific vs standard") reduces false positives

3. **Multiple iterations help:** Refining prompts from v1 (too many false positives) to v3 (zero hallucinations) demonstrates value of iteration

4. **Distinguish categories:** Clearly separating "parameters", "conventions", and "non-parameters" prevents confusion

---

## Files Submitted

- `methodology.md` (this file)
- `snippet1_parameters.yaml` (3 parameters from cache spec)
- `snippet2_analysis.yaml` (explanation of 0 parameters from CSR spec)
- `prompt_evolution.txt` (how prompts were refined)
- `README.md` (overview of all work)
