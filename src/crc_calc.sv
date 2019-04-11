module crc_calc #(
  parameter bit [63 : 0] POLY       = 16'h8005,
  parameter int          CRC_SIZE   = 16,
  parameter int          DATA_WIDTH = 8,
  parameter bit [63 : 0] INIT       = 16'h0000,
  parameter int          REF_IN     = 1,
  parameter int          REF_OUT    = 1,
  parameter bit [63 : 0] XOR_OUT    = 16'hffff
)(
  input                       clk_i,
  input                       rst_i,
  input                       soft_reset_i,
  input                       valid_i,
  input  [DATA_WIDTH - 1 : 0] data_i,
  output [CRC_SIZE - 1 : 0]   crc_o
);

logic [CRC_SIZE - 1 : 0] crc;
logic [CRC_SIZE - 1 : 0] crc_next;
logic [CRC_SIZE - 1 : 0] crc_prev;

always_ff @( posedge clk_i )
  if( rst_i )
    crc <= INIT[CRC_SIZE - 1 : 0];
  else
    if( soft_reset_i )
      crc <= INIT[CRC_SIZE - 1 : 0];
    else
      if( valid_i )
        crc <= crc_next;

assign crc_o = crc ^ XOR_OUT[CRC_SIZE - 1 : 0];

generate
  if( REF_OUT )
    if( REF_IN )
      begin : ref_out_ref_in
        always_comb
          begin
            crc_next = crc;
            crc_prev = crc;
            for( int i = 0 ; i < DATA_WIDTH; i++ )
              begin
                crc_next[CRC_SIZE - 1] = crc_prev[0] ^ data_i[i];
                for( int j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[CRC_SIZE - 1 - j] = crc_prev[CRC_SIZE - j] ^ crc_prev[0] ^ data_i[i];
                  else
                    crc_next[CRC_SIZE - 1 - j] = crc_prev[CRC_SIZE - j]; 
                 crc_prev = crc_next;
              end
          end
      end
    else
      begin : ref_out_n_ref_in
        always_comb
          begin
            crc_next = crc;
            crc_prev = crc;
            for( int i = 0; i < DATA_WIDTH; i++ )
              begin
                crc_next[0] = crc_prev[CRC_SIZE - 1] ^ data_i[i];
                for( int j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[j] = crc_prev[j - 1] ^ crc_prev[CRC_SIZE - 1] ^ data_i[i];
                  else
                    crc_next[j] = crc_prev[j - 1];
                crc_prev = crc_next;
              end
          end
      end
  else
    if( REF_IN )
      begin : n_ref_out_ref_in
        always_comb
          begin
            crc_next = crc;
            crc_prev = crc;
            for( int i = 0; i < DATA_WIDTH; i ++ )
              begin
                crc_next[CRC_SIZE - 1] = crc_prev[0] ^ data_i[ DATA_WIDTH - 1 - i];
                for( int j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[CRC_SIZE - 1 - j] = crc_prev[CRC_SIZE - j] ^ crc_prev[0] ^ data_i[DATA_WIDTH - 1 - i];
                  else
                    crc_next[CRC_SIZE - 1 - j] = crc_prev[CRC_SIZE - j];
                crc_prev = crc_next;
              end
          end
      end
    else
      begin : n_ref_out_n_ref_in
        always_comb
          begin
            crc_next = crc;
            crc_prev = crc;
            for( int i = 0; i < DATA_WIDTH; i ++ )
              begin
                crc_next[0] = crc_prev[CRC_SIZE - 1] ^ data_i[DATA_WIDTH - 1 - i];
                for( int j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[j] = crc_prev[j - 1] ^ crc_prev[CRC_SIZE - 1] ^ data_i[DATA_WIDTH - 1 - i];
                  else
                    crc_next[j] = crc_prev[j - 1];
                crc_prev = crc_next;
              end
          end
      end
endgenerate

endmodule
