// Please include verilog file if you write module in other file
module CPU(
    input             clk,
    input             rst,
    input      [31:0] data_out,
    input      [31:0] instr_out,
    output reg        instr_read,
    output reg        data_read,
    output reg [31:0] instr_addr,
    output reg [31:0] data_addr,
    output reg [3:0]  data_write,
    output reg [31:0] data_in
);
/* Add your design */
reg [31:0] count;
reg [2:0] state;
reg [63:0] temp;
reg [31:0] register [31:0];
reg [31:0] pc;

always@(posedge clk) begin
	if(rst) begin
		register[0] = 32'd0;
		pc = 32'd0;
		state = 3'd0;
		count = 32'd0;
	end
	else begin
        if (state == 3'd0) begin
                register[0] = 0;
				state <= 3'd1;
				instr_addr <= pc;
				instr_read <= 1;
				data_read <= 0;
				data_write <= 4'b0000;
				count = count + 1;
        end
        else if (state == 3'd1) begin
            state <= 3'd2;
        end
        else if (state == 3'd2) begin
                case(instr_out[6:0])
					7'b0110011:
					begin
						instr_read <= 0;
						data_read <= 0;
						data_write <= 4'b0000;
                        state <= 3'd0;
						pc = pc + 32'd4;
						if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b110 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] | register[instr_out[24:20]];
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b111 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] & register[instr_out[24:20]];
						end
						else if (instr_out[31:25] == 7'b0100000 && instr_out[14:12] == 3'b000 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] - register[instr_out[24:20]];
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b001 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] << register[instr_out[24:20]][4:0];
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b000 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] + register[instr_out[24:20]];
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b010 ) begin
							register[instr_out[11:7]] <= ($signed(register[instr_out[19:15]]) < $signed(register[instr_out[24:20]])) ? 1 : 0;
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b101 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] >> register[instr_out[24:20]][4:0] ;
						end
						else if (instr_out[31:25] == 7'b0100000 && instr_out[14:12] == 3'b101 ) begin
							register[instr_out[11:7]] <= $signed(register[instr_out[19:15]]) >> register[instr_out[24:20]][4:0] ;
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b011 ) begin
							register[instr_out[11:7]] <= (register[instr_out[19:15]] < register[instr_out[24:20]]) ? 1 : 0;
						end
						else if (instr_out[31:25] == 7'b0000000 && instr_out[14:12] == 3'b100 ) begin
							register[instr_out[11:7]] <= register[instr_out[19:15]] ^ register[instr_out[24:20]];
						end
						else if (instr_out[31:25] == 7'b0000001 && instr_out[14:12] == 3'b000 ) begin
							register[instr_out[11:7]] <= $signed(register[instr_out[19:15]]) * $signed(register[instr_out[24:20]]);
						end
						else if (instr_out[31:25] == 7'b0000001 && instr_out[14:12] == 3'b001 ) begin
							temp = $signed(register[instr_out[19:15]]) * $signed(register[instr_out[24:20]]);
							register[instr_out[11:7]] = temp[63:32];
						end
						else if (instr_out[31:25] == 7'b0000001 && instr_out[14:12] == 3'b011 ) begin
							temp = $unsigned(register[instr_out[19:15]]) * $unsigned(register[instr_out[24:20]]);
							register[instr_out[11:7]] = temp[63:32];
						end
					end
					7'b0000011:
					begin
						data_addr <= register[instr_out[19:15]] + {{20{instr_out[31]}}, instr_out[31:20]};
						instr_read <= 1;
						data_read <= 1;
						data_write <= 4'b0000;
                        state <= 3'd3;
						instr_addr <= pc;
					end
					7'b0010011:
					begin
						state <= 3'd0;
						pc = pc + 32'd4;
						instr_read <= 0;
						data_read <= 0;
						data_write <= 4'b0000;
						case(instr_out[14:12])
							3'b011: register[instr_out[11:7]] <= ($unsigned(register[instr_out[19:15]]) < $unsigned({{20{instr_out[31]}}, instr_out[31:20]})) ? 1 : 0;
							3'b100: register[instr_out[11:7]] <= register[instr_out[19:15]] ^ {{20{instr_out[31]}}, instr_out[31:20]};
							3'b111: register[instr_out[11:7]] <= register[instr_out[19:15]] & {{20{instr_out[31]}}, instr_out[31:20]};
							3'b110: register[instr_out[11:7]] <= register[instr_out[19:15]] | {{20{instr_out[31]}}, instr_out[31:20]};3'b000: register[instr_out[11:7]] <= register[instr_out[19:15]] + {{20{instr_out[31]}}, instr_out[31:20]};
							3'b010: register[instr_out[11:7]] <= ($signed(register[instr_out[19:15]]) < $signed({{20{instr_out[31]}}, instr_out[31:20]})) ? 1 : 0;
							3'b001: register[instr_out[11:7]] <= register[instr_out[19:15]] << instr_out[24:20];
							3'b101:
							begin
								if (instr_out[31:25] == 7'b0100000) begin
									register[instr_out[11:7]] <= $signed(register[instr_out[19:15]]) >>> instr_out[24:20];
								end
								else if(instr_out[31:25] == 7'b0000000) begin
									register[instr_out[11:7]] <= register[instr_out[19:15]] >> instr_out[24:20];
								end
							end
							default: ;
						endcase
					end
					7'b1100111:
					begin
						instr_read <= 0;
						data_read <= 0;
						data_write <= 4'b0000;
						register[instr_out[11:7]] <= pc + 32'd4;
						pc <= {{20{instr_out[31]}}, instr_out[31:20]} + register[instr_out[19:15]];
						state <= 3'd0;
						//$display("JALR");
					end
					7'b0100011:
					begin
						data_addr = register[instr_out[19:15]] + {{20{instr_out[31]}}, instr_out[31:25], instr_out[11:7]};
						state <= 3'd0;
						pc = pc + 32'd4;
						instr_read <= 1;
						data_read <= 0;
						case(instr_out[14:12])
							3'b010:
							begin
								data_in <= register[instr_out[24:20]];
								data_write <= 4'b1111;
							end
							3'b000:
							begin
								data_in <= {register[instr_out[24:20]][7:0], register[instr_out[24:20]][7:0], register[instr_out[24:20]][7:0], register[instr_out[24:20]][7:0]};
								if (data_addr[1:0] == 2'b00) begin
									data_write <= 4'b0001;
								end
								else if (data_addr[1:0] == 2'b01) begin
									data_write <= 4'b0010;
								end
								else if (data_addr[1:0] == 2'b10) begin
									data_write <= 4'b0100;
								end
								else if (data_addr[1:0] == 2'b11) begin
									data_write <= 4'b1000;
								end
							end
							3'b001:
							begin
								data_in <= {register[instr_out[24:20]][15:0], register[instr_out[24:20]][15:0]};
								if (data_addr[1:0] == 2'b10) begin
									data_write <= 4'b1100;
								end
								else if (data_addr[1:0] == 2'b00) begin
									data_write <= 4'b0011;
								end
							end
							default: ;
						endcase
					end
					7'b1100011:
					begin
						state <= 3'd0;
						instr_read <= 0;
						data_read <= 0;
						data_write <= 4'b0000;
						case(instr_out[14:12])
							3'b100: pc = ($signed(register[instr_out[19:15]]) < $signed(register[instr_out[24:20]])) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							3'b101: pc = ($signed(register[instr_out[19:15]]) >= $signed(register[instr_out[24:20]])) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							3'b000: pc = (register[instr_out[19:15]] == register[instr_out[24:20]]) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							3'b001: pc = (register[instr_out[19:15]] != register[instr_out[24:20]]) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							3'b110: pc = (register[instr_out[19:15]] < register[instr_out[24:20]]) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							3'b111: pc = (register[instr_out[19:15]] >= register[instr_out[24:20]]) ? pc + {{19{instr_out[31]}}, instr_out[31], instr_out[7], instr_out[30:25], instr_out[11:8], 1'b0} : pc + 4;
							default: ;
						endcase
					end
					7'b0010111:
					begin
						register[instr_out[11:7]] <= pc + {instr_out[31:12], 12'd0};
						data_read <= 0;
						state <= 3'd0;
						pc = pc + 32'd4;
						instr_read <= 0;
						data_write <= 4'b0000;
					end
					7'b0110111:
					begin
						register[instr_out[11:7]] <= {instr_out[31:12], 12'd0};
						instr_read <= 0;
						data_read <= 0;
						state <= 3'd0;
						pc = pc + 32'd4;
						data_write <= 4'b0000;
					end
					7'b1101111:
					begin
						register[instr_out[11:7]] <= pc + 32'd4;
						pc = pc + {{11{instr_out[31]}}, instr_out[31], instr_out[19:12], instr_out[20], instr_out[30:21], 1'b0};
						state <= 3'd0;
						instr_read <= 0;
						data_read <= 0;
						data_write <= 4'b0000;
						//$display("JAL");
					end
					default: ;
				endcase
        end
        else if (state == 3'd3) begin
            data_read <= 1;
            data_write <= 4'b0000;
			state <= 3'd4;
            data_addr <= register[instr_out[19:15]] + {{20{instr_out[31]}}, instr_out[31:20]};
            instr_read <= 1;
        end
        else if (state == 3'd4) begin
            data_read <= 0;
            data_write <= 4'b0000;
			state <= 3'd0;
            pc = pc + 32'd4;
            instr_read <= 0;
			if (instr_out[14:12] == 3'b010) begin
				register[instr_out[11:7]] <= data_out;
			end
			else if (instr_out[14:12] == 3'b000) begin
				register[instr_out[11:7]] <= {{24{data_out[7]}}, data_out[7:0]};
			end
			else if (instr_out[14:12] == 3'b001) begin
				register[instr_out[11:7]] <= {{16{data_out[15]}}, data_out[15:0]};
			end
			else if (instr_out[14:12] == 3'b100) begin
				register[instr_out[11:7]] <= {24'd0, data_out[7:0]};
			end
			else if (instr_out[14:12] == 3'b101) begin
				register[instr_out[11:7]] <= {16'd0, data_out[15:0]};
			end
        end
	end
end

endmodule
