//////////////////////////////////////////////////
// Title:   testPr_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

program testPr_hdlc(
  in_hdlc uin_hdlc
);

  int TbErrorCnt;

  initial begin
    $display("*************************************************************");
    $display("%t - Starting Test Program", $time);
    $display("*************************************************************");

    init();

    //Tests:
    Receive();
    Behaviour_17();
    
    $display("*************************************************************");
    $display("%t - Finishing Test Program", $time);
    $display("*************************************************************");
    $stop;
  end

  final begin

    $display("*********************************");
    $display("*                               *");
    $display("* \tAssertion Errors: %0d\t  *", TbErrorCnt + uin_hdlc.ErrCntAssertions);
    $display("*                               *");
    $display("*********************************");
  end

  task init();
    uin_hdlc.Clk         =   1'b0;
    uin_hdlc.Rst         =   1'b0;
    uin_hdlc.Rx          =   1'b1;
    uin_hdlc.RxEN        =   1'b1;
    uin_hdlc.TxEN	 =   1'b1;
	
    TbErrorCnt = 0;

    #1000ns;
    uin_hdlc.Rst         =   1'b1;
  endtask

  task WriteAddress(input logic [2:0] Address ,input logic [7:0] Data);
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Address     = Address;
    uin_hdlc.WriteEnable = 1'b1;
    uin_hdlc.DataIn      = Data;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.WriteEnable = 1'b0;
  endtask

  task ReadAddress(input logic [2:0] Address ,output logic [7:0] Data);
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Address    = Address;
    uin_hdlc.ReadEnable = 1'b1;
    #100ns;
    Data                = uin_hdlc.DataOut;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.ReadEnable = 1'b0;
  endtask


  task Receive();
    logic [7:0] ReadData;

    //RX flag
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;

    repeat(8)
      @(posedge uin_hdlc.Clk);

    ReadAddress(3'b010 , ReadData);
    $display("Rx_SC=%h", ReadData);
  endtask

  task ReadRxSC();
	logic [7:0] ReadData;
	ReadAddress(3'b010, ReadData);
	$display("Rx_SC=%b", ReadData);
  endtask

  task ReadRxBuff();
	logic [7:0] ReadData;
	ReadAddress(3'b011, ReadData);
	$display("Rx_Buff=%b", ReadData);
  endtask

  task ReadRxLen();
	logic [7:0] ReadData;
	ReadAddress(3'b100, ReadData);
	$display("Rx_Len=%b", ReadData);
  endtask

  task ReadTxSC();
	logic [7:0] ReadData;
	ReadAddress(3'b00, ReadData);
	$display("Tx_SC=%b", ReadData);
  endtask

  task ReadTxBuff();
	logic [7:0] ReadData;
	ReadAddress(3'b001, ReadData);
	$display("Tx_Buff=%b", ReadData);
  endtask


  task Behaviour_17();
    logic [7:0] Data;
    logic [7:0] Tx_Enable;
    Data = 8'b11100111;
    Tx_Enable = 8'b0000010;
    
    // Write data to Tx_Buff
    WriteAddress(3'b001, Data);
    // Tx_Enable
    WriteAddress(3'b000, Tx_Enable);

    // Print Tx_SC
    @(posedge uin_hdlc.Clk);
    ReadTxSC();
  endtask

endprogram
