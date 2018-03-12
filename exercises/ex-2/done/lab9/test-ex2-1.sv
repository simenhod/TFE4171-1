module test_ex2_1;

    logic clk, rst, validi;

    logic [31:0] data_in;
    wire 	valido;
    wire [31:0]  DOUT;

    ex2_1 dut(
        clk, rst, validi,
        data_in,
        valido,
        op1,
        op2,
        a,
        DOUT
    );

    alu alu_add(
        .Clk(clk),
        .A(alu_mul.R),
        .B(data_in),
        .op(dut.op2),
        .R(DOUT)
    );

    alu alu_mul(
        .Clk(clk),
        .A(dut.a),
        .B(data_in),
        .op(dut.op1),
        .R(alu_add.A)
    );

    bind ex2_1 ex2_1_property ex2_1_bind
    (
        clk, rst, validi,
        data_in,
        valido,
        data_out
    );

   initial begin
      clk=1'b0;
      set_stim;
      @(posedge clk); $finish(2);
   end

   always @(posedge clk)
     $display($stime,,,"rst=%b clk=%b validi=%b DIN=%0d valido=%b DOUT=%0d a=%0d R1=%0d R2=%0d",
	      rst, clk, validi, data_in, valido, DOUT, dut.a, alu_mul.R, alu_add.R);

   always #5 clk=!clk;

   task set_stim;
      rst=1'b0; validi=0'b1; data_in=32'b1;
      @(negedge clk) rst=1;
      @(negedge clk) rst=0;

      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;

      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b1; data_in+=32'b1;
      @(negedge clk); validi=1'b0; data_in+=32'b1;

      @(negedge clk);
   endtask

endmodule
