//////////////////////////////////////////////////
// Title:   in_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

interface in_hdlc ();
		//Tb
		int ErrCntAssertions;

		//Clock and reset
		logic           Clk;
		logic						Rst;

		// Address
		logic   [2:0]		Address;
		logic           WriteEnable;
		logic           ReadEnable;
		logic   [7:0]		DataIn;
		logic   [7:0]		DataOut;

		// TX
		logic           Tx;
		logic           TxEN;

		// RX
		logic           Rx;
		logic           RxEN;

		// Tx - internal
		logic						Tx_DataAvail;
		logic						Tx_RdBuff;
		logic						Tx_Done;
		logic						Tx_ValidFrame;
		logic		[7:0]		Tx_FrameSize;
		logic						Tx_Full;
		logic						Tx_AbortFrame;
		logic						Tx_AbortedTrans;
		logic		[7:0]		Tx_DataOutBuff;
 
		// Rx - internal
		logic						Rx_Ready; 	
		logic						Rx_FlagDetect;
		logic						Rx_EoF;
		logic		[7:0]		Rx_Data;
		logic						Rx_WrBuff;
		logic						Rx_ValidFrame;
		logic						Rx_AbortSignal;
		logic						Rx_AbortDetect;
		logic		[7:0]		Rx_FrameSize;
		logic		[7:0]		Rx_Overflow;
		logic						Rx_NewByte;
endinterface
