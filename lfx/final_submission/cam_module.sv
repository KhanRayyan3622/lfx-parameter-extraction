// Content Addressable Memory (CAM) Module
// 4-entry, 32-bit, used for Data-Flow Integrity tag matching
// Author: Muhammad Rayyan Khan
// Date: July 28, 2026

module cam_4x32 (
  input  clk,
  input  rst_n,
  
  // Write interface
  input  write_en,
  input  [1:0]  write_addr,    // Which entry to write (0-3)
  input  [31:0] write_data,    // Data to write
  
  // Search interface
  input  search_en,
  input  [31:0] search_key,    // Value to search for
  
  // Output signals
  output [3:0]  match,         // Which entries match (one-hot)
  output        match_found    // Did we find a match?
);

  // 4 entries of 32-bit storage
  reg [31:0] entries [3:0];
  
  // Write logic
  always @(posedge clk) begin
    if (!rst_n) begin
      entries[0] <= 32'h0;
      entries[1] <= 32'h0;
      entries[2] <= 32'h0;
      entries[3] <= 32'h0;
    end else if (write_en) begin
      entries[write_addr] <= write_data;
    end
  end
  
  // Match detection logic (combinational)
  wire match_0 = (search_en && search_key == entries[0]);
  wire match_1 = (search_en && search_key == entries[1]);
  wire match_2 = (search_en && search_key == entries[2]);
  wire match_3 = (search_en && search_key == entries[3]);
  
  assign match = {match_3, match_2, match_1, match_0};
  assign match_found = |match;  // OR all match bits
  
endmodule
