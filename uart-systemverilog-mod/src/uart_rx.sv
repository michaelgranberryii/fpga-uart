`timescale 1ns / 1ps

module uart_rx
    #(
    parameter DBIT = 8,
    parameter SB_TICK = 16
    )
    (
    input logic clk,
    input logic rst,
    input logic rx,
    input logic s_tick,
    output logic rx_done_tick,
    output logic [7:0] done,
    output logic dout
    );

    typedef enum  {idle, start, data, stop} state_t;
    state_t state_reg, state_next;
    logic [4:0] s_reg, s_next;
    logic [2:0] n_reg, n_next;
    logic [7:0] b_reg, b_next;
    logic sync1_reg;
    logic sync2_reg;
    logic sync_rx;

    // synchronization for rx
    always_ff @ (posedge clk, posedge rst) begin
        if (rst) 
            begin
                sync1_reg <= 0;
                sync2_reg <= 0;
            end
        else
            begin
                sync1_reg <= rx;
                sync2_reg <= sync1_reg;
            end

    end

    assign sync_rx = sync2_reg;

    // FSMD state & data registers
    always_ff @ (posedge clk, posedge rst) begin
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
    end

    // next-state logic & data path
    always_comb @ (state_reg, s_reg, n_reg, b_reg, s_tick) begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= 0;

        case (state_reg)
            idle:
            begin
                if (sync_rx == 0) begin
                    state_next <= start;
                    s_next <= 0;
                end
            end
            
            start:
            begin
                if (s_tick == 1) begin
                    if (s_reg == 7) begin
                        state_next <= data;
                        s_next <= 0;
                        n_next <= 0;
                    end
                end
                else begin
                    s_next <= s_reg + 1;
                end
            end

            data:
            begin
                if (s_tick == 1) begin
                    if (s_reg == 15) begin
                        s_next <= 0;
                        b_next <= {sync_rx, b_reg[7:1]};
                        if (n_reg == (DBIT - 1)) begin
                            state_next <= stop;
                        end
                        else begin
                            n_next <= n_reg + 1;
                        end
                    end
                    else begin
                        s_next <= s_reg + 1;
                    end
                end
            end

            stop:
            begin
                if (s_tick == 1) begin
                    if (s_reg == (SB_TICK - 1)) begin
                        state_next <= idle;
                        rx_done_tick <= 1;
                    end
                    else begin
                        s_next <= s_reg + 1;
                    end
                end
            end
        endcase
    end

    assign dout = b_reg;
    
endmodule
