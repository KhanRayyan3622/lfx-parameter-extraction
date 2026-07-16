# serv_alu Conversion Tracker

## Status: Complete

All conversion tasks completed. All FEV runs pass (incremental, full W=1, full W=4).

## Deviations and Limitations

- **`rename_sigs.py` unavailable**: requires Python 3.12+; environment has 3.11.2. All 11 internal signal names and all I/O pipesignal names verified manually against TLV naming rules — all compliant.

## Parameters

`W` (default 1, also tested as 4) is the only parameter. FEV covers both values via `fev_full.eqy` (W=1) and `fev_full_W_4.eqy` (W=4). `B = W-1` is derived. No additional parameter values are meaningful for this module.

## Design Decisions

- **generate if (W>1) eliminated**: The `result_slt[B:1] = 0` upper-bits assignment was combined with `result_slt[0]` into a single `result_slt[B:0] = {{B{1'b0}}, cmp_r & cnt0}`. Valid for all W since when W=1, `{0{1'b0}}` is empty. Verified by FEV at both W=1 and W=4.
- **`add_cy_r` split NBA consolidated**: Two non-blocking assignments (`add_cy_r <= 0; add_cy_r[0] <= ...`) merged into `add_cy_r <= {{B{1'b0}}, en ? add_cy : sub}`.
- **`o_cmp` used internally**: Since `cmp_r` samples `o_cmp` each cycle, an intermediate `$cmp` pipesignal was introduced. `*o_cmp = $cmp` at the output bridge.

## Code Size Assessment

- `prepared.sv`: 75 lines
- `wip.tlv`: 82 lines (+9%, +7 lines)

Growth is from the TLV header, macro structure, and explicit I/O bridge. The macro body (pure logic) is ~35 lines vs. 45 lines in the original module body — a net reduction by eliminating `wire`/`reg` declarations and the generate block.

## Signal Mapping (for verification collateral updates)

| Original Verilog | TLV Pipesignal |
|---|---|
| `cmp_r` | `\|alu<>0$cmp_r` |
| `add_cy_r` | `\|alu<>0$add_cy_r` |
| `add_cy` | `\|alu<>0$add_cy` |
| `result_add` | `\|alu<>0$result_add` |
| `result_slt` | `\|alu<>0$result_slt` |
| `result_bool` | `\|alu<>0$result_bool` |
| `result_lt` | `\|alu<>0$result_lt` |
| `result_eq` | `\|alu<>0$result_eq` |
| `rs1_sx` | `\|alu<>0$rs1_sx` |
| `op_b_sx` | `\|alu<>0$op_b_sx` |
| `add_b` | `\|alu<>0$add_b` |

## Optimization Opportunities

- Pipeline staging across `@0`/`@1` could reduce the adder's critical path but requires functional timing changes incompatible with FEV constraints.
