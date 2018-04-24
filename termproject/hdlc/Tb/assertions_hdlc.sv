//////////////////////////////////////////////////
// Title:   assertions_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

module assertions_hdlc (
		output int					ErrCntAssertions,
		input logic					Clk,
		input logic					Rst,
		input logic					Rx,
		input logic					Rx_FlagDetect,
		input logic					Rx_Ready,
		input logic					Rx_EoF,
		input logic	[7:0]		Rx_Data,
		input logic					Rx_WrBuff,
		input logic					Rx_ValidFrame,
		input logic					Rx_AbortDetect,
		input logic					Rx_AbortSignal,
		input logic [7:0]		Rx_FrameSize,
		input logic					Rx_Overflow,
		input logic					Rx_NewByte,
		input logic					Rx_FrameError,
		input logic					Rx_FCSerr,
		input logic					Tx,
		input logic					Tx_DataAvail,
		input logic					Tx_RdBuff,
		input logic					Tx_Done,
		input logic [7:0]		Tx_FrameSize,
		input logic					Tx_Full,
		input logic					Tx_ValidFrame,
		input logic					Tx_AbortFrame,
		input logic					Tx_AbortedTrans,
		input logic [7:0]		Tx_DataOutBuff,
		input logic [7:0]		Tx_Data
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

sequence Tx_flag_Seq;
		!Tx ##1 Tx [*6] ##1 !Tx;
endsequence

sequence Rx_AbortFrame_Seq;
		!Rx ##1 Rx[*7];
endsequence

sequence Tx_IdleFrame_Seq;
		Tx[*8];
endsequence

sequence seq_tx;    
   !Tx and $past(Tx) and $past(Tx,2) and $past(Tx,3) and $past(Tx,4) and $past(Tx,5) and $past(!Tx,6);
endsequence
/************************
*	Properties	*
************************/

// Check if flag sequence is detected
property Receive_FlagDetect;
		@(posedge Clk) Rx_flag |-> ##2 Rx_FlagDetect;
endproperty

// 1. Correct data in RX buffer according to RX input.
// --- Immediate assertion ---		

// 2. Attempting to read RX buffer after aborted frame, frame error or dropped frame should result in zeros.
// --- Immediate assertion ---		

// 3. Correct bits set in RX status/control register after receiving frame.
property Behaviour_3;
		@(posedge Clk) disable iff (!Rst) $rose(Rx_EoF) |->
				if(Rx_FrameError)
						!Rx_Ready && Rx_FrameError && !Rx_AbortSignal && !Rx_Overflow
				else if (Rx_AbortSignal)
						$rose(Rx_Ready) && !Rx_FrameError && Rx_AbortSignal && !Rx_Overflow
				else if (Rx_Overflow)
						$rose(Rx_Ready) && !Rx_FrameError && !Rx_AbortSignal && Rx_Overflow
				else
						$rose(Rx_Ready) && !Rx_FrameError && !Rx_AbortSignal && !Rx_Overflow
endproperty

// 4. Correct TX output according to written TX buffer.
// --- Immediate assertion ---		

// 5. Start and end of frame pattern generation (Start and end flag: 0111_1110).
property Behaviour_5;
		@(posedge Clk) disable iff (!Rst) !$stable(Tx_ValidFrame) && $past(!Tx_AbortFrame,2) |-> ##[0:2] Tx_flag_Seq;
endproperty

// 6. Zero insertion and removal for transparent transmission.
property Behaviour_6_insert;
   @(posedge Clk) disable iff (!Rst || !Tx_ValidFrame) seq_tx |-> $past(Tx_Data,23)==?8'bxx11111x or $past(Tx_Data,23)==?8'bx11111xx or $past(Tx_Data,23)==?8'b11111xxx;
endproperty 

property Behaviour_6_remove;
    @(posedge Clk) disable iff (!Rst || !Tx_ValidFrame) $rose(Rx) ##1 Rx[*4] ##1 !Rx |->  ##13 (Rx_Data==?{8'bxx111111} or Rx_Data==?{8'bx111111x} or Rx_Data==?{8'b111111xx} or (Rx_Data==?8'b1xxxxxxx ##8 Rx_Data==?{8'bxxx11111}) or (Rx_Data==?8'b11xxxxxx ##8 Rx_Data==?{8'bxxxx1111}) or (Rx_Data==?8'b111xxxxx ##8 Rx_Data==?{8'bxxxxx111}) or (Rx_Data==?8'b1111xxxx ##8 Rx_Data==?{8'bxxxxxx11}) or (Rx_Data==?8'b11111xxx ##8 Rx_Data==?{8'bxxxxxxx1}));
endproperty

// 7. Idle pattern generation and checking (1111_1111 when not operating).
property Behaviour_7();
		@(posedge Clk) disable iff (!Rst) !Tx_ValidFrame && Tx_FrameSize==8'd0 |-> Tx_IdleFrame_Seq;
endproperty

// 8. Abort pattern generation and checking (1111_1110).
property Behaviour_8;
		@(posedge Clk) disable iff (!Rst) Rx_AbortFrame_Seq |-> ##2 $rose(Rx_AbortDetect);
endproperty

// 9. When aborting frame during transmission, Tx_AbortedTrans should be asserted.
property Behaviour_9;
		@(posedge Clk) disable iff (!Rst) $fell(Tx_AbortFrame) |-> ##1 $rose(Tx_AbortedTrans);
endproperty

// 10. Abort pattern detected during valid frame should generate Rx_AbortSignal.
property Behaviour_10;
		@(posedge Clk) disable iff (!Rst) Rx_ValidFrame && $fell(Rx_AbortDetect) |-> $rose(Rx_AbortSignal); 
endproperty

// 11. CRC generation and Checking.
//--- Immediate assertion ---

// 12. When a whole RX frame has been received, check if end of frame is generated.
property Behaviour_12;
		@(posedge Clk) disable iff(!Rst) $fell(Rx_ValidFrame) && !Rx_AbortSignal |-> ##1 $rose(Rx_EoF);
endproperty

// 13. When receiving more than 128 bytes, Rx_Overflow should be asserted.
property Behaviour_13;
		@(posedge Clk) disable iff (!Rst) $fell(Rx_EoF) && Rx_FrameSize==8'd126 && Rx_Ready |-> Rx_Overflow;
endproperty

// 14. Rx_FrameSize should equal the number of bytes received in a frame (max. 126 bytes = 128 bytes in buffer − 2 FCS bytes).
// --- Immediate assertion ---

// 15. Rx_Ready should indicate byte(s) in RX buffer is ready to be read.
property Behaviour_15;
		@(posedge Clk) disable iff (!Rst) $rose(Rx_Ready) |-> $rose(Rx_EoF) && !Rx_ValidFrame;
endproperty

// 16. Non-byte aligned data or error in FCS checking should result in frame error.
property Behaviour_16();
		@(posedge Clk) disable iff (!Rst) $rose(Rx_FCSerr) |-> ##1 $rose(Rx_FrameError);
endproperty
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

Behaviour_3_Assert: assert property (Behaviour_3) $display("PASS 3: Correct bits set in Rx_SC");
				else begin $error("FAIL 3: Wrong bits set in Rx_SC"); ErrCntAssertions++; end

Behaviour_5_Assert: assert property (Behaviour_5) $display("PASS 5: Start and end frame generated");
				else begin $error("FAIL 5: Start and end frame not generated"); ErrCntAssertions++; end

Behaviour_6_insert_Assert: assert property (Behaviour_6_insert) $display("PASS 6 Tx: Insert success");
		  else begin $error("ERROR 6: Tx - Failed to insert zero"); ErrCntAssertions++; end

Behaviour_6_remove_Assert: assert property (Behaviour_6_remove) $display("PASS 6 Rx: Removal success");
		  else begin $error("ERROR 6: Rx - Failed to remove zero"); ErrCntAssertions++; end

//Behaviour_7_Assert: assert property (Behaviour_7) $display("PASS 7: Tx idle pattern generated successfully");
//				else begin $error("FAIL 7: Failed to generate Tx idle pattern"); ErrCntAssertions++; end

Behaviour_8_Assert: assert property (Behaviour_8) $display("PASS 8: Abort pattern generated successfully");
				else begin $error("FAIL 8: Failed to generate abort pattern"); ErrCntAssertions++; end

Behaviour_9_Assert: assert property (Behaviour_9) $display("PASS 9: Tx_AbortedTrans was set on Tx_AbortFrame");
				else begin $error("FAIL 9: Tx_AbortedTrans not set after Tx-AbortFrame"); ErrCntAssertions++; end

Behaviour_10_Assert: assert property (Behaviour_10) $display("PASS 10: Abort pattern detected during valid frame generates Rx_AbortSignal");
				else begin $error("FAIL 10: Did not generate Rx_AbortSignal"); ErrCntAssertions++; end

Behaviour_12_Assert: assert property (Behaviour_12) $display("PASS 12: Rx_EoF generated after whole frame is revieved");
				else begin $error("FAIL 12: Rx_EoF not generated"); ErrCntAssertions++; end

Behaviour_13_Assert: assert property (Behaviour_13) $display("PASS 13: Rx_Overflow set when recieveing more that 128 bytes");
				else begin $error("FAIL 13: Rx_Overflow not set"); ErrCntAssertions++; end

Behaviour_15_Assert: assert property (Behaviour_15) $display("PASS 15: Rx_Ready set after entire frame is recieved");
				else begin $error("FAIL 15: Rx_Ready not set"); ErrCntAssertions++; end

Behaviour_16_Assert: assert property (Behaviour_16) $display("PASS 16: Rc_FrameError set after Rx_FCSerr");
				else begin $error("FAIL 16: Rx_FrameError not set after Rx_FCSerr"); ErrCntAssertions++; end

Behaviour_17_Assert: assert property (Behaviour_17) $display("PASS 17: Tx_Done is high after transmission");
				else begin $error("FAIL 17: Tx_Done is not high after transmission"); ErrCntAssertions++; end

Behaviour_18_Assert: assert property (Behaviour_18) $display("PASS 18: Tx_Full set when buffer is full");
				else begin $error("FAIL 18: Tx_Full not set when buffer was full"); ErrCntAssertions++; end

endmodule
