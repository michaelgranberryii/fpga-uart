`timescale 1ns / 1ps

module uart
    #(
        parameter DBIT = 8,
        parameter SB_TICK = 16,
        parameter FIFO_W = 4,
        parameter DATA_WIDTH = 8
    )
    (
        input clk, // original
        input rst, // original
        input rd_uart, // original
        input wr_uart, // original
        input [10:0] dvsr, // original
        input rx, // original
        input [(DATA_WIDTH-1):0] w_data, // original
        input [(DATA_WIDTH-1):0] r_data, // original
        output tx_full, // original
        output tx_almost_empty,
        output tx_almost_full,
        output [FIFO_W:0] tx_word_count,

        output rx_empty, // original
        output rx_almost_empty,
        output rx_almost_full,
        output [FIFO_W:0] rx_word_count,

        output tx // original
    );

    logic tick;
    logic rx_done_tick;
    logic [7:0] tx_fifo_out;
    logic [7:0] rx_data_out;
    logic tx_empty;
    logic tx_fifo_not_empty;
    logic tx_done_tick;

    baud_gen  baud_gen_unit (.clk(clk), .rst(rst), .dvsr(dvsr), .tick(tick));

    uart_rx  #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit
    (.clk(clk), .rst(rst), .rx(rx), .s_tick(s_tick), .rx_done_tick(rx_done_tick), .dout(rx_data_out));

    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit
    (.clk(clk), .rst(rst), .tx_start(tx_fifo_not_empty), .s_tick(tick), .din(tx_fifo_out), .tx_done_tick(tx_done_tick), .tx(tx));

    fifo_ex_stat #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_rx_unit
    (.clk(clk), .reset(rst), .rd(rd_uart), .wr(rx_data_out), .w_data(rx_data_out), .empty(rx_empty), .full(), .almost_empty(rx_almost_empty), .almost_full(rx_almost_full), .word_count(rx_word_count), .r_data(r_data));

    fifo_ex_stat #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_tx_unit
    (.clk(clk), .reset(rst), .rd(tx_done_tick), .wr(wr_uart), .w_data(w_data), .empty(tx_empty), .full(tx_full), .almost_empty(tx_almost_empty), .almost_full(tx_almost_full), .word_count(tx_word_count), .r_data(tx_fifo_out));

    
endmodule
