`timescale 1ns / 1ps

module top_uart
    #(
        parameter DBIT = 8,
        parameter SB_TICK = 16,
        parameter FIFO_W = 0,
        parameter DATA_WIDTH = 8
    )
    (
    input clk,
    input rst,
    output [3:0] led,
    output [7:0] ld,
    output led_r,
    output led_g,
    output led_b,
    output tx,
    input rx
    );
    
    parameter [10:0] dvsr = 11'd68;


    logic wr_en;
    logic wr_uart;
    logic rd_uart;
    logic wr_dvsr;
    logic tx_full;
    logic rx_empty;
    logic [7:0] r_data;
    logic [7:0] w_data;
    logic [10:0] dvsr_reg;

    logic tx_almost_empty;
    logic tx_almost_full;
    logic [(DATA_WIDTH-1):0] tx_word_count;

    logic rx_almost_empty;
    logic rx_almost_full;
    logic [(DATA_WIDTH-1):0] rx_word_count; 

    uart uart_i 
    #(
        .DBIT(DBIT),
        .SB_TICK(SB_TICK),
        .FIFO_W(FIFO_W)
    )
    (
        .clk(clk),
        .rst(rst),
        .rd_uart(rd_uart),
        .wr_uart(wr_dvsr),
        .dvsr(dvsr),
        .rx(rx),
        .w_data(w_data),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .r_data(r_data),
        .tx(tx)
        .tx_almost_empty(tx_almost_empty),
        .tx_almost_full(tx_almost_full),
        .tx_word_count(tx_word_count),
        .rx_almost_empty(rx_almost_empty),
        .rx_almost_full(rx_almost_full),
        .rx_word_count(rx_word_count)
    );

    assign led = r_data[3:0];
    assign wr_uart = 1'b1;
    assign rd_uart = 1'b1;
    assign ld = {tx_almost_empty, tx_almost_full,}
endmodule
