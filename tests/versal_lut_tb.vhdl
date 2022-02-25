
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
library work;

entity TestBench_Versal_Primitives is
end entity;

architecture behavorial of TestBench_Versal_Primitives is

  signal l6cy_o51  : std_logic;
  signal l6cy_o52  : std_logic;
  signal l6cy_prop : std_logic;

  signal l6_o51  : std_logic;
  signal l6_o52  : std_logic;

begin

  --
  -- note that for both luts outputs should be the same and they should
  -- definetly not be be 'U' in simulation, but dependending how you
  -- setup your project this still might happen as Xilinx decided to
  -- not provide vhdl implementations anymore for its newer library 
  -- elements and one must use the verilog implementation
  --
  test_lut6_cy0: LUT6CY
    generic map ( init => x"1110100010010110")
    port map (
         i0 => '0',
         i1 => '0',
         i2 => '1',
         i3 => '1',
         i4 => '0',

        o51 => l6cy_o51,
        o52 => l6cy_o52,

       prop => l6cy_prop
    );

  test_lut6_1: LUT6_2
    generic map ( init => x"1110100010010110")
    port map (
      i0 => '0',
      i1 => '0',
      i2 => '1',
      i3 => '1',
      i4 => '0',
      i5 => '1',

      o5 => l6_o51,
      o6 => l6_o52
    );

end architecture;

