\m5_TLV_version 1d: tl-x.org
\m5
   use(m5-1.0)
\SV
`default_nettype none
module serv_alu
  #(
   parameter W = 1,
   parameter B = W-1
  )
  (
   input wire             clk,
   //State
   input wire             i_en,
   input wire             i_cnt0,
   output wire            o_cmp,
   //Control
   input wire             i_sub,
   input wire [1:0]       i_bool_op,
   input wire             i_cmp_eq,
   input wire             i_cmp_sig,
   input wire [2:0]       i_rd_sel,
   //Data
   input wire  [B:0]      i_rs1,
   input wire  [B:0]      i_op_b,
   input wire  [B:0]      i_buf,
   output wire [B:0]      o_rd);
\TLV
   |alu
      @0
         // Connect Verilog inputs:
         $en           = *i_en;
         $cnt0         = *i_cnt0;
         $sub          = *i_sub;
         $bool_op[1:0] = *i_bool_op;
         $cmp_eq       = *i_cmp_eq;
         $cmp_sig      = *i_cmp_sig;
         $rd_sel[2:0]  = *i_rd_sel;
         $rs1[B:0]     = *i_rs1;
         $op_b[B:0]    = *i_op_b;
         $buf[B:0]     = *i_buf;

         //Sign-extended operands
         $rs1_sx  = $rs1[B] & $cmp_sig;
         $op_b_sx = $op_b[B] & $cmp_sig;

         $add_b[B:0] = $op_b ^ {W{$sub}};

         {$add_cy, $result_add[B:0]} = $rs1 + $add_b + $add_cy_r;

         $result_lt = $rs1_sx + ~ $op_b_sx + $add_cy;

         $result_eq = ! (| $result_add) & ($cmp_r | $cnt0);

         $cmp = $cmp_eq ? $result_eq : $result_lt;

         /*
          The result_bool expression implements the following operations between
          i_rs1 and i_op_b depending on the value of i_bool_op

          00 xor
          01 0
          10 or
          11 and

          i_bool_op will be 01 during shift operations, so by outputting zero under
          this condition we can safely or result_bool with i_buf
          */
         $result_bool[B:0] = (($rs1 ^ $op_b) & ~ {W{$bool_op[0]}}) | ({W{$bool_op[1]}} & $op_b & $rs1);

         // relevant if W>1: result_slt[B:1] = 0
         $result_slt[B:0] = {{B{1'b0}}, $cmp_r & $cnt0};

         $rd[B:0] = $buf |
                    ({W{$rd_sel[0]}} & $result_add) |
                    ({W{$rd_sel[1]}} & $result_slt) |
                    ({W{$rd_sel[2]}} & $result_bool);

         <<1$add_cy_r[B:0] = {{B{1'b0}}, $en ? $add_cy : $sub};
         <<1$cmp_r         = $en ? $cmp : $cmp_r;

         // Connect Verilog outputs:
         *o_cmp = $cmp;
         *o_rd  = $rd;
\SV
   endmodule
