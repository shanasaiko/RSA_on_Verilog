`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/28 15:56:41
// Design Name: 
// Module Name: RSACypher
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


module RSACypher(
//    input   [1023:0] indata,
//    input   [1023:0] inExp,
//    input   [1023:0] inMod,
//    output  reg [1023:0] cypher,
    
    input   clk,
    input   ds_n,
    input   reset_n,
    output  ready,
    
    output  multrdy,
    output  sqrrdy,
    output  bothrdy,
    
    output  cypher_tb,
    
//仿真    
    output  multgo_tb,
    output  sqrgo_tb,
    output [1023:0] count_tb

    );
parameter data =  1024'h9eeba2dedc2bd0ffefe0e51cc1e84e263c4b25f12328b9486fbd50ab1f5a8e4e74ad556f3a06f4a722cc01cc92e6aac7f7bad4ee19a496832f7027ca822b73625a572b16fcb5fe393347fef603bdf3eaa79b46bb833a5f4c393c6ddc612c2504b896a7b075ec821e79d7bf1d4d3c9cfca41c416f978c50be9188c156ae3af4e2;
parameter exp = 1024'h192b7863caf59b10abd981c9ace9b88d3d3303d4ff7f3dfaf1d9f2e66090e7a91a0c621f6d88f0f20dbb8a3e60cdd644cfdb824553e46c005eb187ed3551c48ab90c6583421d5c9f90ce27ff9b76f3848dd866ee4ba4ce15167fbd3feda4cdced4230ee77736c3684aedf22e311594b2c409d0a183b0d0f99837bfe6fe9ede01;
parameter mod = 1024'hcc2d8d552f9b4c98b287dcdd63621e324fab5d61dc3381b38084fb9b1764ddfffda38ae0e7744670b36640e47f431d95a981210344d91dd7b74e8231a955c5c81a765dfb33c0312056a5c2a70e84a9f39f4e7297eee5e56158c8d14e0168047ea3f19d8971cc4818b3805d546f2163cab6916273db6f3a3ba005750e36b71151;

(* DONT_TOUCH= "TRUE" *) reg [1023:0]    indata = data;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    inExp = exp;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    inMod = mod;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    cypher;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    modreg;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    root;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    sqrin;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    tempin;
(* DONT_TOUCH= "TRUE" *) reg [1023:0]    count;

(* DONT_TOUCH= "TRUE" *) wire [1023:0]    tempout;
(* DONT_TOUCH= "TRUE" *) wire [1023:0]    square;
//(* DONT_TOUCH= "TRUE" *) wire    multrdy;
//(* DONT_TOUCH= "TRUE" *) wire    sqrrdy;
//(* DONT_TOUCH= "TRUE" *) wire    bothrdy;
(* DONT_TOUCH= "TRUE" *) wire    ds;

(* DONT_TOUCH= "TRUE" *) reg     multgo, sqrgo;
(* DONT_TOUCH= "TRUE" *) reg     done;

//仿真
//wire  multgo_tb, sqrgo_tb;
assign multgo_tb = multgo;
assign sqrgo_tb = sqrgo;
assign count_tb = count;

assign ready = done;
assign bothrdy = multrdy & sqrrdy;
assign cypher_tb = cypher[0];
assign ds = ~ds_n;

//例化模乘模块
montgomery modmultiply(
    .mpand(tempin),
    .mplier(sqrin),
    .modulus(modreg),
    .clk(clk),
    .rst_n(reset_n),
    .ds(multgo),
    .ready(multrdy),
    .product(tempout)
);
//例化模方模块
montgomery modsqr(
    .mpand(root),
    .mplier(root),
    .modulus(modreg),
    .clk(clk),
    .rst_n(reset_n),
    .ds(multgo),
    .ready(sqrrdy),
    .product(square)
);


//控制代码
always@(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
        count <= {1024{1'b0}};
        done <= 1'b1;
    end
    else begin
        if(done)begin
            if(ds)begin
                count <= inExp >> 1;
                done <= 1'b0;
            end 
            else begin
                count <= count;
                done <= done;
            end
        end
        else if(count == {1024{1'b0}})begin
            if(bothrdy && !multgo)begin
                cypher <= tempout;
                done <= 1'b1;
            end
            else begin
                cypher <= cypher;
                done <= done;
            end
        end   
        else if(bothrdy)begin
            if(!multgo)begin
                count <= count >> 1;
            end
            else begin
                count <= count;
            end
        end 
    end
end

always@(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
        root <= {1024{1'b0}};
        modreg <= {1024{1'b0}};
    end
    else begin
        if(done)begin
            if(ds)begin
                modreg <= inMod;
                root <= indata;
            end
            else begin 
                modreg <= modreg;
                root <= root;
            end
        end
        else
            root <= square;
    end
end

always@(posedge clk or negedge reset_n)begin
    if(!reset_n)begin
        tempin <= {1024{1'b0}};
        sqrin <= {1024{1'b0}};
        modreg <= {1024{1'b0}};
    end
    else begin
        if(done)begin
            if(ds)begin
                if(inExp[0])
                    tempin <= indata;
                else begin
                    tempin[1023:1] <= {1023{1'b0}};
                    tempin[0] <= 1'b1;
                end
                modreg <= inMod;
                sqrin[1023:1] <= {1023{1'b0}};
                sqrin[0] <= 1'b1;
            end
        end
        else begin
            tempin <= tempout;
            if(count[0])
                sqrin <= square;
            else begin
                sqrin[1023:1] <= {1023{1'b0}};
                sqrin[0] <= 1'b1;
            end
        end
    end
end

always@(posedge clk or negedge reset_n)begin
    if(!reset_n)
        multgo <= 1'b0;
    else begin
        if(done)begin
            if(ds)begin
                multgo <= 1'b1;
            end
        end
        else if(count != 1024'd0)begin
            if(bothrdy)
                multgo <= 1'b1;
            else
                multgo <= multgo;
        end
            if(multgo)
                multgo <= 1'b0;
    end
end


endmodule
