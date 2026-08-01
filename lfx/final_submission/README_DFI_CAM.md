# DFI Content Addressable Memory (CAM) - Hardware Implementation

## Overview

This is a 4-entry, 32-bit Content Addressable Memory (CAM) module designed for 
Data-Flow Integrity implementation in RISC-V Sargantana core.

## Purpose

In DFI (Data-Flow Integrity), the CAM is used to:
- Store expected data-flow tags or signatures
- Search incoming data to verify it matches expectations
- Provide fast hardware-based validation of data integrity

## Module Specification

### Inputs
- `clk`: Clock signal
- `rst_n`: Asynchronous reset (active low)
- `write_en`: Enable writing to CAM
- `write_addr`: Which entry to write (2-bit, 0-3)
- `write_data`: 32-bit data value to store
- `search_en`: Enable search operation
- `search_key`: 32-bit value to search for

### Outputs
- `match`: 4-bit one-hot encoding of which entries match
  - `match[0]` = entry 0 matches
  - `match[1]` = entry 1 matches
  - etc.
- `match_found`: Single bit, high if any entry matches

## Design Details

### Write Logic
- Synchronous writes (on clock edge)
- Can write one entry per clock cycle
- Reset clears all entries to zero

### Search Logic
- Combinational comparison (no latency)
- Searches all 4 entries in parallel
- Returns one-hot match signal

### Performance
- Write latency: 1 cycle
- Search latency: 0 cycles (combinational)
- Area: 4 × 32-bit storage + comparison logic

## How It Works

### Write Phase

write_en = 1
write_addr = 0 // Entry 0
write_data = 0xDEADBEEF

After clock edge, entry 0 contains 0xDEADBEEF

### Search Phase

search_en = 1
search_key = 0xDEADBEEF

Combinationally: match[0] = 1 (entry 0 matches)

## Testing

Run testbench:

iverilog -o cam_test cam_module.sv cam_testbench.sv
vvp cam_test


Expected output:

TEST 1: Writing to CAM entries
TEST 2: Searching for DEADBEEF
SUCCESS: Found DEADBEEF at entry 0
TEST 3: Searching for CAFEBABE
SUCCESS: Found CAFEBABE at entry 1
TEST 4: Searching for non-existent value
SUCCESS: Correctly reported no match


## Integration with Sargantana

This CAM module would be used in Sargantana DFI implementation:
- Placed in execute stage (near ALU)
- Write occurs when DFI mark instruction executes
- Search occurs when DFI check instruction executes
- Match/no-match affects commit stage decision (abort or proceed)

## Future Enhancements

- Increase CAM size (8, 16, or 32 entries)
- Add LRU replacement policy
- Add priority encoding for multiple matches
- Integrate with Sargantana exception handling
