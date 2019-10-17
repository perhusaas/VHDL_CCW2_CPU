--Input structure (ob):
--8 bits
--Bit 0 (Pen Control):  
--  1=Pen Down,  
--  0=Pen Up
--Bit 1-4 (Movement): 
--  0000=No Movement
--  0001=Move Forward 
--  0010=Move Backward 
--  0011=Move Forward Right 
--  0100=Move Forward Left
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
      ob: in std_logic_vector(7 downto 0);
      JA: out std_logic_vector(7 downto 0); --0-3: Left Motor, 4-7: Right Motor
      JB: out std_logic_vector(7 downto 0) --1: PWM to Servo
        );
end Outputs;

architecture MoveCart of Outputs is

      Signal Penable : std_logic;
      Signal LM : std_logic_vector(4 downto 0):="00000";
      Signal RM : std_logic_vector(4 downto 0):="00000";
      

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
      JB: out std_logic_vector(7 downto 0)
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
        JB => JB
        );	
        
process(clk, reset)

  Variable LMove : std_logic_vector(4 downto 0):="00000";
  Variable RMove : std_logic_vector(4 downto 0):="00000";
  Variable LMSpeed : std_logic_vector(4 downto 0):="00000";
  Variable RMSpeed : std_logic_vector(4 downto 0):="00000";
  
begin
    if Reset = '1' then
        
    elsif rising_edge(clk) then
        Penable <= ob(0);
        
        if ob(4 downto 1) = "0001" then
            LMove := "10000";
            RMove := "10000";
        elsif ob(4 downto 1) = "0010" then
            LMove := "00000";
            RMove := "00000";
        elsif ob(4 downto 1) = "0011" then
            LMove := "10000";
            RMove := "10000";
        elsif ob(4 downto 1) = "0100" then
            LMove := "10000";
            RMove := "10000";
        elsif ob(4 downto 1) = "0101" then
            LMove := "00000";
            RMove := "00000";
        elsif ob(4 downto 1) = "0110" then
            LMove := "00000";
            RMove := "00000";
        elsif ob(4 downto 1) = "0111" then
            LMove := "10000";
            RMove := "00000";
        elsif ob(4 downto 1) = "1000" then
            LMove := "00000";
            RMove := "10000";
        end if;
        
        if ob(7 downto 5) = "001" then
            LMSpeed := "00001";
            RMSpeed := "00001";
            if ob(4 downto 1) = ("0011" OR "0101") then
                RMSpeed := "00000";
            elsif ob(4 downto 1) = ("0100" OR "0110") then
                LMSpeed := "00000";
            end if;
        elsif ob(7 downto 5) = "010" then
            LMSpeed := "00011";
            RMSpeed := "00011";
            if ob(4 downto 1) = ("0011" OR "0101") then
                RMSpeed := "00001";
            elsif ob(4 downto 1) = ("0100" OR "0110") then
                LMSpeed := "00001";
            end if;
        elsif ob(7 downto 5) = "011" then
            LMSpeed := "00111";
            RMSpeed := "00111";
            if ob(4 downto 1) = ("0011" OR "0101") then
                RMSpeed := "00011";
            elsif ob(4 downto 1) = ("0100" OR "0110") then
                LMSpeed := "00011";
            end if;
        elsif ob(7 downto 5) = "100" then
            LMSpeed := "01111";
            RMSpeed := "01111";   
            if ob(4 downto 1) = ("0011" OR "0101") then
                RMSpeed := "00111";
            elsif ob(4 downto 1) = ("0100" OR "0110") then
                LMSpeed := "00111";
            end if;
        end if; 
        
        RM <= RMove + RMSpeed;
        LM <= LMove + LMSpeed;
    end if;
end process;

end MoveCart;
