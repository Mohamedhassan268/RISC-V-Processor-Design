`timescale 1ns/1ps

module RegisterFile_tb;

    reg         clk;
    reg         reset_n;
    reg  [4:0]  rs1, rs2;
    reg  [4:0]  rd;
    reg  [31:0] write_data;
    reg         reg_write;
    wire [31:0] read_data1, read_data2;

    // DUT
    RegisterFile dut (
        .clk        (clk),
        .reset_n    (reset_n),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .write_data (write_data),
        .reg_write  (reg_write),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Monitor block (just for visual trace)
    initial begin
        $monitor("time=%0t clk=%b reset_n=%b reg_write=%b rd=%0d write_data=%0d rs1=%0d rs2=%0d read_data1=%0d read_data2=%0d",
                 $time, clk, reset_n, reg_write, rd, write_data, rs1, rs2, read_data1, read_data2);
    end

    // Test sequence block
    initial begin
        $display("==== Starting RegisterFile_tb ====");

        // ----------------------------------------------------
        // INITIAL CONDITIONS + RESET
        // ----------------------------------------------------
        clk        = 0;
        reset_n    = 0;
        reg_write  = 0;
        rs1        = 5'd0;
        rs2        = 5'd0;
        rd         = 5'd0;
        write_data = 32'd0;

        // Hold reset low for some time
        #20;
        reset_n = 1;   // release reset

        // Wait a bit after reset
        #20;

        // ----------------------------------------------------
        // Test 0: After reset, x0 must be 0
        // ----------------------------------------------------
        rs1 = 5'd0;   // x0
        rs2 = 5'd0;   // x0
        #1;           // async read, small delay is enough

        $display("Test 0: Reset behavior, x0 should be 0");
        if (read_data1 !== 32'd0 || read_data2 !== 32'd0) begin
            $display("  [FAIL] x0 is not zero after reset.");
            $display("         read_data1=%0d read_data2=%0d", read_data1, read_data2);
        end else begin
            $display("  [PASS] x0 correctly reads as 0 after reset.");
        end

        // ----------------------------------------------------
        // Test 1: Write to register x5, then read it via rs1
        // Assumes: synchronous write on posedge clk
        // ----------------------------------------------------
        $display("Test 1: Write 123 to x5, then read x5");

        reg_write  = 1;
        rd         = 5'd5;          // x5
        write_data = 32'd123;

        // Wait for a positive edge to perform the write
        @(posedge clk);
        #1;                         // small delay after clock edge

        reg_write  = 0;
        rs1        = 5'd5;          // read x5 on port 1
        #1;                         

        if (read_data1 !== 32'd123) begin
            $display("  [FAIL] x5 readback mismatch. Expected 123, got %0d", read_data1);
        end else begin
            $display("  [PASS] x5 correctly holds 123.");
        end

        // ----------------------------------------------------
        // Test 2: Attempt to write to x0, should stay 0
        // ----------------------------------------------------
        $display("Test 2: Attempt to write 999 to x0, x0 must remain 0");

        reg_write  = 1;
        rd         = 5'd0;          // x0
        write_data = 32'd999;

        @(posedge clk);
        #1;

        reg_write  = 0;
        rs1        = 5'd0;          // read x0
        #1;

        if (read_data1 !== 32'd0) begin
            $display("  [FAIL] x0 changed after write attempt. Expected 0, got %0d", read_data1);
        end else begin
            $display("  [PASS] x0 correctly ignores writes and stays 0.");
        end

        // ----------------------------------------------------
        // Test 3: Write two registers and read them via rs1/rs2
        // ----------------------------------------------------
        $display("Test 3: Write 50 to x3 and 75 to x10, then read both");

        // Write 50 to x3
        reg_write  = 1;
        rd         = 5'd3;
        write_data = 32'd50;
        @(posedge clk);
        #1;

        // Write 75 to x10
        rd         = 5'd10;
        write_data = 32'd75;
        @(posedge clk);
        #1;
        reg_write  = 0;

        // Read x3 on rs1 and x10 on rs2
        rs1 = 5'd3;
        rs2 = 5'd10;
        #1;

        if (read_data1 !== 32'd50 || read_data2 !== 32'd75) begin
            $display("  [FAIL] Multi-register read mismatch. Expected x3=50, x10=75. Got x3=%0d, x10=%0d",
                     read_data1, read_data2);
        end else begin
            $display("  [PASS] Multi-register read correct: x3=50, x10=75.");
        end

        $display("==== RegisterFile_tb finished ====");
        $finish;
    end

endmodule
