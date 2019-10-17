--Input structure (xM):             Output Structure (JA):
--5 bits                            8 Bits
--Bit 4 (Direction):                Bit 0-3: Right Engine
--  1=Forward                       Bit 4-7: Left Engine
--  0=Backward
--Bit 0-3 (Speed): 
--  0000: No Movement
--  0001: Slow
--  0011: Medium
--  0111: Fast
--  1111: Ludicrous Mode!


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.Numeric_std.all;

entity Steppers is
    Port (
           clk, reset: in std_logic;
           LM: in std_logic_vector(4 downto 0);
           RM: in std_logic_vector(4 downto 0);
           JA: out std_logic_vector(7 downto 0)
           );
end Steppers;

architecture StepStep of Steppers is

constant Ludicrous: integer:=500000;                        --Step speeds
constant Fast: integer:=600000;
constant Medium: integer:=700000;
constant Slow: integer:=800000;
Signal LeftCMD: std_logic_vector(7 downto 0):= "00000000";  --Part of word for engine output
Signal RightCMD: std_logic_vector(7 downto 0):= "00000000";

begin

process(clk, reset)

variable LeftCount: integer:=0;                             --Counter for step durations
variable RightCount: integer:=0;
variable Leftspeed: integer:=900000;                        --Default value for step duration
variable Rightspeed: integer:=900000;

begin
    if Reset = '1' then                                     --Reset module on RESET
        RightCMD <= "00000000";
        RightCount := 0;
        LeftCMD <= "00000000";
        Leftcount := 0;
        JA <= ( LeftCMD + RightCMD );
        
    elsif rising_edge(clk) then
    
        if RM(3 downto 0) = "0001" then                 --Setting Speed variable for right motor
            RightSpeed := Slow;
        elsif RM(3 downto 0) = "0011" then
            RightSpeed := Medium;
        elsif RM(3 downto 0) = "0111" then
            RightSpeed := Fast;
        elsif RM(3 downto 0) = "1111" then
            RightSpeed := Ludicrous;
        end if;
        --RightSpeed := RightSpeed / 100000;  ---for sim \\\\\\\\\\\\\\\\\\\\\\\\\\Remove before creating bitstream!!///////////////////
        
        if RM = "00000" then                            --No move command
            RightCMD <= "00000000";
        else
            if (RightCount = Rightspeed-1) or (RightCMD = "00000000") then             --Move Command!
                RightCount := 0;                        --Resetting cycle counter
                if (RM(4) = '1')  then                  --Forward
                    if RightCMD = "00000000" then       --State Off
                        RightCMD <= "00110000";
                    elsif RightCMD = "00110000" then    --State Step1
                        RightCMD <= "10010000";
                    elsif RightCMD = "10010000" then    --State Step2
                        RightCMD <= "11000000";
                    elsif RightCMD = "11000000" then    --State Step3
                        RightCMD <= "01100000";
                    else                                --State Step4
                        RightCMD <= "00110000";      
                    end if;
                else                                    --Reverse
                    if RightCMD = "00000000" then        --Off
                        RightCMD <= "01100000";
                    elsif RightCMD = "01100000" then     --Step4
                        RightCMD <= "11000000";
                    elsif RightCMD = "11000000" then     --Step3
                        RightCMD <= "10010000";
                    elsif RightCMD = "10010000" then    --Step2
                        RightCMD <= "00110000";
                    else                                --Step1
                        RightCMD <= "01100000";      
                    end if;        
                end if;
            else
                RightCount := RightCount +1;            --Not ready for a new move yet, incrementing counter
            end if;
        end if;
    
        if LM(3 downto 0) = "0001" then                 --Setting Speed variable for left motor
            Leftspeed := Slow;
        elsif LM(3 downto 0) = "0011" then
            Leftspeed := Medium;
        elsif LM(3 downto 0) = "0111" then
            Leftspeed := Fast;
        elsif LM(3 downto 0) = "1111" then
            Leftspeed := Ludicrous;
        end if;
        
        --Leftspeed := Leftspeed / 100000;        ---for sim \\\\\\\\\\\\\\\\\\\\\\\\\\Remove before creating bitstream!!///////////////////
        
        if LM = "00000" then                            --Same as above for left motor
            JA(7 downto 4) <= "0000";
        else
            if (LeftCount = Leftspeed-1) or (LeftCMD = "00000000") then
                Leftcount := 0;
                if (LM(4) = '1')  then                  --Forward
                    if LeftCMD = "00000000" then       --State Off
                        LeftCMD <= "00000011";
                    elsif LeftCMD = "00000011" then    --State Step1
                        LeftCMD <= "00001001";
                    elsif LeftCMD = "00001001" then    --State Step2
                        LeftCMD <= "00001100";
                    elsif LeftCMD = "00001100" then    --State Step3
                        LeftCMD <= "00000110";
                    else                                --State Step4
                        LeftCMD <= "00000011";      
                    end if;
                else                                    --Reverse
                    if LeftCMD = "00000000" then        --Off
                        LeftCMD <= "00000110";
                    elsif LeftCMD = "00000110" then     --Step4
                        LeftCMD <= "00001100";
                    elsif LeftCMD = "00001100" then     --Step3
                        LeftCMD <= "00001001";
                    elsif LeftCMD = "00001001" then    --Step2
                        LeftCMD <= "00000011";
                    else                                --Step1
                        LeftCMD <= "00000110";      
                    end if;        
                end if;
            else
               LeftCount := Leftcount +1;
            end if;
        end if;
        
        JA <= ( LeftCMD + RightCMD );                   --Setting sum of motor commands to output
    end if;
end process;

end StepStep;
