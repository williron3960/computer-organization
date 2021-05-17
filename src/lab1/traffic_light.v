module traffic_light (clk, rst, pass, R, G, Y);

//write your code here
input clk, rst, pass;
output reg R;
output reg G;
output reg Y;


reg [2:0] state; // 7 states
// num : state   cycles
// 000 : Green 1024cycles
// 001 : None  128cycles
// 010 : Green 128cycles
// 011 : None  128cycles
// 100 : Green 128cycles
// 101 : Yello 512cycles
// 110 : Red   1024cycles

reg [10:0] cycle; // max 2047 cycles but we need 1024, so using 11 bit for this reg

always@(posedge clk or posedge rst) begin //

  if (rst) begin
      R <= 0;
      G <= 1;
      Y <= 0;
      state <= 3'd0;
      cycle <= 11'd1;
  end

  else if (pass) begin
      if (state != 3'd0) begin
        R <= 0;
        G <= 1;
        Y <= 0;
        state <= 3'd0;
        cycle <= 11'd1;
      end
      else cycle <= cycle + 11'd1;
  end

  else begin

    cycle <= cycle + 11'd1;

    if (state == 3'd0) begin // 000 for Green 1024 cycles
      R <= 0;
      G <= 1;
      Y <= 0;
      if (cycle == 11'd1023) begin
        state <= 3'd1;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd1) begin //001 for none 128 cycles
      R <= 0;
      G <= 0;
      Y <= 0;
      if (cycle == 11'd127) begin
        state <= 3 'd2;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd2) begin //010 for Green 128 cycles
      R <= 0;
      G <= 1;
      Y <= 0;
      if (cycle == 11'd127) begin
        state <= 3'd3;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd3) begin //011 for none 128 cycles
      R <= 0;
      G <= 0;
      Y <= 0;
      if (cycle == 11'd127) begin
        state <= 3'd4;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd4) begin //100 for Green 128 cycles
      R <= 0;
      G <= 1;
      Y <= 0;
      if (cycle == 11'd127) begin
        state <= 3'd5;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd5) begin //101 for Yellow 512 cycles
      R <= 0;
      G <= 0;
      Y <= 1;
      if (cycle == 11'd511) begin
        state <= 3'd6;
        cycle <= 11'd0;
      end
    end

    else if (state == 3'd6) begin //110 for Red 1024cycles
      R <= 1;
      G <= 0;
      Y <= 0;
      if (cycle == 11'd1023) begin
        state <= 3'd0;
        cycle <= 11'd0;
      end
    end

  end
end

endmodule
