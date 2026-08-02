# Parameter Extraction Methodology

## Overview
Extracted architectural parameters from 2 RISC-V specification snippets using Claude LLM.

## Snippet 1: Cache Specification (19.3.1)

**Parameters Found:** 3
- CACHE_BLOCK_SIZE (HIGH confidence)
- CACHE_CAPACITY (MEDIUM confidence)
- CACHE_ORGANIZATION (MEDIUM confidence)

**Analysis:**
These are true parameters because the text explicitly says "implementation-specific."
Different RISC-V implementations can choose different cache sizes and organizations.

## Snippet 2: CSR Address Mapping (2.1)

**Parameters Found:** 0

**Analysis:**
This snippet describes standard conventions that are the SAME for all RISC-V implementations:
- 12-bit encoding space (fixed)
- Bit encoding schemes (fixed)
- Privilege level encoding (fixed)

These are not implementation-specific, so they are NOT parameters.

## Key Insight

Distinguishing between:
1. **Parameter:** Implementation can choose (cache size varies)
2. **Convention:** Standard specifies (CSR format is fixed)

## Hallucinations

Total hallucinations: 0
All extracted items are valid parameters or correctly identified as non-parameters.

## Confidence Scoring

- HIGH: Explicitly stated as "implementation-specific"
- MEDIUM: Strongly implied from text
- LOW: Inferred from context
