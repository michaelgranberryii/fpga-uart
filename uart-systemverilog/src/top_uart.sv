module top_uart
   #(
        parameter FIFO_W = 0,  // # addr bits of FIFO
        parameter N = 11,
        parameter DATA_WIDTH = 8
    )
   (
        input  logic clk,
        input  logic rst,

        // slot interface
        output logic [3:0] led,
        output logic led_r,
        output logic led_g,
        output logic led_b,
        output logic tx,
        input  logic rx    
   );

   // signal declaration
   parameter [(N-1):0] dvsr = 68;

   logic wr_en;
   logic wr_uart;
   logic rd_uart;
   logic wr_dvsr;
   logic tx_full;
   logic rx_empty;
   logic [(DATA_WIDTH-1):0] r_data;
   logic [(DATA_WIDTH-1):0] w_data;
   logic [(N-1):0] dvsr_reg;

   // body
   uart #(.DBIT(8), .SB_TICK(16), .FIFO_W(FIFO_W)) uart_i
   (
        .clk(clk),
        .rst(rst),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .dvsr(dvsr),
        .rx(rx),
        .w_data(w_data),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .r_data(r_data),
        .tx(tx)   
   );

    assign led = r_data[3:0];
    assign wr_uart = 1'b1;
    assign rd_uart = 1'b1;
    // w_data // Alwasy on

endmodule

