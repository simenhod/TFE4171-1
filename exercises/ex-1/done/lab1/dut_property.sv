module dut_property(pclk,preq,pgnt);
input pclk,preq,pgnt;

`ifdef no_implication
property pr1;
  @(posedge pclk) preq ##2 pgnt;
endproperty 
preqGnt: assert property (pr1) $display($stime,,,"\t\t %m PASS1"); 
	else $display($stime,,,"\t\t %m FAIL1"); 

`elsif implication
property pr1;
  @(posedge pclk) preq |-> ##2 pgnt;
endproperty 

preqGnt: assert property (pr1) $display($stime,,,"\t\t %m PASS2"); 
	else $display($stime,,,"\t\t %m FAIL2"); 

`elsif implication_novac
property pr1;
  @(posedge pclk) preq |-> ##2 pgnt;
endproperty 
preqGnt: assert property (pr1) else $display($stime,,,"\t\t %m FAIL3"); 

property pr2;
  @(posedge pclk) preq ##2 pgnt;
endproperty 
cpreqGnt: cover property (pr2) $display($stime,,,"\t\t %m PASS3"); 
`endif

endmodule

