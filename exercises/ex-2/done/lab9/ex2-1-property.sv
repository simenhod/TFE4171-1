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
   @(posedge clk) rst |-> !data_out;
endproperty

reset_check: assert property(reset_asserted) else $display($stime,,,"\t\RESET CHECK FAIL:: rst_=%b data_out=%0d \n", rst, data_out);
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
    @(posedge clk) validi[*3] |=> valido;
endproperty

valido_check: assert property(valido_asserted) else $display($time,,,"\t\tVALIDO CHECK FAIL");
`endif

/* ------------------------------------
 * Check valido not asserted wrong
 *
 *       CHECK # 3. Check that valido is not asserted when validi=1 for only two, one
 *                  or zero consecutive clk cycles
 *
 * ------------------------------------ */

`ifdef check3
property not_valido_asserted;
    @(posedge clk) valido |-> !$past(validi, 4) && $past(validi, 3) && $past(validi, 2) && $past(validi);
endproperty

not_valido_check: assert property(valido_asserted) else $display($time,,,"\t\tNOT VALIDO CHECK FAIL");
`endif

/* ------------------------------------
 * Check data_out value
 *
 *       CHECK # 4. Check that data_out when valido=1 is equal to a*b+c where a is data_in
 *       two cycles back, b is data_in one cycle back, and c is the present data_in
 *
 * ------------------------------------ */

`ifdef check4
property data_out_asserted;
    @(posedge clk) valido |-> data_out == ($past(data_in, 3)*$past(data_in, 2)+$past(data_in));
endproperty

data_out_check: assert property(data_out_asserted) else $display($time,,,"\t\tDATA_OUT CHECK FAIL");
`endif

endmodule
