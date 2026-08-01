// Testbench for CAM Module
// Tests write and search functionality

module cam_testbench ();

  reg clk;
  reg rst_n;
  reg write_en;
  reg [1:0] write_addr;
  reg [31:0] write_data;
  reg search_en;
  reg [31:0] search_key;
  
  wire [3:0] match;
  wire match_found;
  
  // Instantiate CAM module
  cam_4x32 dut (
    .clk(clk),
    .rst_n(rst_n),
    .write_en(write_en),
    .write_addr(write_addr),
    .write_data(write_data),
    .search_en(search_en),
    .search_key(search_key),
    .match(match),
    .match_found(match_found)
  );
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
  end
  
  // Test stimulus
  initial begin
    // Initialize
    rst_n = 0;
    write_en = 0;
    search_en = 0;
    #20 rst_n = 1;
    
    // Test 1: Write to entries
    $display("TEST 1: Writing to CAM entries");
    
    write_en = 1;
    write_addr = 2'b00; write_data = 32'hDEADBEEF; #10;
    write_addr = 2'b01; write_data = 32hCAFEBABE; #10;
    write_addr = 2'b10; write_data = 32'h12345678; #10;
    write_addr = 2'b11; write_data = 32'hABCDEF00; #10;
    
    write_en = 0;
    #10;
    
    // Test 2: Search for matching entry
    $display("TEST 2: Searching for DEADBEEF");
    search_en = 1;
    search_key = 32'hDEADBEEF;
    #10;
    
    if (match_found && match[0]) begin
      $display("SUCCESS: Found DEADBEEF at entry 0");
    end else begin
      $display("FAILURE: Should have found DEADBEEF at entry 0");
    end
    
    #10;
    
    // Test 3: Search for different entry
    $display("TEST 3: Searching for CAFEBABE");
    search_key = 32'hCAFEBABE;
    #10;
    
    if (match_found && match[1]) begin
      $display("SUCCESS: Found CAFEBABE at entry 1");
    end else begin
      $display("FAILURE: Should have found CAFEBABE at entry 1");
    end
    
    #10;
    
    // Test 4: Search for non-existent value
    $display("TEST 4: Searching for non-existent value");
    search_key = 32'hFFFFFFFF;
    #10;
    
    if (!match_found) begin
      $display("SUCCESS: Correctly reported no match");
    end else begin
      $display("FAILURE: Should have reported no match");
    end
    
    // End simulation
    #20;
    $finish;
  end
  
endmodule
