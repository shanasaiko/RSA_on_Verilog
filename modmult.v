`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 19:46:16
// Design Name: 
// Module Name: modmult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module montgomery(
    input [1023:0] mpand, //multiplicand
    input [1023:0] mplier, //multiplier
    input [1023:0] modulus, //modulus
    input clk,      //clock signal
    input rst_n,      //reset signal
    input ds,   
    
    output ready,
    output [1023:0] product //result
);

reg [1023:0] mpreg;
reg [1025:0] mcreg;
wire [1025:0] mcreg1;
wire [1025:0] mcreg2;
reg [1025:0] modreg1;
reg [1025:0] modreg2;
reg [1025:0] prodreg;
wire [1025:0] prodreg1;
wire [1025:0] prodreg2;
wire [1025:0] prodreg3;
wire [1025:0] prodreg4;
wire [1:0] modstate;
reg     first;      //Íê³É·û

assign product = prodreg4[1023:0];
assign prodreg1 = mpreg[0] ? (prodreg + mcreg) : prodreg;
assign prodreg2 = prodreg1 - modreg1;
assign prodreg3 = prodreg1 - modreg2;
assign modstate = {prodreg3[1025], prodreg2[1025]}; 
assign prodreg4 = (modstate == 2'b11) ? prodreg1 : ((modstate == 2'b10) ? prodreg2 :prodreg3);

assign mcreg1 = mcreg - modreg1;
assign mcreg2 = mcreg1[1024] ? mcreg : mcreg1;
assign ready = first;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        first <= 1'b1;
    end
    else begin
        if(first)begin
            if(ds)begin
                mpreg <= mplier;
                mcreg <= {2'b00, mpand};
                modreg1 <= {2'b00, modulus};
                modreg2 <= {1'b0, modulus, 1'b0};
                prodreg <=  {1026{1'b0}};
                first <= 1'b0;
            end
        end
        else begin
            if(mpreg == 1024'd0)
                first <= 1'b1;
            else begin
                mcreg <= {mcreg2[1024:0], 1'b0};
                mpreg <= {1'b0, mpreg[1023:1]};
                prodreg <=  prodreg4;
            end
        end
    end
end

endmodule
