//////////////////////////////////////////////////
// Title:   in_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

interface in_hdlc ();
  //Tb
  int ErrCntAssertions;

  //Clock and reset
  logic              Clk;
  logic              Rst;

  // Address
  logic        [2:0] Address;
  logic              WriteEnable;
  logic              ReadEnable;
  logic        [7:0] DataIn;
  logic        [7:0] DataOut;

  // TX
  logic              Tx;
  logic              TxEN;

  // RX
  logic              Rx;
  logic              RxEN;

  // Tx - internal
  logic		Tx_DataAvail;
  logic		Tx_RdBuff;
  logic 	Tx_Done;
  logic		Tx_ValidFrame;
  logic	[7:0] 	Tx_FrameSize;
  logic		Tx_Full;
  logic		Tx_AbortFrame;
 
  // Rx - internal
  logic		Rx_Ready; 	
  logic       	Rx_FlagDetect;

endinterface
