
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
library work;

entity TestBench_Versal_Lookahead is
end entity;

architecture behavorial of TestBench_Versal_Lookahead is

  signal l6cy_o51  : std_logic;
  signal l6cy_o52  : std_logic;
  signal l6cy_prop : std_logic;

  signal lh_ge : std_logic_vector(7 downto 0);
  signal lh_pr : std_logic_vector(7 downto 0);
  signal lh_cy : std_logic_vector(8 downto 0);

  signal lh_co_true : std_logic_vector(3 downto 0);
  signal lh_co_false : std_logic_vector(3 downto 0);

begin

  --
  -- used as reference to see that new versal modules are working in general
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


  --
  -- note that the lookahead component basically supports 2 
  -- different modes of operation: the actual lookahead modus
  -- doing a real lookahead function with propagates and generates
  -- and a "passthrough" mode where output simply forwards previous
  -- lut carry out input (e.g: CYB => COUTB)
  --
  -- you can switch between these two modes for each output
  -- independendly and this is where the generic boolean come
  -- into play (TRUE == lookahead, FALSE == passthrough)
  --
  lh_true : LOOKAHEAD8
    generic map (
      LOOKB => "TRUE",
      LOOKD => "TRUE",
      LOOKF => "TRUE",
      LOOKH => "TRUE"
    )
    port map (
      -- undocumented ports which are totally ignored (but obviously must still be mapped to avoid synth/simu errors)
      --
      -- my personal guess is that these are deprecated extra ports
      -- intended to be used as generate inputs in an earlier
      -- realisation of this module before Xilinx devs realized they
      -- could double purpose carry outports for this
      --
      -- why they are still around and not completly removed is still somewhat of a mystery
      --
      gea => lh_ge(0), 
      geb => lh_ge(1), 
      gec => lh_ge(2), 
      ged => lh_ge(3), 
      gee => lh_ge(4), 
      gef => lh_ge(5), 
      geg => lh_ge(6), 
      geh => lh_ge(7), 

      COUTB => lh_co_true(0), 
      COUTD => lh_co_true(1), 
      COUTF => lh_co_true(2), 
      COUTH => lh_co_true(3), 

      CIN => lh_cy(0),

      -- carry out port of luts, in passthrough mode every second
      -- of this (B,D,F,H) directly determine the output bits of this component (the others are ignored)
      -- 
      -- in lookahead mode they are used as generate inputs, note
      -- that is technically not 100% correct as nominally the
      -- generate function is "A AND B" which is obviously not the
      -- same for every case as the carry-out function for full-adder,
      -- but because of how this component is built up internally it
      -- works here as long as XOR is used as func for propagate
      -- 
      CYA => lh_cy(1),
      CYB => lh_cy(2),
      CYC => lh_cy(3),
      CYD => lh_cy(4),
      CYE => lh_cy(5),
      CYF => lh_cy(6),
      CYG => lh_cy(7),
      CYH => lh_cy(8),

      -- propagate inports, connected to special purpose propagate
      -- out port of slice luts and totally ignored in passthrough mode
      --
      -- note that in general propagate can be realized either with
      -- "OR" or "XOR", but in this technology it MUST BE "XOR" (because of how generate is handled)
      --
      PROPA => lh_pr(0),
      PROPB => lh_pr(1),
      PROPC => lh_pr(2),
      PROPD => lh_pr(3),
      PROPE => lh_pr(4),
      PROPF => lh_pr(5),
      PROPG => lh_pr(6),
      PROPH => lh_pr(7)
    );


  -- as we used above lookahead component in lookahead mode here another to compare in passthrough mode
  lh_false : LOOKAHEAD8
    generic map (
      LOOKB => "FALSE",
      LOOKD => "FALSE",
      LOOKF => "FALSE",
      LOOKH => "FALSE"
    )
    port map (
      gea => lh_ge(0), 
      geb => lh_ge(1), 
      gec => lh_ge(2), 
      ged => lh_ge(3), 
      gee => lh_ge(4), 
      gef => lh_ge(5), 
      geg => lh_ge(6), 
      geh => lh_ge(7), 

      COUTB => lh_co_false(0), 
      COUTD => lh_co_false(1), 
      COUTF => lh_co_false(2), 
      COUTH => lh_co_false(3), 

      CIN => lh_cy(0),

      CYA => lh_cy(1),
      CYB => lh_cy(2),
      CYC => lh_cy(3),
      CYD => lh_cy(4),
      CYE => lh_cy(5),
      CYF => lh_cy(6),
      CYG => lh_cy(7),
      CYH => lh_cy(8),

      PROPA => lh_pr(0),
      PROPB => lh_pr(1),
      PROPC => lh_pr(2),
      PROPD => lh_pr(3),
      PROPE => lh_pr(4),
      PROPF => lh_pr(5),
      PROPG => lh_pr(6),
      PROPH => lh_pr(7)
    );

  process
  begin
     lh_ge <=   "00000000";
     lh_pr <=   "00000000";
     lh_cy <=  "000000000";
     wait for 2 ns;
     -- this input set will not change the output as ge inputs are totally ignored as described above
     lh_ge <=   "00000010";
     lh_pr <=   "00000000";
     lh_cy <=  "000000000";
     wait for 2 ns;
     -- same as previous set
     lh_ge <=   "00000001";
     lh_pr <=   "00000010";
     lh_cy <=  "000000000";
     wait for 2 ns;
     -- this should set COUTB in lookahead mode as global carry in is propagated through first adder subgroup, but should not change output in passthrough mode
     lh_ge <=   "00000000";
     lh_pr <=   "00000011";
     lh_cy <=  "000000001";
     wait for 2 ns;
     -- this should set COUTB to "1" for both lookahead modules, for the first because of last adder of 1st subgroup is generating, for passthrough mode obviously to passthrough cout B to cin C
     lh_ge <=   "00000010";
     lh_pr <=   "00000000";
     lh_cy <=  "000000100";
     wait for 2 ns;
     lh_ge <=   "00000000";
     lh_pr <=   "00000000";
     lh_cy <=  "000011111";
     wait for 2 ns;
     wait;
  end process;

end architecture;

