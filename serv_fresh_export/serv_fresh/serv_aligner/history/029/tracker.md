# serv_aligner Conversion Tracker

## Status: Complete

All conversion tasks completed. All FEV runs pass (incremental and full).

## Deviations and Limitations

- **`rename_sigs.py` unavailable**: requires Python 3.12+; environment has 3.11.2. Signal naming was verified manually. All 4 internal signals (`ibus_rdt_concat`, `ack_en`, `lower_hw`, `ctrl_misal`) and all I/O pipesignals comply with TLV naming rules.

## Code Size Assessment

- `prepared.sv`: 67 lines
- `wip.tlv`: 72 lines (+7%, +5 lines)

Growth is due to the TLV file header (3 lines), macro declaration/instantiation structure, and explicit I/O bridging sections. The macro body itself (pure logic) is ~35 lines vs. 42 lines in the original module body — a net reduction, since `wire`/`reg` declarations are absorbed into pipesignal assignments.

## Signal Mapping (for verification collateral updates)

| Original Verilog | TLV Pipesignal |
|---|---|
| `ctrl_misal` | `\|default<>0$ctrl_misal` |
| `lower_hw` | `\|default<>0$lower_hw` |
| `ibus_rdt_concat` | `\|default<>0$ibus_rdt_concat` |
| `ack_en` | `\|default<>0$ack_en` |

## Optimization Opportunities

- `$ibus_rdt_concat` is used only once and could be inlined into `$ibus_rdt`, but inlining reduces alignment with the original.
- Pipeline staging (e.g., separating adder output into @1) could reduce critical-path depth but requires functional timing changes that cannot be FEVed.
