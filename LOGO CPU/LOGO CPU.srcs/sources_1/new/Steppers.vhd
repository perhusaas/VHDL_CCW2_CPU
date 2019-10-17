--Input structure (xM):             Output Structure (JA):
--8 bits                            8 Bits
--Bit 0 (Pen Control):              Bit 0-3: Left Engine
--  1=Forward                       Bit 4-7: Right Engine
--  0=Backward
--Bit 1-4 (Speed): 
--  0000: No Movement
--  0001: Slow
--  0011: Medium
--  0111: Fast
--  1111: Ludicrus Mode!


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Steppers is
    Port (
           clk, reset: in std_logic;
           LM: in std_logic_vector(4 downto 0);
           RM: in std_logic_vector(4 downto 0);
           JA: out std_logic_vector(7 downto 0)
           );
end Steppers;

architecture StepStep of Steppers is

constant Ludicrus: integer:=500000;
constant Fast: integer:=600000;
constant Medium: integer:=700000;
constant Slow: integer:=800000;
Signal Leftspeed: integer:=0;
Signal Rightspeed: integer:=0;
Signal LeftCMD: std_logic_vector(7 downto 0):= "00000000";
Signal RightCMD: std_logic_vector(7 downto 0):= "00000000";
Signal LeftCount: integer:=0;
Signal RightCount: integer:=0;

begin

process(clk, reset)
begin
    
    if RM(4 downto 1) = "0001" then                 --Setting Speed variable for right motor
        RightSpeed <= Slow;
    elsif RM(4 downto 1) = "0011" then
        RightSpeed <= Medium;
    elsif RM(4 downto 1) = "0111" then
        RightSpeed <= Fast;
    elsif RM(4 downto 1) = "1111" then
        RightSpeed <= Ludicrus;
    end if;
    
    if RM = "00000" then                            --No move command
        RightCMD <= "00000000";
    else
        if RightCount = Rightspeed then             --Move Command!
            RightCount <= 0;                        --Resetting cycle counter
            if (RM(0) = '1')  then                  --Forward
                if RightCMD = "00000000" then       --State Off
                    RightCMD <= "00110000";
                elsif RightCMD = "00110000" then    --State Step1
                    RightCMD <= "10010000";
                elsif RightCMD = "10010000" then    --State Step2
                    RightCMD <= "11000000";
                elsif RightCMD <= "11000000" then   --State Step3
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
                elsif RightCMD <= "10010000" then    --Step2
                    RightCMD <= "00110000";
                else                                --Step1
                    RightCMD <= "01100000";      
                end if;        
            end if;
        else
            RightCount <= RightCount +1;            --Not ready for a new move yet, incrementing counter
        end if;
    end if;

    if LM(4 downto 1) = "0001" then                 --Setting Speed variable for right motor
        Leftspeed <= Slow;
    elsif LM(4 downto 1) = "0011" then
        Leftspeed <= Medium;
    elsif LM(4 downto 1) = "0111" then
        Leftspeed <= Fast;
    elsif LM(4 downto 1) = "1111" then
        Leftspeed <= Ludicrus;
    end if;
    
    if LM = "00000" then                            --Same as above for left motor
        JA(7 downto 4) <= "0000";
    else
        if LeftCount = Leftspeed then
            Leftcount <= 0;
            if (LM(0) = '1')  then                  --Forward
                if LeftCMD = "00000000" then        --Off
                    LeftCMD <= "00110000";
                elsif LeftCMD = "00110000" then     --Step1
                    LeftCMD <= "10010000";
                elsif LeftCMD = "10010000" then     --Step2
                    LeftCMD <= "11000000";
                elsif LeftCMD <= "11000000" then    --Step3
                    LeftCMD <= "01100000";
                else                                --Step4
                    LeftCMD <= "00110000";      
                end if;
            else                                    --Reverse
                if LeftCMD = "00000000" then        --Off
                    LeftCMD <= "01100000";
                elsif LeftCMD = "01100000" then     --Step4
                    LeftCMD <= "11000000";
                elsif LeftCMD = "11000000" then     --Step3
                    LeftCMD <= "10010000";
                elsif LeftCMD <= "10010000" then    --Step2
                    LeftCMD <= "00110000";
                else                                --Step1
                    LeftCMD <= "01100000";      
                end if;        
            end if;
        else
           LeftCount <= Leftcount +1;
        end if;
    end if;
    
    JA <= ( LeftCMD + RightCMD );                   --Setting sum of motor commands to output
    
end process;

end StepStep;
