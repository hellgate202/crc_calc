Universal CRC generator module
==============================

Following module can generate any CRC up to CRC64 with any polynomial.

The idea is that logic synthesizer will(should) optimize nested for loops into minimal amount of XOR gates. Synthesis optimizations were tested in Quartus Prime 17.1 Lite and Vivado 2018.2.

Correctness of this module was verified with different polynomials and compared with results from http://crccalc.com

Instantation example
--------------------

    crc_calc #(
      .POLY         ( 16'h8005   ),
      .CRC_SIZE     ( 16         ),
      .DATA_WIDTH   ( 8          ),
      .INIT         ( 16'h0      ),
      .REF_IN       ( "TRUE"     ),
      .REF_OUT      ( "TRUE"     ),
      .XOR_OUT      ( 16'hffff   )
    ) example (
      .clk_i        ( clk        ),
      .rst_i        ( rst        ),
      .soft_reset_i ( soft_reset ),
      .valid_i      ( valid      ),
      .data_i       ( data       ),
      .crc_o        ( crc        )
    );

Parameters description
----------------------

**POLY** - polynomial of particular CRC. For example, the following polynomial (CRC-16-CCIT) x^16 + x^12 + x^5 + 1 will be 16'h1021;

**CRC_SIZE** - size of generated CRC. Must be 16 for CRC16, 32 for CRC32 etc;

**DATA_WIDTH** - width of data input for parallel computations;

**INIT** - initial data in CRC register after hard or soft reset;

**REF_IN** - if TRUE than values of CRC register will be XORed LSB first, else MSB;

**REF_OUT** - if TRUE than input data will be shifted in with LSB first, else MSB;

**XOR_OUT** - value that output result will be XORed with.

Signals description
-------------------

**clk_i** - clock;

**rst_i** - synchronous reset, active high;

**soft_reset_i** - reset of CRC register to its initial value. Should be used to reset CRC between transactions;

**valid_i** - when high input data will be shifted in CRC register;

**data_i** - input data;

**crc_o** -  output CRC.
