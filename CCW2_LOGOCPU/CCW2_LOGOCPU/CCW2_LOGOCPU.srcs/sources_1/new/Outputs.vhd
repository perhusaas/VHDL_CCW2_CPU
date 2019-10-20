--Input structure (ob):         --Input structure (xM): 
--8 bits                        --5 bits   
--Bit 0 (Pen Control):          --Bit 4 (Direction):
--  1=Pen Down,                 --  1=Forward
--  0=Pen Up                    --  0=Backward
--Bit 1-4 (Movement):           --Bit 0-3 (Speed): 
--  0000=No Movement            --  0000: No Movement
--  0001=Move Forward           --  0001: Slow
--  0010=Move Backward          --  0011: Medium
--  0011=Move Forward Right     --  0111: Fast
--  0100=Move Forward Left      --  1111: Ludicrous Mode!
--  0101=Move Backward Right        
--  0110=Move Backward Left     
--  0111=Rotate Right 
--  1000=Rotate Left
--Bit 5-7 (Speed):
--  000: No Movement
--  001: Slow
--  010: Medium
--  011: Fast
--  100: Ludicrous Mode!

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Outputs is

    port(
      clk: in std_logic;
      reset: in std_logic;
      ob: in std_logic_vector(7 downto 0);  --Output from CPU
      JA: out std_logic_vector(7 downto 0); --0-3: Left Motor, 4-7: Right Motor
      ServoPWM : out std_logic
        );
end Outputs;

architecture MoveCart of Outputs is

      Signal Penable : std_logic;                           --Signal for Pen Down
      Signal LM : std_logic_vector(4 downto 0):="00000";    --Left Motor Word
      Signal RM : std_logic_vector(4 downto 0):="00000";    --Right Motor Word
      

component Steppers
    port(
      clk, reset: in std_logic;
      LM: in std_logic_vector(4 downto 0);
      RM: in std_logic_vector(4 downto 0);
      JA: out std_logic_vector(7 downto 0)
        );        
end component;

component PenCtrl
    port(
      clk, reset: in std_logic;
      Penable: in std_logic;
      ServoPWM : out std_logic
        );        
end component;

begin

Step_unit: Steppers
port map( clk => clk, reset => reset, 
        LM => LM,
        RM => RM, 
        JA => JA
        );
            
Pen_unit: PenCtrl
port map( clk => clk, reset => reset, 
        Penable => Penable, 
        ServoPWM => ServoPWM
        );	
        
process(clk, reset)

  Variable LMove : std_logic_vector(4 downto 0):="00000";           --Part of output - Move Type
  Variable RMove : std_logic_vector(4 downto 0):="00000";           --Part of output - Move Type
  Variable LMSpeed : std_logic_vector(4 downto 0):="00000";         --Part of output - Speed
  Variable RMSpeed : std_logic_vector(4 downto 0):="00000";         --Part of output - Speed
  
begin
    if Reset = '1' then                                             --Reset
        RM <= "00000";
        LM <= "00000";        
    elsif rising_edge(clk) then
        Penable <= ob(0);                                           --Enable/Disable Pen
        
        if ob(4 downto 1) = "0001" then                             --Move Forward
            LMove := "10000";                                           --Direction = FWD
            RMove := "10000";                                           --Direction = FWD
        elsif ob(4 downto 1) = "0010" then                          --Move Backward 
            LMove := "00000";                                           --Direction = BWD
            RMove := "00000";                                           --Direction = BWD
        elsif ob(4 downto 1) = "0011" then                          --Move Forward Right
            LMove := "10000";                                           --Direction = FWD
            RMove := "10000";                                           --Direction = FWD
        elsif ob(4 downto 1) = "0100" then                          --Move Forward Left
            LMove := "10000";                                           --Direction = FWD
            RMove := "10000";                                           --Direction = FWD
        elsif ob(4 downto 1) = "0101" then                          --Move Backward Right
            LMove := "00000";                                           --Direction = BWD
            RMove := "00000";                                           --Direction = BWD
        elsif ob(4 downto 1) = "0110" then                          --Move Backward Left
            LMove := "00000";                                           --Direction = FWD
            RMove := "00000";                                           --Direction = FWD
        elsif ob(4 downto 1) = "0111" then                          --Rotate Right
            LMove := "10000";                                           --Direction = FWD
            RMove := "00000";                                           --Direction = BWD
        elsif ob(4 downto 1) = "1000" then                          --Rotate Left
            LMove := "00000";                                           --Direction = BWD
            RMove := "10000";                                           --Direction = FWD
        Else                                                        --No Movement 
            LMove := "00000";                                           --Direction = BWD
            RMove := "00000";                                           --Direction = BWD            
        end if;
        
        if ob(7 downto 5) = "001" then                                              --Slow
            LMSpeed := "00001";                                                         --Slow Speed
            RMSpeed := "00001";                                                         --Slow Speed
            if (ob(4 downto 1) = "0011") OR (ob(4 downto 1) = "0101") then              --One Wheel slower for Right turns
                RMSpeed := "00000";                                                         --No Speed
            elsif (ob(4 downto 1) = "0100") OR (ob(4 downto 1) = "0110") then           --One Wheel slower for Left turns
                LMSpeed := "00000";                                                         --No Speed
            end if;
        elsif ob(7 downto 5) = "010" then                                            --Medium                                       
            LMSpeed := "00011";                                                         --Medium Speed
            RMSpeed := "00011";                                                         --Medium Speed
            if (ob(4 downto 1) = "0011") OR (ob(4 downto 1) = "0101") then              --One Wheel slower for Right turns
                RMSpeed := "00001";                                                         --Slow Speed
            elsif (ob(4 downto 1) = "0100") OR (ob(4 downto 1) = "0110") then           --One Wheel slower for Left turns
                LMSpeed := "00001";                                                         --Slow Speed
            end if;
        elsif ob(7 downto 5) = "011" then                                            --Fast
            LMSpeed := "00111";                                                         --Fast Speed
            RMSpeed := "00111";                                                         --Fast Speed
            if (ob(4 downto 1) = "0011") OR (ob(4 downto 1) = "0101") then              --One Wheel slower for Right turns
                RMSpeed := "00011";                                                         --Medium Speed
            elsif (ob(4 downto 1) = "0100") OR (ob(4 downto 1) = "0110") then           --One Wheel slower for Left turns
                LMSpeed := "00011";                                                         --Medium Speed
            end if;
        elsif ob(7 downto 5) = "100" then                                            --Ludicrous
            LMSpeed := "01111";                                                         --Ludicrous Speed
            RMSpeed := "01111";                                                         --Ludicrous Speed   
            if (ob(4 downto 1) = "0011") OR (ob(4 downto 1) = "0101") then              --One Wheel slower for Right turns
                RMSpeed := "00111";                                                         --Fast Speed
            elsif (ob(4 downto 1) = "0100") OR (ob(4 downto 1) = "0110") then           --One Wheel slower for Left turns
                LMSpeed := "00111";                                                         --Fast Speed
            end if;
        else                                                                        --No Speed output
            LMSpeed := "00000";                                                         --Engines off
            RMSpeed := "00000"; 
        end if; 
        
        RM <= RMove + RMSpeed;                                      --Combining Direction and Speed
        LM <= LMove + LMSpeed;
    end if;
end process;

end MoveCart;
