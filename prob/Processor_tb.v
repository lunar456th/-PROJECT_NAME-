`include "Processor.v"

`define TEST_PROB

module Processor_tb (
	);

	parameter MEM_WIDTH = 32;
	parameter MEM_SIZE = 256;

	reg clk;
	reg reset;
	wire led;
	wire led3;
	wire led2;
	wire led1;
	wire led0;
`ifdef TEST_PROB
	wire clk_prob;
	wire [$clog2(MEM_SIZE)-1:0] mem_addr_prob;
	wire mem_read_en_prob;
	wire [MEM_WIDTH-1:0] mem_read_val_prob;
	wire MemRead_prob;
	wire stall_prob;
	wire [31:0] Instruction_prob;
	wire [31:0] ALUout_prob;
	wire [31:0] PC_addr_prob;
	wire [$clog2(MEM_SIZE)-1:0] mem_addr_instr_prob;
	wire mem_read_en_instr_prob;
	wire [MEM_WIDTH-1:0] mem_read_val_instr_prob;
	wire [$clog2(MEM_SIZE)-1:0] mem_addr_data_prob;
	wire mem_read_en_data_prob;
	wire [MEM_WIDTH-1:0] mem_read_val_data_prob;
	wire token_prob;
`endif

	Processor _Processor (
		.clk(clk),
		.reset(reset),
		.led(led),
		.led3(led3),
		.led2(led2),
		.led1(led1),
		.led0(led0)
`ifdef TEST_PROB
		,
		// processor
		.clk_prob(clk_prob),
		.mem_read_en_prob(mem_read_en_prob),
		.mem_read_val_prob(mem_read_val_prob),
		.mem_read_val_instr_prob(mem_read_val_instr_prob),
		// core
		.MemRead_prob(MemRead_prob),
		.stall_prob(stall_prob),
		// datapath
		.PC_addr_prob(PC_addr_prob),
		.Instruction_prob(Instruction_prob),
		.ALUout_prob(ALUout_prob),
		.mem_addr_instr_prob(mem_addr_instr_prob),
		.mem_read_en_instr_prob(mem_read_en_instr_prob),
		.mem_addr_prob(mem_addr_prob),
		.mem_addr_data_prob(mem_addr_data_prob),
		.mem_read_en_data_prob(mem_read_en_data_prob),
		.mem_read_val_data_prob(mem_read_val_data_prob),
		// memoryselector
		.token_prob(token_prob)
`endif
	);

	initial
	begin
		clk <= 1'b0;
		reset <= 1'b0;
		forever
		begin
			#1 clk = ~clk;
		end
	end

	initial
	begin
		// Nothing to do. The program is hard-wired.
	end

endmodule

`endif /*__PROCESSOR_V__*/
