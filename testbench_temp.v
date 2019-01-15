module Testbench();
    reg [31:0] memory_addr;
    reg memory_rden;
    reg memory_wren;
    wire [31:0] memory_read_val;
    reg [31:0] memory_write_val;
    wire memory_response;
    
    TemporaryMemory unit1(memory_addr, memory_rden, memory_wren, memory_read_val, memory_write_val, memory_response);

    initial
    begin
        #5;
        memory_addr <= 32'd0;
        #5;
        memory_rden <= 1'b0;
        #5;
        memory_wren <= 1'b1;
        #5;
        memory_write_val <= 32'd1;
        #5;
        // memory_addr = 32'd1; memory_rden = 1'b0; memory_wren = 1'b1; memory_write_val = 32'd2; #5;
        // memory_addr = 32'd2; memory_rden = 1'b0; memory_wren = 1'b1; memory_write_val = 32'd3; #5;
        // memory_addr = 32'd3; memory_rden = 1'b0; memory_wren = 1'b1; memory_write_val = 32'd4; #5;
        // memory_addr = 32'd4; memory_rden = 1'b0; memory_wren = 1'b1; memory_write_val = 32'd5; #5;
        $finish;
	end
	
	always @ (*)
	begin
		$monitor("memory_addr = %d", memory_addr);
		$monitor("memory_rden = %d", memory_rden);
		$monitor("memory_wren = %d", memory_wren);
		$monitor("memory_read_val = %d", memory_read_val);
		$monitor("memory_write_val = %d", memory_write_val);
		$monitor("memory_response = %d", memory_response);	
	end

endmodule

module TemporaryMemory (
	input wire [31:0] memory_addr,
	input wire memory_rden,
	input wire memory_wren,
	output reg [31:0] memory_read_val,
	input wire [31:0] memory_write_val,
	output reg memory_response
	);

	reg [31:0] memory[0:255];
	
	integer i;

	initial
	begin
        memory[0] <= 32'h0000_0001; //0
        memory[1] <= 32'h0000_0000; //1
        memory[2] <= 32'h0000_0000; //2
        memory[3] <= 32'h0000_0000; //3
        memory[4] <= 32'h0000_0001; //4
        memory[5] <= 32'h0000_0000; //5
        memory[6] <= 32'h0000_0000; //6
        memory[7] <= 32'h0000_0000; //7
        memory[8] <= 32'h0000_0001; //8
        memory[9] <= 32'h0000_0000; //9
        memory[10] <= 32'h0000_0000; //10
        memory[11] <= 32'h0000_0001; //11
        memory[12] <= 32'h0000_0000; //12
        memory[13] <= 32'h0000_0000; //13
        memory[14] <= 32'h0000_0000; //14
        memory[15] <= 32'h0000_0001; //15
        for (i = 16; i < 242; i = i + 1)
        begin
            memory[i] <= 32'h0;
        end
        // Instruction
        memory[242] <= 32'h00004020;
        memory[243] <= 32'h00007020;
        memory[244] <= 32'h8d090040;
        memory[245] <= 32'h8d0a0044;
        memory[246] <= 32'h8d0b0048;
        memory[247] <= 32'had00004c;
        memory[248] <= 32'h8d0c0000;
        memory[249] <= 32'h8dcd004c;
        memory[250] <= 32'h01ac6820;
        memory[251] <= 32'hadcd004c;
        memory[252] <= 32'h012a4822;
        memory[253] <= 32'h010b4020;
        memory[254] <= 32'h11200001;
        memory[255] <= 32'h1129fff8;
        
    	memory_read_val <= 32'd0;
    	memory_response <= 1'b0;
	end

	localparam STATE_READY = 3'b000;
	localparam STATE_READ = 3'b001;
	localparam STATE_READ_DONE = 3'b010;
	localparam STATE_WRITE = 3'b011;
	localparam STATE_WRITE_DONE = 3'b100;

	reg [2:0] state = STATE_READY;

	always @ (*)
	begin
		case (state)
			STATE_READY:
			begin
            	memory_response <= 1'b0;
				if (memory_rden)
				begin
					state <= STATE_READ;
				end
				if (memory_wren)
				begin
					state <= STATE_WRITE;
				end
			end

			STATE_READ:
			begin
				memory_read_val <= memory[memory_addr];
				memory_response <= 1'b1;
				state <= STATE_READ_DONE;
			end

			STATE_READ_DONE:
			begin
				memory_response <= 1'b0;
				state <= STATE_READY;
			end

			STATE_WRITE:
			begin
				memory[memory_addr] <= memory_write_val;
				memory_response <= 1'b1;
				state <= STATE_WRITE_DONE;
			end

			STATE_WRITE_DONE:
			begin
				memory_response <= 1'b0;
				state <= STATE_READY;
			end
			
			default:
			begin
				state <= STATE_READY;
			end
		endcase
	end

endmodule
