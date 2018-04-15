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
  input logic Tx_Done,
  input logic [7:0] Tx_FrameSize,
  input logic Tx_Full,
  input logic Tx_ValidFrame,
  input logic Tx_AbortFrame
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

sequence Tx_flag;
	!Tx ##1 Tx [*6] ##1 !Tx;
endsequence

sequence Tx_Abort;
	Tx[*7] ##1 !Tx;
endsequence


/************************
*	Properties	*
************************/

// Check if flag sequence is detected
property Receive_FlagDetect;
	@(posedge Clk) Rx_flag |-> ##2 Rx_FlagDetect;
endproperty

// 1. Correct data in RX buffer according to RX input.
/*property Behaviour_1;
		@(posedge Clk) |-> Rx_Data == 8'b10101010
endproperty*/


// 2. Attempting to read RX buffer after aborted frame, frame error or dropped frame should result in zeros.

// 3. Correct bits set in RX status/control register after receiving frame.

// 4. Correct TX output according to written TX buffer.

// 5. Start and end of frame pattern generation (Start and end flag: 0111_1110).
property Behaviour_5;
	@(posedge Clk) disable iff (!Rst) !$stable(Tx_ValidFrame) && $past(!Tx_AbortFrame,2) |-> ##[0:2] Tx_flag;
endproperty

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
property Behaviour_18;
	@(posedge Clk) disable iff (!Rst) Tx_FrameSize==8'd126 |-> $past(Tx_Full);
endproperty

/************************
*	Assertions	*
************************/

Receive_FlagDetect_Assert: assert property (Receive_FlagDetect) $display("PASS: Receive_FlagDetect");
                         	else begin $error("Flag sequence did not generate FlagDetect"); ErrCntAssertions++; end

Behaviour_5_Assert: assert property (Behaviour_5) $display("PASS 5: Start and end frame generated");
			else begin $error("Start and end frame not generated"); ErrCntAssertions++; end

Behaviour_17_Assert: assert property (Behaviour_17) $display("PASS 17: Tx_Done is high after transmission");
			else begin $error("Tx_Done is not high after transmission"); ErrCntAssertions++; end

Behaviour_18_Assert: assert property (Behaviour_18) $display("PASS 18: Tx_Full set when buffer is full");
			else begin $error("Tx_Full not set when buffer was full"); ErrCntAssertions++; end

endmodule
