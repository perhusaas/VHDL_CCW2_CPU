--Output: JB(0)


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PenCtrl is
    Port ( 
           clk, reset: in std_logic;
           Penable : in STD_LOGIC;
           JB : out std_logic_vector(7 downto 0)
           );
end PenCtrl;

architecture WriteStuff of PenCtrl is

constant Pulse: integer:=2000000;

begin

process(clk, reset)


Variable HighCount: integer:= 100000;
Variable LowCount: integer:= 1900000;
Variable HC: Integer:=1;
Variable LC: Integer:=1;
begin
    if Reset = '1' then                                     --Reset module on RESET
        HighCount:=100000;
        LowCount:=1900000;
        LC := LC+1;
    elsif rising_edge(clk) then
        if Penable = '1' then 
            HighCount:=200000;
            LowCount:=1800000;
        else
            HighCount:=100000;
            LowCount:=1900000;                      
        end if;
        
      --  HighCount:= HighCount / 100000;         --\\\\\\\\\\\\\\\\SIM MOD, REMOVE BEFORE BITSTREAM////////////
       -- LowCount:= LowCount / 100000;           --\\\\\\\\\\\\\\\\SIM MOD, REMOVE BEFORE BITSTREAM////////////
        
        if HC <= HighCount then
            JB(0) <= '1';
            HC := HC+1;
        elsif LC = LowCount then
            HC := 1;
            LC := 1;            
        else
            JB(0) <= '0';
            LC := LC+1;
        end if;
        
    end if;
end process;

end WriteStuff;
