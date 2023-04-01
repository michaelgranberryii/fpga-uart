module baud_gen
   #(
      parameter N = 11
   )
   (
    input  logic clk, 
    input  logic rst,
    input  logic [(N-1):0] dvsr,
    output logic tick
   );

   // declaration
   logic [(N-1):0] r_reg;
   logic [(N-1):0] r_next;

   // body
   // register
   always_ff @(posedge clk, posedge rst) begin
      if (rst) begin
         r_reg <= 0;
      end
      else begin
         r_reg <= r_next;
      end
   end

   // next-state logic
   assign r_next = (r_reg==dvsr) ? 0 : r_reg + 1;

   // output logic
   assign tick = (r_reg==1);

endmodule