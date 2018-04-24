//////////////////////////////////////////////////
// Title:   testPr_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

program testPr_hdlc(
  in_hdlc uin_hdlc
);

		int TbErrorCnt;
		bit [66:0] test_frame; 

		parameter Tx_SC		= 3'b000;
		parameter Tx_Buff = 3'b001;
		parameter Rx_SC		= 3'b010;
		parameter Rx_Buff = 3'b011;
		parameter Rx_Len	= 3'b100;


class Rx_Tx;
		covergroup Rx_cg @(posedge uin_hdlc.Clk);
				Rx_Overflow: coverpoint uin_hdlc.Rx_Overflow {
            bins No_Rx_Overflow = {0};
            bins Rx_Overflow = {1};
        }
				Rx_AbortSignal: coverpoint uin_hdlc.Rx_AbortSignal {
            bins No_Rx_AbortSignal = {0};
            bins Rx_AbortSignal = {1};
        }
        Rx_FrameError: coverpoint uin_hdlc.Rx_FrameError {
            bins No_Rx_FrameError = {0};
            bins Rx_FrameError = {1};
        }
				Rx_EoF: coverpoint uin_hdlc.Rx_EoF {
						bins No_Rx_EoF = {0};
						bins Rx_EoF = {1};
				}
				Rx_AbortDetect: coverpoint uin_hdlc.Rx_AbortDetect {
						bins No_Rx_AbortDetect = {0};
						bins Rx_AbortDetect = {1};
				}
				Rx_ValidFrame: coverpoint uin_hdlc.Rx_ValidFrame {
						bins No_Rx_ValidFrame = {0};
						bins Rx_ValidFrame = {1};
				}
				Rx_Ready: coverpoint uin_hdlc.Rx_Ready {
						bins No_Rx_Ready = {0};
						bins Rx_Ready = {1};
				}
				Rx_FCSerr: coverpoint uin_hdlc.Rx_FCSerr {
						bins No_Rx_FCSerr = {0};
						bins Rx_FCSerr = {1};
				}
				Rx_FrameSieze: coverpoint uin_hdlc.Rx_FrameSize {
						bins Rx_FrameSize_Zero = {0};
						bins Rx_FrameSize_Valid = {[1:125]};
						bins Rx_FrameSize_Overflow = {126};
				}
		endgroup
		
		covergroup Tx_cg @(posedge uin_hdlc.Clk);
				Tx_Done: coverpoint uin_hdlc.Tx_Done {
						bins No_Tx_Done = {0};
						bins Tx_Done = {1};
				} 
				Tx_Full: coverpoint uin_hdlc.Tx_Full {
						bins No_Tx_Full = {0};
						bins Tx_Full = {1};
				}
				Tx_ValidFrame: coverpoint uin_hdlc.Tx_ValidFrame {
						bins No_Tx_ValidFrame = {0};
						bins Tx_ValidFrame = {1};
				}
				Tx_AbortFrame: coverpoint uin_hdlc.Tx_AbortFrame {
						bins No_Tx_AbortFrame = {0};
						bins Tx_AbortFrame = {1};
				}
				Tx_AbortedTrans: coverpoint uin_hdlc.Tx_AbortedTrans {
						bins No_Tx_AbortedTrans = {0};
						bins Tx_AbortedTrans = {1};
				
				}
				Tx_DataAvail: coverpoint uin_hdlc.Tx_DataAvail {
						bins No_Tx_DataAvail = {0};
						bins Tx_DataAvail = {1};
				}
		endgroup

		function new();
				Rx_cg = new;
				Tx_cg = new;
		endfunction
endclass

Rx_Tx Rx_Tx_init;

initial begin
    $display("*************************************************************");
    $display("%t - Starting Test Program", $time);
    $display("*************************************************************");

    init();
		Rx_Tx_init = new();

    //Tests:
    //Receive();
		//reset();
	
		$display("\n--- Behaviour 1 ---");
		Behaviour_1();
		reset();
		
		$display("\n--- Behaviour 2 ---");
		Behaviour_2();
		reset();
		
		$display("\n--- Behaviour 3 ---");
		Behaviour_3();
		reset();
		
		$display("\n--- Behaviour 4 ---");
		Behaviour_4();
		reset();
	
		$display("\n--- Behaviour 5 ---");
		Behaviour_5();
		reset();
		
		$display("\n--- Behaviour 6 ---");
		Behaviour_6();
		reset();
		
		$display("\n--- Behaviour 7 ---");
		Behaviour_7();
		reset();

		$display("\n--- Behaviour 8 ---");
		Behaviour_8();
		reset();
		
		$display("\n--- Behaviour 9 ---");
		Behaviour_9();
		reset();
		
		$display("\n--- Behaviour 10 ---");
		Behaviour_10();
		reset();
		
		$display("\n--- Behaviour 11 ---");
		Behaviour_11();
		reset();
		
		$display("\n--- Behaviour 12 ---");
		Behaviour_12();
		reset();
		
		$display("\n--- Behaviour 13 ---");
		Behaviour_13();
		reset();
		
		$display("\n--- Behaviour 14 ---");
		Behaviour_14();
		reset();
		
		$display("\n--- Behaviour 15 ---");
		Behaviour_15();
		reset();		

		$display("\n--- Behaviour 16 ---");
		Behaviour_16();
		reset();
		
		$display("\n--- Behaviour 17 ---");
    Behaviour_17();
		reset();
    
		$display("\n--- Behaviour 18 ---");
    Behaviour_18();
		reset();

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


task Behaviour_1();
		logic [7:0] Rx_Buff_Data;
		logic [7:0] Data;
		Data = $urandom();
		//$display("Data: %b", Data);
		
		// Send HDLC Frame
		Flag();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		Flag();
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end

		// Read Rx_Buff
		ReadAddress(Rx_Buff,Rx_Buff_Data);

		// Check Rx_Buff agains sent message
		assert (Rx_Buff_Data == Data) begin
				$display("PASS 1: Correct data in Rx_Buff according to RX input");
		end else begin
				$error("FAIL 1: Not correct data in Rx_Buff");
		end
endtask

task Behaviour_2();
		logic [7:0] Rx_Buff_Read;
		logic [7:0] Rx_Buff_Fail;
		logic [7:0] Rx_Drop;
		logic [7:0] Data;
		logic [8:0] Data_FrameError;
		Rx_Buff_Fail = 8'b00000000;
		Rx_Drop = 8'b00000010;
		Data = $urandom();
		Data_FrameError = 9'b111100101;
		
		// Abort frame
		Flag();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		AbortFrame();
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
		ReadAddress(Rx_Buff,Rx_Buff_Read);
		assert (Rx_Buff_Read == Rx_Buff_Fail) begin
				$display("PASS 2: Correct data in Rx_Buff after aborted frame");
		end else begin
				$error("FAIL 2: Not correct data in Rx_Buff after aborted frame");
		end
		
		// Frame error
		Flag();
		for(int i = 0; i < $size(Data_FrameError); i++) begin
				uin_hdlc.Rx = Data_FrameError[i];
				@(posedge uin_hdlc.Clk);
		end
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
		ReadAddress(Rx_Buff,Rx_Buff_Read);
		assert (Rx_Buff_Read == Rx_Buff_Fail) begin
				$display("PASS 2: Correct data in Rx_Buff after frame error");
		end else begin
				$error("FAIL 2: Not correct data in Rx_Buff after aborted frame");
		end
		
		// Rx_Drop
		Flag();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
		WriteAddress(Rx_SC, Rx_Drop);
		@(posedge uin_hdlc.Clk);
		ReadAddress(Rx_Buff,Rx_Buff_Read);
		assert (Rx_Buff_Read == Rx_Buff_Fail) begin
				$display("PASS 2: Correct data in Rx_Buff after Rx_Drop");
		end else begin
				$error("FAIL 2: Not correct data in Rx_Buff after Rx_Drop");
		end
endtask

task Behaviour_3();
		logic [7:0] Data;
		logic [8:0] Data_FrameError;
		Data = $urandom();
		Data_FrameError = 9'b111100101;
		
		// Send normal frame
		Flag();
		Address();
		Control();
		for(int i = 0; i < 10; i++) begin
				for(int j = 0; j < $size(Data); j++) begin
						uin_hdlc.Rx = Data[j];
						@(posedge uin_hdlc.Clk);
				end
		end
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end

		// Overflow
		Flag();
		Address();
		Control();
		for(int i = 0; i < 130; i++) begin
				for(int j = 0; j < $size(Data); j++) begin
						uin_hdlc.Rx = Data[j];
						@(posedge uin_hdlc.Clk);
				end
		end
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
		
		// FrameError
		Flag();
		Address();
		Control();
		for(int i = 0; i < 10; i++) begin
				for(int j = 0; j < $size(Data_FrameError); j++) begin
						uin_hdlc.Rx = Data_FrameError[j];
						@(posedge uin_hdlc.Clk);
				end
		end
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end

		// AbortFrame()
		Flag();
		Address();
		Control();
		for(int i = 0; i < 10; i++) begin
				for(int j = 0; j < $size(Data); j++) begin
						uin_hdlc.Rx = Data[j];
						@(posedge uin_hdlc.Clk);
				end
		end
		AbortFrame();
		Flag();
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
endtask

task Behaviour_4();
		logic [7:0] Data;
		logic [7:0] Tx_Enable;
		Data = $urandom();
		Tx_Enable = 8'b00000010;
		
		// Write data to Tx_Buff
		WriteAddress(Tx_Buff, Data);
		@(posedge uin_hdlc.Clk);
    
		// Tx_Enable
    WriteAddress(Tx_SC, Tx_Enable);
		@(posedge uin_hdlc.Clk);
		
		
		assert (uin_hdlc.Tx_DataOutBuff == Data) begin
				$display("PASS 4: Correct Tx output from Tx Buff");
		end else begin
				$error("FAIL 4: Not correct Tx output from Tx Buff");
		end
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
endtask

task Behaviour_5();
    logic [7:0] Data;
    logic [7:0] Tx_Enable;
    Data = $urandom();
    Tx_Enable = 8'b0000010;

    // Write data to Tx_Buff
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    // Tx_Enable
    WriteAddress(Tx_SC, Tx_Enable);
    
   // Wait for module to finish
    for(int i = 0; i < 100; i++) begin
				@(posedge uin_hdlc.Clk);
    end
endtask

task Behaviour_6();
    // data_hdlc inputValue;
    logic [7:0] readData;
    logic [7:0] dataIn;
    logic [7:0] transmitData;
    dataIn = 255;
    transmitData = 8'b0000010;
    
		for(int j = 0; j < 4; j=j+1) begin
        //ReadAddress(Tx_Buff, readData);
        WriteAddress(Tx_Buff, dataIn);
		end
		
    @(posedge uin_hdlc.Clk);    
    WriteAddress(Tx_SC, transmitData);
    
		repeat(10)
        @(posedge uin_hdlc.Clk)
    for(int j = 0; j < 15; j=j+1) begin
      //#20;
				@(posedge uin_hdlc.Clk);
        uin_hdlc.Rx = uin_hdlc.Tx;

		end

endtask

task Behaviour_7();
		for(int i=0; i<10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
endtask

task Behaviour_8();
		logic [7:0] Rx_FCSen;
		Rx_FCSen =  8'b00100000;
    WriteAddress(Rx_SC, Rx_FCSen);
		Flag();
		Address();
		Control();
		AbortFrame();
		// Wait for module to finish
    for(int i = 0; i < 20; i++) begin
				@(posedge uin_hdlc.Clk);
    end
		//ReadRxBuff();
		//ReadRxSC();

endtask

task Behaviour_9();
    logic [7:0] Data;
    logic [7:0] Tx_Enable;
		logic [7:0] Tx_AbortFrame;
    Data = $urandom();
    Tx_Enable = 8'b0000010;
		Tx_AbortFrame = 8'b00000110;

    // Write data to Tx_Buff
    for(int i = 0; i < 10; i++) begin
    	WriteAddress(Tx_Buff, Data);
    	@(posedge uin_hdlc.Clk);
    end

    // Tx_Enable
    WriteAddress(Tx_SC, Tx_Enable);
    @(posedge uin_hdlc.Clk);
		
		// Wait for module to finish
    for(int i = 0; i < 20; i++) begin
				@(posedge uin_hdlc.Clk);
    end
		
		// Send abort signal
		WriteAddress(Tx_SC,Tx_AbortFrame);
		@(posedge uin_hdlc.Clk);
		
		// Wait for module to finish
    for(int i = 0; i < 100; i++) begin
				@(posedge uin_hdlc.Clk);
    end
endtask

task Behaviour_10();
		logic [7:0] Rx_FCSen;
		Rx_FCSen =  8'b00100000;
		
		// Enable Rx_FCSen
		WriteAddress(3'b010, Rx_FCSen);
		@(posedge uin_hdlc.Clk);

		// HDLC frame
		Flag();
		Address();
		Control();
		
		// Send abort signal
		AbortFrame();
		
   // Wait for module to finish
    for(int i = 0; i < 10; i++) begin
				@(posedge uin_hdlc.Clk);
    end
		//ReadRxBuff();
		//ReadRxSC();
endtask

task Behaviour_11();
		automatic logic [127:0][7:0] DataArray = 1'b0;
		logic [7:0] Num_Bytes;
    logic [15:0] CRC;
		logic [15:0] CRC_check;
    logic [23:0] tmp;
		
		Num_Bytes = 6;
		DataArray[48:0] = 48'b100101000000000111111111111111111111111111111111;
		CRC_check = {DataArray[Num_Bytes-1],DataArray[Num_Bytes-2]};
		DataArray[Num_Bytes-1] = 1'b0;
    DataArray[Num_Bytes-2] = 1'b0;
		tmp[7:0]  = DataArray[0];
    tmp[15:8] = DataArray[1];
    
		for (int i = 2; i < Num_Bytes; i++) begin
      tmp[23:16] = DataArray[i];
      for (int j = 0; j < 8; j++) begin
        tmp[16] = tmp[16] ^ tmp[0];
        tmp[14] = tmp[14] ^ tmp[0];
        tmp[1]  = tmp[1]  ^ tmp[0];
        tmp[0]  = tmp[0]  ^ tmp[0];
        tmp = tmp >> 1;
      end
    end
    CRC = tmp[15:0];
		
		assert (CRC[15:0] == CRC_check[15:0]) begin
				$display("PASS 11: CRC generated succesfully");
		end else begin
				$error("ERROR 11: Did not generate CRC");
		end
endtask

task Behaviour_12();
		logic [7:0] Rx_Buff_Data;
		logic [7:0] Data;
		Data = $urandom();
		
		// Send HDLC Frame
		Flag();
		Address();
		Control();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		//AbortFrame();
		FCS();
		Flag();
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end

		// Read Rx_Buff
		ReadAddress(Rx_Buff,Rx_Buff_Data);
		@(posedge uin_hdlc.Clk);
endtask

task Behaviour_13();
		logic [7:0] Data;
		Data = $urandom();
		
		// Send on Rx
		Flag();
		for(int i = 0; i < 130; i++) begin
				for(int j = 0; j < $size(Data); j++) begin
						uin_hdlc.Rx = Data[j];
						@(posedge uin_hdlc.Clk);
				end
				//$display("Rx_FrameSize=%d", uin_hdlc.Rx_FrameSize);
		end
		Flag();

		// Wait for module to finish
		for(int i = 0; i <20; i++) begin
				@(posedge uin_hdlc.Clk);
		end

endtask

task Behaviour_14();
		logic [7:0] numBytes;
		logic [7:0] Data;
		numBytes = $urandom_range(126, 1);
		Data = $urandom();
		
		// Send frame on Rx
		Flag();
		for(int i = 0; i < numBytes; i++) begin
				for(int j = 0; j < $size(Data); j++) begin
						uin_hdlc.Rx = Data[j];
						@(posedge uin_hdlc.Clk);
				end
				//$display("Rx_FrameSize=%d", uin_hdlc.Rx_FrameSize);
		end
		Flag();

		// Wait for module to finish
		for(int i = 0; i <20; i++) begin
				@(posedge uin_hdlc.Clk);
		end
		
		//$display("Rx_FrameSize=%d",uin_hdlc.Rx_FrameSize);

		assert (uin_hdlc.Rx_FrameSize == (numBytes-2)) begin
				$display("PASS 14: Rx_FrameSize equals number of bytes recieved in a frame");
		end else begin
				$error("FAIL 14: Rx_FrameSize not equal number of bytes recieved");
		end
endtask

task Behaviour_15();
		logic [7:0] Data;
		Data = $urandom();
		
		// Send HDLC Frame
		Flag();
		Address();
		Control();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		FCS();
		Flag();
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
endtask

task Behaviour_16();
		logic [7:0] Rx_FCSen;
		logic [7:0] Data;
		logic [8:0] Data_error;
		Data = $urandom;
		Data_error = 9'b111100101;
		Rx_FCSen = 8'b00100000;
	
		// Non-byte aligned
		// Send HDLC Frame
		Flag();
		Address();
		Control();
		for(int i = 0; i < $size(Data_error); i++) begin
				uin_hdlc.Rx = Data_error[i];
				@(posedge uin_hdlc.Clk);
		end
		FCS();
		Flag();
		
		// Wait until frame is done recieving
		do 
				begin
						@(posedge uin_hdlc.Clk);
				end
		while(!uin_hdlc.Rx_EoF);

		assert (uin_hdlc.Rx_FrameError) begin
				$display("PASS 16: Rx_FrameError set after non-byte aligned data"); 
		end else begin
				$error("FAIL 16: Rx_FrameError not set after non-byte aligned data");
		end
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end

		// FCS error
		WriteAddress(Rx_SC, Rx_FCSen);
		@(posedge uin_hdlc.Clk);

		// Send HDLC Frame
		Flag();
		Address();
		Control();
		for(int i = 0; i < $size(Data); i++) begin
				uin_hdlc.Rx = Data[i];
				@(posedge uin_hdlc.Clk);
		end
		FCS();
		Flag();
		
		// Wait for module to finish
		for(int i = 0; i <10; i++) begin
				@(posedge uin_hdlc.Clk);
		end
endtask

task Behaviour_17();
    logic [7:0] Data;
    logic [7:0] Tx_Enable;
    Data = $urandom();
    Tx_Enable = 8'b0000010;

    // Write data to Tx_Buff
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    WriteAddress(Tx_Buff, Data);
    @(posedge uin_hdlc.Clk);
    
    // Tx_Enable
    WriteAddress(Tx_SC, Tx_Enable);
		@(posedge uin_hdlc.Clk);
    
   // Wait for module to finish
    for(int i = 0; i < 100; i++) begin
				@(posedge uin_hdlc.Clk);
    end
    
    // Print Tx_SC
    //ReadTxSC();
endtask

task Behaviour_18();
    logic [7:0] Data;
    logic [7:0] Tx_Enable;
    Data = $urandom();
    Tx_Enable = 8'b0000010;

    // Write data to Tx_Buff
    for(int i = 0; i < 126; i++) begin
    	WriteAddress(Tx_Buff, Data);
    	@(posedge uin_hdlc.Clk);
    end

    // Tx_Enable
    WriteAddress(Tx_SC, Tx_Enable);
    @(posedge uin_hdlc.Clk);
    @(posedge uin_hdlc.Clk);
		
    // Print Tx_SC
    //ReadTxSC();
endtask

task reset();
		uin_hdlc.Rst = 1'b0;
		#1000ns;
		uin_hdlc.Rst = 1'b1;
		#1000ns;
endtask

task init();
    uin_hdlc.Clk         =   1'b0;
    uin_hdlc.Rst         =   1'b0;
    uin_hdlc.Rx          =   1'b1;
    uin_hdlc.RxEN        =   1'b1;
    uin_hdlc.TxEN				 =   1'b1;
	
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
		ReadAddress(Rx_SC, ReadData);
		$display("Rx_SC=%b", ReadData);
endtask

task ReadRxBuff();
		logic [7:0] ReadData;
		ReadAddress(Rx_Buff, ReadData);
		$display("Rx_Buff=%b", ReadData);
endtask

task ReadRxLen();
		logic [7:0] ReadData;
		ReadAddress(Rx_Len, ReadData);
		$display("Rx_Len=%b", ReadData);
endtask

task ReadTxSC();
		logic [7:0] ReadData;
		ReadAddress(Tx_SC, ReadData);
		$display("Tx_SC=%b", ReadData);
endtask

task ReadTxBuff();
		logic [7:0] ReadData;
		ReadAddress(Tx_Buff, ReadData);
		$display("Tx_Buff=%b", ReadData);
endtask

task GenerateTestFrame();
		logic [7:0] Data_1;
		logic [7:0] Data_2;
		logic [7:0] Tx_Enable;
		Data_1 = 8'b10101010;
		Data_2 = 8'b00110011;
		Tx_Enable = 8'b00000010;
    
		// Write data to Tx buffer
		WriteAddress(Tx_Buff, Data_1);
		@(posedge uin_hdlc.Clk);
		WriteAddress(Tx_Buff, Data_2);
		@(posedge uin_hdlc.Clk);

		// Tx_Enable
		WriteAddress(Tx_SC, Tx_Enable);
		@(posedge uin_hdlc.Clk);
		
		@(posedge uin_hdlc.Tx_Done);
				for(int i=0; i < $size(test_frame); i++) begin
						@(posedge uin_hdlc.Clk);
						test_frame[i] = uin_hdlc.Tx;
				end

		$display("Test_Frame = %b", test_frame);
endtask

task FCS_new(input logic [127:0][7:0] Data, input logic [7:0] Num_Bytes, output logic [15:0] FCS_Data);
    logic [23:0] Tmp;
    Tmp[7:0]  = Data[0];
    Tmp[15:8] = Data[1];

    for (int i = 2; i < Num_Bytes + 2; i++) begin
      Tmp[23:16] = Data[i];
      for (int j = 0; j < 8; j++) begin
        Tmp[16] = Tmp[16] ^ Tmp[0];
        Tmp[14] = Tmp[14] ^ Tmp[0];
        Tmp[1]  = Tmp[1]  ^ Tmp[0];
        Tmp[0]  = Tmp[0]  ^ Tmp[0];
        Tmp = Tmp >> 1;
      end
    end
    FCS_Data = Tmp[15:0];
endtask

// HDLC Frame
task Flag();
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
endtask 
task Address();
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
endtask
task Control();
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
endtask
task Information();
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
		uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
endtask
task FCS();
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b1;
    @(posedge uin_hdlc.Clk);
    uin_hdlc.Rx = 1'b0;
		@(posedge uin_hdlc.Clk);
endtask
task AbortFrame();
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
    uin_hdlc.Rx = 1'b1;
		@(posedge uin_hdlc.Clk);
endtask

endprogram
