module uart_rx
   #(
    parameter DBIT = 8,     // # data bits
              SB_TICK = 16  // # ticks for stop bits
   )
   (
    input  logic clk, rst,
    input  logic rx, s_tick,
    output logic rx_done_tick,
    output logic [7:0] dout
   );

   // fsm state type 
   typedef enum {idle, start, data, stop} state_type;

   // signal declaration
   state_type state_reg, state_next;
   logic [3:0] s_reg, s_next;
   logic [2:0] n_reg, n_next;
   logic [7:0] b_reg, b_next;

   // body
   // FSMD state & data registers
   always_ff @(posedge clk, posedge rst)
      if (rst) begin
         state_reg <= idle;
         s_reg <= 0;
         n_reg <= 0;
         b_reg <= 0;
      end
      else begin
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
      end

   // FSMD next-state logic
   always_comb
   begin
      state_next = state_reg;
      rx_done_tick = 1'b0;
      s_next = s_reg;
      n_next = n_reg;
      b_next = b_reg;

      case (state_reg)
         idle: begin
            if (~rx) begin
               state_next = start;
               s_next = 0;
            end
         end

         start: begin
            if (s_tick) begin
               if (s_reg==7) begin
                  state_next = data;
                  s_next = 0;
                  n_next = 0;
               end
               else begin
                  s_next = s_reg + 1;
               end
            end
         end

         data: begin
            if (s_tick)
               if (s_reg==15) begin
                  s_next = 0;
                  b_next = {rx, b_reg[7:1]};
                  if (n_reg==(DBIT-1)) begin
                     state_next = stop;
                  end
                  else begin
                     n_next = n_reg + 1;
                  end
               end
               else begin
                  s_next = s_reg + 1;
               end
         end

         stop: begin
            if (s_tick) begin
               if (s_reg==(SB_TICK-1)) begin
                  state_next = idle;
                  rx_done_tick =1'b1;
               end
               else begin
                  s_next = s_reg + 1;
               end
            end
         end

      endcase
   end
   
   // output
   assign dout = b_reg;
endmodule