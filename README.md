# LFX RISC-V Fall 2026 - Parameter Extraction Challenge

## Challenge
Extract architectural parameters from RISC-V specification snippets using LLM analysis.

## Results

### Snippet 1: Cache Specification (19.3.1)
- Parameters extracted: 3
  - CACHE_BLOCK_SIZE (HIGH confidence)
  - CACHE_CAPACITY (MEDIUM confidence)
  - CACHE_ORGANIZATION (MEDIUM confidence)
- Hallucinations: 0
- Precision: 100%

### Snippet 2: CSR Address Mapping (2.1)
- Parameters extracted: 0
- Reason: These are standard conventions, not implementation-specific parameters
- Hallucinations: 0

## Files Submitted
- `README.md` (this file - overview)
- `snippet1_parameters.yaml` (cache parameters in YAML format)
- `snippet2_analysis.yaml` (CSR analysis and explanation)
- `methodology.md` (complete methodology explanation)
- `prompt_evolution.txt` (how I refined the extraction prompts)

## Key Learning

The most important lesson: Distinguish between:
- **Parameters:** Implementation-specific choices (cache size, organization)
- **Conventions:** Standard specifications fixed for all implementations (CSR address format)

## Submitted By
Muhammad Rayyan Khan
July 28, 2026

## For LFX Mentorship Application
Project: AI-Assisted Extraction of Architectural Parameters from RISC-V Specifications - Part II
Mentors: Allen Baum, Ajit Dingankar
