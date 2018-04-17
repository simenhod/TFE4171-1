//////////////////////////////////////////////////
// Title:   bind_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

module bind_hdlc ();

  bind test_hdlc assertions_hdlc u_assertion_bind(
    .ErrCntAssertions(uin_hdlc.ErrCntAssertions),
    .Clk(uin_hdlc.Clk),
    .Rst(uin_hdlc.Rst),
    .Rx(uin_hdlc.Rx),
    .Rx_FlagDetect(uin_hdlc.Rx_FlagDetect),
    .Rx_EoF(uin_hdlc.Rx_EoF),
		.Rx_Ready(uin_hdlc.Rx_Ready),
		.Rx_Data(uin_hdlc.Rx_Data),
		.Rx_WrBuff(uin_hdlc.Rx_WrBuff),
		.Rx_ValidFrame(uin_hdlc.Rx_ValidFrame),
		.Rx_AbortSignal(uin_hdlc.Rx_AbortSignal),
		.Rx_AbortDetect(uin_hdlc.Rx_AbortDetect),
		.Rx_FrameSize(uin_hdlc.Rx_FrameSize),
		.Rx_Overflow(uin_hdlc.Rx_Overflow),
		.Rx_NewByte(uin_hdlc.Rx_NewByte),
		.Tx(uin_hdlc.Tx),
    .Tx_DataAvail(uin_hdlc.Tx_DataAvail),
    .Tx_RdBuff(uin_hdlc.Tx_RdBuff),
    .Tx_Done(uin_hdlc.Tx_Done),
    .Tx_FrameSize(uin_hdlc.Tx_FrameSize),
    .Tx_Full(uin_hdlc.Tx_Full),
    .Tx_ValidFrame(uin_hdlc.Tx_ValidFrame),
    .Tx_AbortFrame(uin_hdlc.Tx_AbortFrame),
		.Tx_AbortedTrans(uin_hdlc.Tx_AbortedTrans),
		.Tx_DataOutBuff(uin_hdlc.Tx_DataOutBuff)
  );

endmodule
