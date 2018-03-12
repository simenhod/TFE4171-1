/*
 * Turning all checks on with check5
 */
`ifdef check5
`define check1 
`define check2 
`define check3 
`define check4
`endif 

module ex2_1_property 
  (
   input 	      clk, rst, validi,
   input [31:0]       data_in,
   input logic 	      valido, 
   input logic [31:0] data_out
   );

/*------------------------------------
 *
 *        CHECK # 1. Check that when 'rst' is asserted (==1) that data_out == 0
 *
 *------------------------------------ */

`ifdef check1

property reset_asserted;
   @(posedge clk) rst |=> !data_out;
endproperty

reset_check: assert property(reset_asserted)
  $display($stime,,,"\t\tRESET CHECK1 PASS:: rst_=%b data_out=%0d",
           rst, data_out);
else $display($stime,,,"\t\RESET CHECK1 FAIL:: rst_=%b data_out=%0d",
              rst, data_out);
`endif

/* ------------------------------------
 * Check valido assertion to hold 
 *
 *       CHECK # 2. Check that valido is asserted when validi=1 for three
 *                  consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check2

property valido_asserted;
  @(posedge clk) disable iff (rst) validi[*3] |=> valido;
endproperty

valido_check: assert property(valido_asserted)
  $display($stime,,,"\t\tVALIDO CHECK2 PASS:");

else $display($stime,,,"\t\tVALIDO CHECK2 FAIL::");

`endif

/* ------------------------------------
 * Check valido not asserted wrong 
 *
 *       CHECK # 3. Check that valido is not asserted when validi=1 for only two, one
 *                  or zero consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check3

sequence sec_1;
	@(posedge clk) validi[*3] ##1 1'b1;
endsequence

property validotwo_asserted;
    @(posedge clk) valido |-> sec_1.ended;
endproperty

/*
property validotwo_asserted;
    @(posedge clk) !(validi) ##1 validi[*0:2] |=> !valido;
endproperty
*/
valido_check2: assert property(validotwo_asserted) $display($stime,,,"\t\tVALIDO CHECK3 PASS");
else $display($stime,,,"\t\tVALIDO CHECK3 FAIL");

`endif

/* ------------------------------------
 * Check data_out value 
 *
 *       CHECK # 4. Check that data_out when valido=1 is equal to a*b+c where a is data_in
 *       two cycles back, b is data_in one cycle back, and c is the present data_in
 * 
 * ------------------------------------ */

`ifdef check4

property correct_output;
  @(posedge clk) valido |-> $past(data_in,3) * $past(data_in,2) + $past(data_in,1);
endproperty

valido_check4: assert property(correct_output) $display($stime,,,"\t\tVALIDO CHECK4 PASS");
else $display($stime,,,"\t\tVALIDO CHECK4 FAIL");
`endif

endmodule
