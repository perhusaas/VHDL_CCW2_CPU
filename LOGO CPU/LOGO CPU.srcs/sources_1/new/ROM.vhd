--
-- ROM with asynchronous read (listing 11.5)
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Rom is
   port(
      addb: in std_logic_vector(7 downto 0);
      datab: out std_logic_vector(7 downto 0)
   );
end Rom;

architecture Amygdala of Rom is
   constant ABW: integer:=8;
   constant DBW: integer:=8;
   type rom_type is array (0 to 2**ABW-1)
        of std_logic_vector(DBW-1 downto 0);
   constant content: rom_type:=(  -- 2^8-by-8
      "10100000",  -- addr 00 contains LD R,M code (A0H)
      "00110111",  -- just data (55H)
      "10110000",  -- addr 02: INCR (B0H)
      "10110000",  -- addr 03: INCR (B0H)
      "11000000",  -- addr 04: DECR (C0H)
      "00000111",  -- addr 05: MxT (07H)
      "11111111",  -- addr 06: HALT (FFH)
      "11111111",  -- addr 07: HALT (FFH)
      "11111111",  -- addr 08: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "11111111",  -- addr ..: HALT (FFH)
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr      
      "00000000",  -- addr
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000",  -- addr 
      "00000000"  -- addr            
   );
begin
   datab <= content(to_integer(unsigned(addb)));
end Amygdala;