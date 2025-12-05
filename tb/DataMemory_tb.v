`timescale 1ns/1ps

module DataMemory_tb;

    reg         clk;
    reg  [31:0] addr;
    reg  [31:0] write_data;
    reg         WE;
    wire [31:0] read_data;

    // DUT
    DataMemory dut (
        .clk        (clk),
        .addr       (addr),
        .write_data (write_data),
        .WE         (WE),
        .read_data  (read_data)
    );

    // Clock generator: 10 ns period
    always #5 clk = ~clk;

    // Monitor (for visual debug)
    initial begin
        $monitor("time=%0t clk=%b WE=%b addr=%h write_data=%h read_data=%h",
                  $time, clk, WE, addr, write_data, read_data);
    end

    // Test sequence
    initial begin
        $display("==== Starting DataMemory_tb ====");

        clk        = 0;
        WE         = 0;
        addr       = 32'h0000_0000;
        write_data = 32'h0000_0000;

        // Give some time for init
        #12;

        // ----------------------------------------------------
        // Test 0: After init, memory[0] should be 0
        // ----------------------------------------------------
        addr = 32'h0000_0000;   // memory[0]
        #1;                     // async read

        $display("Test 0: Initial value at addr 0 should be 0");
        if (read_data !== 32'h0000_0000) begin
            $display("  [FAIL] Expected 0 at addr 0, got %h", read_data);
        end else begin
            $display("  [PASS] addr 0 correctly initialized to 0.");
        end

        // ----------------------------------------------------
        // Test 1: Write to memory[1] (addr = 4), then read back
        // Expect: read_data = DEADBEEF
        // ----------------------------------------------------
        $display("Test 1: Write DEADBEEF to addr 4 (memory[1]) and read back");

        addr       = 32'h0000_0004;    // this maps to memory[1]
        write_data = 32'hDEADBEEF;
        WE         = 1;

        // Wait for one posedge for the write
        @(posedge clk);
        #1; // small delay after clock

        // Stop writing
        WE = 0;
        write_data = 32'h0000_0000; // doesn't matter now

        // Read back from same address
        addr = 32'h0000_0004;
        #1;  // async read

        if (read_data !== 32'hDEADBEEF) begin
            $display("  [FAIL] Expected DEADBEEF at addr 4, got %h", read_data);
        end else begin
            $display("  [PASS] addr 4 correctly holds DEADBEEF.");
        end

        // ----------------------------------------------------
        // Test 2: Ensure WE=0 prevents write
        // ----------------------------------------------------
        $display("Test 2: With WE=0, writes must be ignored");

        addr       = 32'h0000_0004;    // same location memory[1]
        write_data = 32'h12345678;
        WE         = 0;

        @(posedge clk);
        #1;

        // Read again from addr 4
        addr = 32'h0000_0004;
        #1;

        if (read_data !== 32'hDEADBEEF) begin
            $display("  [FAIL] Memory changed when WE=0. Expected DEADBEEF, got %h", read_data);
        end else begin
            $display("  [PASS] WE=0 correctly prevented overwrite at addr 4.");
        end

        // ----------------------------------------------------
        // Test 3: addr[7:2] decoding (lower 2 bits ignored)
        // Write at addr 8, then read at addr 9 (same memory index)
        // ----------------------------------------------------
        $display("Test 3: addr[7:2] used as index (addr 8 and 9 map to same word)");

        // Write to addr 8 (memory index 8[7:2] = 2)
        addr       = 32'h0000_0008;    // 0b...00001000 -> [7:2] = 000010 = 2
        write_data = 32'hA5A5A5A5;
        WE         = 1;

        @(posedge clk);
        #1;
        WE = 0;

        // Now read from addr 9 (0x0000_0009 -> 0b...00001001, [7:2] still 000010 = 2)
        addr = 32'h0000_0009;
        #1;

        if (read_data !== 32'hA5A5A5A5) begin
            $display("  [FAIL] addr[7:2] indexing incorrect. Expected A5A5A5A5 at addr 9, got %h", read_data);
        end else begin
            $display("  [PASS] addr[7:2] correctly used: addr 8 and 9 see same word.");
        end

        $display("==== DataMemory_tb finished ====");
        $finish;
    end

endmodule
