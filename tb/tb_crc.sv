`timescale 1 ps / 1 ps
module tb_crc;

parameter CLK_T             = 10000;

parameter [63:0] POLY       = 16'h1021;
parameter        CRC_SIZE   = 16;
parameter        DATA_WIDTH = 8;
parameter [63:0] INIT       = 16'hffff;
parameter        REF_IN     = 1;
parameter        REF_OUT    = 1;
parameter [63:0] XOR_OUT    = 16'h0000;

logic                  clk;
logic                  rst;
logic                  crc_en;
logic [DATA_WIDTH-1:0] data;
logic [CRC_SIZE-1:0]   crc;

initial
  begin
    clk    = 1'b0;
    rst    = 1'b0;
    crc_en = 1'b0;
    data   = '0;
  end

task automatic clk_gen;
  forever
    begin
      #( CLK_T / 2 );
      clk <= ~clk;
    end
endtask

task automatic apply_reset;
  @( posedge clk );
  rst = 1'b1;
  @( posedge clk );
  rst = 1'b0;
endtask

crc_calc #(
  .POLY         ( POLY       ),
  .CRC_SIZE     ( CRC_SIZE   ),
  .DATA_WIDTH   ( DATA_WIDTH ),
  .INIT         ( INIT       ),
  .REF_IN       ( REF_IN     ),
  .REF_OUT      ( REF_OUT    ),
  .XOR_OUT      ( XOR_OUT    )
) DUT (
  .clk_i        ( clk        ),
  .rst_i        ( rst        ),
  .soft_reset_i ( 1'b0       ),
  .valid_i      ( crc_en     ),
  .data_i       ( data       ),
  .crc_o        ( crc        )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
    join_none
    repeat( 10 )
      @( posedge clk );
    crc_en <= 1'b1;
    data <= 8'hff;
    @( posedge clk );
    data <= 8'h00;
    @( posedge clk );
    data <= 8'h00;
    @( posedge clk );
    data <= 8'h00;
    @( posedge clk );
    data <= 8'h1e;
    @( posedge clk );
    data <= 8'hf0;
    @( posedge clk );
    data <= 8'h1e;
    @( posedge clk );
    data <= 8'hc7;
    @( posedge clk );
    data <= 8'h4f;
    @( posedge clk );
    data <= 8'h82;
    @( posedge clk );
    data <= 8'h78;
    @( posedge clk );
    data <= 8'hc5;
    @( posedge clk );
    data <= 8'h82;
    @( posedge clk );
    data <= 8'he0; 
    @( posedge clk );
    data <= 8'h8c;
    @( posedge clk );
    data <= 8'h70;
    @( posedge clk );
    data <= 8'hd2;
    @( posedge clk );
    data <= 8'h3c;
    @( posedge clk );
    data <= 8'h78;
    @( posedge clk );
    data <= 8'he9;
    @( posedge clk );
    data <= 8'hff;
    @( posedge clk );
    data <= 8'h00;
    @( posedge clk );
    data <= 8'h00;
    @( posedge clk );
    data <= 8'h01;
    @( posedge clk );
    crc_en <= 1'b0;
    data <= 8'h00;
    repeat( 10 )
      @( posedge clk );
    $stop;
  end

endmodule
