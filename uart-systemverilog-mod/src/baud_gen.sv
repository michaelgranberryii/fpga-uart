`timescale 1ns / 1ps

module baud_gen(
    input logic clk,
    input logic rst,
    input logic  [10:0] dvsr,
    input logic tick
    );

    parameter N = 11;
    logic [(N-1):0] r_reg;
    logic [(N-1):0] r_next;
    

    // body

    always_ff @( posedge clk, posedge rst ) begin
        if (rst) begin
            r_reg <= 0;
        end
        else begin
            r_reg <= r_next;
        end
    end

    // nexy state logic

    assign r_next = (r_reg == dvsr) ? 0 : r_reg + 1;

    // output logic


    assign tick = (r_reg == 1);
endmodule