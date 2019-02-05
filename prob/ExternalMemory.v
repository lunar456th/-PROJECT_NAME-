`ifndef __EXTERNALMEMORY_V__
`define __EXTERNALMEMORY_V__

module ExternalMemory # (
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256
	)	(
	input wire [$clog2(MEM_SIZE)-1:0] mem_addr,
	input wire mem_read_en,
	input wire mem_write_en,
	output reg [MEM_WIDTH-1:0] mem_read_val,
	input wire [MEM_WIDTH-1:0] mem_write_val
	);

	reg [MEM_WIDTH-1:0] memory[0:MEM_SIZE-1];

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
		for (i = 16; i < 212; i = i + 1)
		begin
			memory[i] <= 32'h0;
		end
		// Instruction
		memory[212] <= 32'h00001825;
		memory[213] <= 32'h24020001;
		memory[214] <= 32'hAC620000;
		memory[215] <= 32'h24020001;
		memory[216] <= 32'h24030002;
		memory[217] <= 32'hAC430000;
		memory[218] <= 32'h24020002;
		memory[219] <= 32'h24030003;
		memory[220] <= 32'hAC430000;
		memory[221] <= 32'h24020003;
		memory[222] <= 32'h24030004;
		memory[223] <= 32'hAC430000;
		memory[224] <= 32'h24020004;
		memory[225] <= 32'h24030005;
		memory[226] <= 32'hAC430000;
		memory[227] <= 32'h24020005;
		memory[228] <= 32'h24030006;
		memory[229] <= 32'hAC430000;
		memory[230] <= 32'h24020006;
		memory[231] <= 32'h24030007;
		memory[232] <= 32'hAC430000;
		memory[233] <= 32'h24020007;
		memory[234] <= 32'h24030008;
		memory[235] <= 32'hAC430000;
		memory[236] <= 32'h00001025;
		memory[237] <= 32'h8C500000;
		memory[238] <= 32'h24020001;
		memory[239] <= 32'h8C500000;
		memory[240] <= 32'h24020002;
		memory[241] <= 32'h8C500000;
		memory[242] <= 32'h24020003;
		memory[243] <= 32'h8C500000;
		memory[244] <= 32'h24020004;
		memory[245] <= 32'h8C500000;
		memory[246] <= 32'h24020005;
		memory[247] <= 32'h8C500000;
		memory[248] <= 32'h24020006;
		memory[249] <= 32'h8C500000;
		memory[250] <= 32'h24020007;
		memory[251] <= 32'h8C500000;
		memory[252] <= 32'h00001025;
		memory[253] <= 32'h00000000;
		memory[254] <= 32'h00000000;
		memory[255] <= 32'h00000000;

		mem_read_val <= 32'b0;
	end

	always @ (mem_addr or mem_read_en or mem_write_en or mem_write_val)
	begin
		if (mem_read_en)
		begin
			mem_read_val <= memory[mem_addr];
		end

		if (mem_write_en)
		begin
			memory[mem_addr] <= mem_write_val;
		end
	end

endmodule

`endif /*__EXTERNALMEMORY_V__*/
