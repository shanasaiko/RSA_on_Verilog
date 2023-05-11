`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/29 13:27:26
// Design Name: 
// Module Name: RSACypher_tb
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


module RSACypher_tb(
    );
//reg [1023:0]    indata;
//reg [1023:0]    inExp;
//reg [1023:0]    inMod;
wire    cypher;
reg     clk;
reg     ds_n;
reg     reset_n;
wire    ready;

//ทยีๆ
wire    multrdy;  
wire    sqrrdy ;  
wire    bothrdy ; 
wire    multgo;
wire    sqrgo ;
wire   [1023:0] count;

integer output_file;

RSACypher u_RSACypher(
//    .indata   (indata),
//    .inExp    (inExp),
//    .inMod    (inMod),
//    .cypher   (cypher),

    .clk      (clk),
    .ds_n       (ds_n),
    .reset_n  (reset_n),
    .ready    (ready),
    
    .multrdy  (multrdy  ),  
    .sqrrdy   (sqrrdy   ),
    .bothrdy  (bothrdy  ),
    .cypher_tb(cypher),
    .multgo_tb(multgo   ),
    .sqrgo_tb (sqrgo    ),
    .count_tb(count)

);

initial begin
    reset_n <= 1;
    clk <= 0;
    #100
    reset_n <= 0;
    #100
    reset_n <= 1; 
end

always #10 clk <= ~clk;

initial begin
//    indata <= 1024'h9eeba2dedc2bd0ffefe0e51cc1e84e263c4b25f12328b9486fbd50ab1f5a8e4e74ad556f3a06f4a722cc01cc92e6aac7f7bad4ee19a496832f7027ca822b73625a572b16fcb5fe393347fef603bdf3eaa79b46bb833a5f4c393c6ddc612c2504b896a7b075ec821e79d7bf1d4d3c9cfca41c416f978c50be9188c156ae3af4e2;
//    inExp <= 1024'h192b7863caf59b10abd981c9ace9b88d3d3303d4ff7f3dfaf1d9f2e66090e7a91a0c621f6d88f0f20dbb8a3e60cdd644cfdb824553e46c005eb187ed3551c48ab90c6583421d5c9f90ce27ff9b76f3848dd866ee4ba4ce15167fbd3feda4cdced4230ee77736c3684aedf22e311594b2c409d0a183b0d0f99837bfe6fe9ede01;
//    inMod <= 1024'hcc2d8d552f9b4c98b287dcdd63621e324fab5d61dc3381b38084fb9b1764ddfffda38ae0e7744670b36640e47f431d95a981210344d91dd7b74e8231a955c5c81a765dfb33c0312056a5c2a70e84a9f39f4e7297eee5e56158c8d14e0168047ea3f19d8971cc4818b3805d546f2163cab6916273db6f3a3ba005750e36b71151;
    ds_n <= 1;
    #300
    ds_n <= 0;
end

initial begin
    output_file = $fopen("file.txt","w");
end

initial begin
    #20946690
    $finish;
end

always @(posedge clk)begin      
    if(!ds_n)
        $fwrite(output_file,"%b\n", bothrdy);
end

endmodule
