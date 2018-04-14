//////////////////////////////////////////////////
// Title:   assertions_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

module assertions_hdlc (
  output int  ErrCntAssertions,
  input logic Clk,
  input logic Rst,
  input logic Rx,
  input logic Rx_FlagDetect,
  input logic Tx,
  input logic Tx_DataAvail,
  input logic Tx_RdBuff,
  input logic Tx_Done
  );

  initial begin
    ErrCntAssertions = 0;
  end

/************************
*	Sequences	*
************************/
  
  sequence Rx_flag;
    !Rx ##1 Rx [*6] ##1 !Rx;
  endsequence


/************************
*	Properties	*
************************/

// Check if flag sequence is detected
property Receive_FlagDetect;
	@(posedge Clk) Rx_flag |-> ##2 Rx_FlagDetect;
endproperty

// 1. Correct data in RX buffer according to RX input.

// 2. Attempting to read RX buffer after aborted frame, frame error or dropped frame should result in zeros.

// 3. Correct bits set in RX status/control register after receiving frame.

// 4. Correct TX output according to written TX buffer.

// 5. Start and end of frame pattern generation (Start and end flag: 0111_1110).

// 6. Zero insertion and removal for transparent transmission.

// 7. Idle pattern generation and checking (1111_1111 when not operating).

// 8. Abort pattern generation and checking (1111_1110).

// 9. When aborting frame during transmission, Tx_AbortedTrans should be asserted.

// 10. Abort pattern detected during valid frame should generate Rx_AbortSignal.

// 11. CRC generation and Checking.

// 12. When a whole RX frame has been received, check if end of frame is generated.

// 13. When receiving more than 128 bytes, Rx_Overflow should be asserted.

// 14. Rx_FrameSize should equal the number of bytes received in a frame (max. 126 bytes = 128 bytes in buffer − 2 FCS bytes).

// 15. Rx_Ready should indicate byte(s) in RX buffer is ready to be read.

// 16. Non-byte aligned data or error in FCS checking should result in frame error.

// 17. Tx_Done should be asserted when the entire TX buffer has been read for transmission.
property Behaviour_17;
	@(posedge Clk) disable iff (!Rst) $fell(Tx_DataAvail) |-> $rose($past(Tx_Done));
endproperty

// 18. Tx_Full should be asserted after writing 126 or more bytes to the TX buffer (overflow).

/************************
*	Assertions	*
************************/

Receive_FlagDetect_Assert: assert property (Receive_FlagDetect) $display("PASS: Receive_FlagDetect");
                         	else begin $error("Flag sequence did not generate FlagDetect"); ErrCntAssertions++; end


Behaviour_17_Assert : assert property (Behaviour_17) $display("PASS 17: Tx_Done is high after transmission");
			else begin $error("Tx_Done is not high after transmission"); ErrCntAssertions++; end

endmodule
