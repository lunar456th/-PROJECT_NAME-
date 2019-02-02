`ifndef __PC_V__
`define __PC_V__

module PC # (
	parameter PC_START_ADDRESS = 212,
	parameter PC_END_ADDRESS = 255
	)   (
	input wire clk,
	input wire reset,
	input wire [31:0] ain,
	// pecsel = branch & zero
	output reg [31:0] aout = PC_START_ADDRESS,
	input wire pcsel,
	input wire stall
	);

	integer stall_cnt = 0;

	always @ (posedge clk)
	begin
		if (stall)
		begin
			stall_cnt = 2; // suppose that memory operations require 3 cycles.
		end

		stall_cnt = stall_cnt > 0 ? stall_cnt - 1 : 0;
	end

	always @ (posedge clk)
	begin
		if (reset)
		begin
			aout <= PC_START_ADDRESS;
		end
		else
		begin
			if (aout < PC_END_ADDRESS) // temporary limitation
			begin
				if (pcsel)
				begin
					aout <= ain + aout + 1; // branch
				end
				else if (stall_cnt)
				begin
					aout <= aout;
				end
				else
				begin
					aout <= aout + 1;
				end
			end
		end
	end

endmodule

`endif /*__PC_V__*/
