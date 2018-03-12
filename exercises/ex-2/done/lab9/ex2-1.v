/*
 * ex2_1
 *
 * Purpose:
 * - Reset on rst=1
 * - When validi=1 three clk's in a row, compute data_out=a*b+c
 *   where a is data_in on the first clk, b on the second and c
 *   on the third. Also set valido=1. Else valido=0 which means
 *   data_out is not valid.
 */

module ex2_1 (
	input clk, rst, validi,
	input logic [31:0] data_in,
	output logic valido,
	output logic [3:0]  op1,op2,
	output logic [31:0] a,
	input [31:0] data_out
);

enum {S0, S1, S2} state = S0, next = S0;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		a <= 32'b0;
	end else begin
		a <= data_in;
	end
end

always_ff @(posedge clk or posedge rst) begin

	if (rst) begin
		valido <= 1'b0;
		state = S0;
	end else begin
		op2 <= 4'b0000;
		op1 <= 4'b1000;

		case (state)

		// S0
		S0: begin
			valido <= 1'b0;
			if (validi) begin
				next = S1;
			end
		end

		// S1
		S1: begin
			if (validi) begin
				next = S2;
			end
		end

		// S2
		S2: begin
			if (validi) begin
				valido <= 1'b1;
			end else begin
				valido <= 1'b0;
				next = S0;
			end
		end

		endcase
		state = next;

		end
	end
endmodule
