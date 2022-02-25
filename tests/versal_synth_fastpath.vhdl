
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
library work;

entity TestOp_Synth is
  port (
          a : in  std_logic_vector(3 downto 0);
          b : in  std_logic_vector(3 downto 0);
         ci : in  std_logic;

     sum_v1 : out  std_logic_vector(3 downto 0);
      co_v1 : out  std_logic_vector(3 downto 0);

     sum_v2 : out  std_logic_vector(3 downto 0);
      co_v2 : out  std_logic_vector(3 downto 0);

     sum_v3 : out  std_logic_vector(3 downto 0);
      co_v3 : out  std_logic_vector(3 downto 0);

     sum_v4 : out  std_logic_vector(3 downto 0);
      co_v4 : out  std_logic_vector(3 downto 0);

     sum_v5 : out  std_logic_vector(3 downto 0);
      co_v5 : out  std_logic_vector(3 downto 0)
  );
end entity;


architecture behavorial of TestOp_Synth is

  signal prop :  std_logic_vector(3 downto 0);

  signal co_buf_v1 :  std_logic_vector(3 downto 0);
  signal co_buf_v2 :  std_logic_vector(3 downto 0);
  signal co_buf_v3 :  std_logic_vector(3 downto 0);
  signal co_buf_v5 :  std_logic_vector(3 downto 0);

  signal co_lh_v2 :  std_logic_vector(3 downto 0);
  signal co_lh_v3 :  std_logic_vector(3 downto 0);
  signal co_lh_v5 :  std_logic_vector(3 downto 0);

begin

--- although in theory all variants below describe/model the same behaviour, only some of them are properly mapped by the synthesizer to slice internal cascade fast paths, while the others use horrible long detours through the routing fabric

--- Variant 1: Simply connecting LUT's directly together ---

-- Result: Not working, synth does not use fastpath

   test_lut6_0_v1: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(0),
        i3 => b(0),
        i4 => ci,
        i5 => '1',

        o5 => sum_v1(0),
        o6 => co_buf_v1(0)
      );

   test_lut6_1_v1: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(1),
        i3 => b(1),
        i4 => co_buf_v1(0),
        i5 => '1',

        o5 => sum_v1(1),
        o6 => co_buf_v1(1)
      );

   test_lut6_2_v1: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(2),
        i3 => b(2),
        i4 => co_buf_v1(1),
        i5 => '1',

        o5 => sum_v1(2),
        o6 => co_buf_v1(2)
      );

  co_v1 <= co_buf_v1;


--- Variant 2: Using classic LUT6_2 and connecting them with LOOKAHEAD8 modules  ---

-- Result: Not working, synth does not use fastpath

   LOOKAHEAD8_inst_v2 : LOOKAHEAD8
   generic map (
     LOOKB => "FALSE",
     LOOKD => "FALSE",
     LOOKF => "FALSE",
     LOOKH => "FALSE"
   )
   port map (
     gea => '0',
     geb => '0',
     gec => '0',
     ged => '0',
     gee => '0',
     gef => '0',
     geg => '0',
     geh => '0',

     COUTB => co_lh_v2(0),
     COUTD => co_lh_v2(1),
     COUTF => co_lh_v2(2),
     COUTH => co_lh_v2(3),

     CIN => ci,
     CYA => co_buf_v2(0),
     CYB => co_buf_v2(1),
     CYC => '0',
     CYD => '0',
     CYE => '0',
     CYF => '0',
     CYG => '0',
     CYH => '0',

     PROPA => '0',
     PROPB => '0',
     PROPC => '0',
     PROPD => '0',
     PROPE => '0',
     PROPF => '0',
     PROPG => '0',
     PROPH => '0'
   );


   test_lut6_0_v2: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(0),
        i3 => b(0),
        i4 => ci,
        i5 => '1',

        o5 => sum_v2(0),
        o6 => co_buf_v2(0)
      );

   test_lut6_1_v2: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(1),
        i3 => b(1),
        i4 => co_buf_v2(0),
        i5 => '1',

        o5 => sum_v2(1),
        o6 => co_buf_v2(1)
      );

   test_lut6_2_v2: LUT6_2
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(2),
        i3 => b(2),
        i4 => co_lh_v2(0),
        i5 => '1',

        o5 => sum_v2(2),
        o6 => co_buf_v2(2)
      );

  co_v2 <= co_buf_v2;


--- Variant 3: Using CFGLUT5 and connecting them with LOOKAHEAD8 modules  ---

-- Result: Not working, synth does not use fastpath

   LOOKAHEAD8_inst_v3 : LOOKAHEAD8
   generic map (
     LOOKB => "FALSE",
     LOOKD => "FALSE",
     LOOKF => "FALSE",
     LOOKH => "FALSE"
   )
   port map (
     gea => '0',
     geb => '0',
     gec => '0',
     ged => '0',
     gee => '0',
     gef => '0',
     geg => '0',
     geh => '0',

     COUTB => co_lh_v3(0),
     COUTD => co_lh_v3(1),
     COUTF => co_lh_v3(2),
     COUTH => co_lh_v3(3),

     CIN => ci,
     CYA => co_buf_v3(0),
     CYB => co_buf_v3(1),
     CYC => '0',
     CYD => '0',
     CYE => '0',
     CYF => '0',
     CYG => '0',
     CYH => '0',

     PROPA => '0',
     PROPB => '0',
     PROPC => '0',
     PROPD => '0',
     PROPE => '0',
     PROPF => '0',
     PROPG => '0',
     PROPH => '0'
   );


   test_cfglut5_0_v3: CFGLUT5
      generic map ( init => x"10010110")
      port map (
        CDO => open,
        CDI => '0',
         CE => '0',
        CLK => '0',

        i0 => '0',
        i1 => '0',
        i2 => a(0),
        i3 => b(0),
        i4 => ci,

        o5 => sum_v3(0),
        o6 => co_buf_v3(0)
      );

   test_cfglut5_1_v3: CFGLUT5
      generic map ( init => x"10010110")
      port map (
        CDO => open,
        CDI => '0',
         CE => '0',
        CLK => '0',

        i0 => '0',
        i1 => '0',
        i2 => a(1),
        i3 => b(1),
        i4 => co_buf_v3(0),

        o5 => sum_v3(1),
        o6 => co_buf_v3(1)
      );

   test_cfglut5_2_v3: CFGLUT5
      generic map ( init => x"10010110")
      port map (
        CDO => open,
        CDI => '0',
         CE => '0',
        CLK => '0',

        i0 => '0',
        i1 => '0',
        i2 => a(2),
        i3 => b(2),
        i4 => co_lh_v3(0),

        o5 => sum_v3(2),
        o6 => co_buf_v3(2)
      );

  co_v3 <= co_buf_v3;


--- Variant 4: describing addition symbolically relying on syntheziser inference  ---

-- Result: Not working, synth does not use fastpath (actually result is totally strange and imho rather inefficient)

   -- dont really get what synth produes here, it seems highly un optimized
   sum_v4 <= std_logic_vector(signed(a) + signed(b));


--- Variant 5: Using new LUT6CY and connecting them with LOOKAHEAD8 modules  ---

 -- Result: This is the one variant which works properly! Not that one can utilize this variant even when lookahead and propagate does not make sense by setting the lookahead to passthrough mode

   LOOKAHEAD8_inst_v5 : LOOKAHEAD8
   generic map (
     LOOKB => "FALSE",
     LOOKD => "FALSE",
     LOOKF => "FALSE",
     LOOKH => "FALSE"
   )
   port map (
     gea => '0',
     geb => '0',
     gec => '0',
     ged => '0',
     gee => '0',
     gef => '0',
     geg => '0',
     geh => '0',

     COUTB => co_lh_v5(0),
     COUTD => co_lh_v5(1),
     COUTF => co_lh_v5(2),
     COUTH => co_lh_v5(3),

     CIN => ci,

     CYA => co_buf_v5(0),
     CYB => co_buf_v5(1),
     CYC => co_buf_v5(2),
     CYD => co_buf_v5(3),

     CYE => '0',
     CYF => '0',
     CYG => '0',
     CYH => '0',

     --PROPA => '0', -- prop(0),
     --PROPB => '0', -- prop(1),
     --PROPC => '0', -- prop(2),
     --PROPD => '0', -- prop(3),

     PROPA => prop(0),
     PROPB => prop(1),
     PROPC => prop(2),
     PROPD => prop(3),

     PROPE => '0',
     PROPF => '0',
     PROPG => '0',
     PROPH => '0'
   );


   test_lut6_cy0_v5: LUT6CY
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(0),
        i3 => b(0),
        i4 => ci,

        o51 => sum_v5(0),
        o52 => co_buf_v5(0),

        prop => prop(0)
      );

   test_lut6_cy1_v5: LUT6CY
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(1),
        i3 => b(1),
        i4 => co_buf_v5(0),

        o51 => sum_v5(1),
        o52 => co_buf_v5(1),

        prop => prop(1)
      );

   test_lut6_cy2_v5: LUT6CY
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(2),
        i3 => b(2),
        i4 => co_lh_v5(0),

        o51 => sum_v5(2),
        o52 => co_buf_v5(2),

        prop => prop(2)
      );

   test_lut6_cy3_v5: LUT6CY
      generic map ( init => x"1110100010010110")
      port map (
        i0 => '0',
        i1 => '0',
        i2 => a(3),
        i3 => b(3),
        i4 => co_buf_v5(2),

        o51 => sum_v5(3),
        o52 => co_buf_v5(3),

        prop => prop(3)
      );

  co_v5 <= co_buf_v5;

end architecture;

