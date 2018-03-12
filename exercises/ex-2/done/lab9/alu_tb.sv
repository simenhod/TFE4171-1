timeunit 10ns;
`include "alu_packet.sv"
//`include "alu_assertions.sv"

module alu_tb();
	reg clk = 0;
	bit [0:31] a = 8'h0;
	bit [0:31] b = 8'h0;
	bit [0:3] op = 3'h0;
	wire [0:31] r;

parameter NUMBERS = 10000;

//make your vector here
alu_data test_data[NUMBERS];

//Make your loop here
initial begin: data_gen
	int i;
	#20;
	for (i = 0; i < NUMBERS; i++) begin
		test_data[i] = new();
		test_data[i].randomize();
		test_data[i].get(a, b, op);
		#20;
	end
end: data_gen

//Displaying signals on the screen
always @(posedge clk)
  $display($stime,,,"clk=%b a=%b b=%b op=%b r=%b",clk,a,b,op,r);

//Clock generation
always #10 clk=~clk;

//Declaration of the VHDL alu
alu dut (clk,a,b,op,r);

//Make your opcode enumeration here
enum {ADD, SUB, NOT, NAND, NOR, AND, OR, XOR, MUL} opcode;

//Make your covergroup here
covergroup alu_cg @(posedge clk);
	OP : coverpoint op {
		bins Add 	  = {ADD};
		bins Sub 	  = {SUB};
		bins Not 	  = {NOT};
		bins Nand 	  = {NAND};
		bins Nor 	  = {NOR};
		bins And 	  = {AND};
		bins Or 	  = {OR};
		bins Xor 	  = {XOR};
		bins Mul 	  = {MUL};
		bins Others[] = default;
	}
	A  : coverpoint a {
		bins Zero 	  = { 0 };
		bins Small 	  = { [1:50] };
		bins Hunds[3] = { 100,200 };
		bins Large    = { [200:$] };
		bins Others[] = default;
	}
	B  : coverpoint b;
	AB : cross A, B;
endgroup

//Initialize your covergroup here
alu_cg alu_inst = new();

//Sample covergroup here
always @(posedge clk) alu_inst.sample();


endmodule:alu_tb
