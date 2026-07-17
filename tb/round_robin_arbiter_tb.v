module round_robin_arbiter_tb;
reg clk, reset;
reg  [3:0] req;
wire [3:0] grant;

integer error_count = 0;

round_robin_arbiter robin_test (
    .clk(clk), 
    .reset(reset), 
    .grant(grant), 
    .req(req)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    #300;
    $display("ERROR: Simulation timed out!");
    $finish();
end

initial begin
    $dumpfile("robin_test.vcd");
    $dumpvars(0, round_robin_arbiter_tb);
    $monitor("T = %0t ns | rst = %b | req = %b | GRANT = %b | pointer = %b", 
             $time, reset, req, grant, robin_test.pointer);
end

task check_single_request(input [3:0] test_req, input [3:0] expected_grant);
    begin
        req = test_req;
        @(posedge clk); 
        #1; 
        if (grant === expected_grant) begin
            $display("  [PASSED Single] req = %b | grant = %b", req, grant);
        end else begin
            $display("  [FAILED Single] req = %b | grant = %b (Expected %b)", req, grant, expected_grant);
            error_count = error_count + 1;
        end
    end
endtask


task check_multi_request(
    input [3:0] test_req,
    input [3:0] expected_grant1,
    input [3:0] expected_grant2
);
begin
    req = test_req;

    // First arbitration cycle
    @(posedge clk);
    #1;
    if (grant === expected_grant1)
        $display("  [PASSED Multi-1] req=%b | grant=%b", req, grant);
    else begin
        $display("  [FAILED Multi-1] req=%b | grant=%b (Expected %b)",
                 req, grant, expected_grant1);
        error_count = error_count + 1;
    end

    // Second arbitration cycle
    @(posedge clk);
    #1;
    if (grant === expected_grant2)
        $display("  [PASSED Multi-2] req=%b | grant=%b", req, grant);
    else begin
        $display("  [FAILED Multi-2] req=%b | grant=%b (Expected %b)",
                 req, grant, expected_grant2);
        error_count = error_count + 1;
    end
end
endtask


initial begin
    reset = 1; 
    req = 4'b0000;
    #13; 
    reset = 0;
    
    @(posedge clk);
    $display("----- STARTING ARBITER TESTS -----");

    check_single_request(4'b1000, 4'b1000);
    check_single_request(4'b0001, 4'b0001);

    check_multi_request(4'b1001, 4'b0001, 4'b1000);

    check_multi_request(4'b0110, 4'b0100, 4'b0010);

    check_single_request(4'b0100, 4'b0100);
    check_single_request(4'b0100, 4'b0100);
    check_single_request(4'b0000, 4'b0000);

    $display("----- SIMULATION COMPLETED -----");
    if (error_count == 0) begin
        $display("  ALL TESTS PASSED SUCCESSFULLY! (Total Errors: 0)");
    end else begin
        $display("  TESTBENCH FAILED with %0d errors.", error_count);
    end
    $display("----------------------------------");
    
    #10; 
    $finish();
end

endmodule