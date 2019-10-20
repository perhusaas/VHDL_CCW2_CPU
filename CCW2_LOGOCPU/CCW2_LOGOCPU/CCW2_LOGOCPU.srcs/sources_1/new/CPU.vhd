library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity	cpu is
	port(
		clk, reset: std_logic;
		datab: in std_logic_vector(7 downto 0);  -- data bus
		addb: out std_logic_vector(7 downto 0); -- address bus
		output: out std_logic_vector(7 downto 0)  -- output bus
		);
end cpu;

architecture HAL9000 of cpu is		
	constant PUP: unsigned := "11100000"; -- F0H	
	constant PDN: unsigned := "11100001"; -- A1H	
	constant MF:  unsigned := "11100010"; -- E0H	
	constant MB:  unsigned := "11100100"; -- E0H	
	constant MFR: unsigned := "11100110"; -- E0H	
	constant MFL: unsigned := "11101000"; -- E0H	
	constant MBR: unsigned := "11101010"; -- E0H	
	constant MBL: unsigned := "11101100"; -- E0H	
	constant MRR: unsigned := "11101110"; -- E0H
	constant MRL: unsigned := "11110000"; -- E0H
	constant SPD: unsigned := "11110001"; -- A1H    
	constant LDRM: unsigned := "10100000"; -- A0H	
	constant INCR: unsigned := "10110000"; -- B0H	
	constant DECR: unsigned := "11000000"; -- C0H
	constant JRNZ: unsigned := "11010000"; -- D0H
	constant HALT: unsigned := "11111111"; -- FFH
	
	type	state_type is (
		  all_0, all_1   -- common to all instructions
		 );	
	signal State, Next_State:	state_type;
	
	signal ProgCount, ProgCount_Next: unsigned(7 downto 0):="00000000";
	signal InsReg, InsReg_Next: unsigned(7 downto 0):="00000000";
	signal DataReg, DataReg_Next: unsigned(7 downto 0):="00000000";
	signal RunMotor: std_logic:='0';

begin


process(clk,reset)						-- state register code section
Variable Speed: unsigned(7 downto 0):="00000000";
Variable PenMode: unsigned(7 downto 0):="00000000";
Variable RunCMD: unsigned(7 downto 0):="00000000";
Variable RunCounter: Integer:=0; 
begin

	if ( reset='1' ) then
	   State <= all_0;
	   ProgCount <= (others => '0');	-- reset address is all-0
	   output  <= (others => '0');	-- initialize output to 0
	   RunMotor <= '0';
	   RunCounter := 0;
	   Output <= "00000000";	   
	   Speed := "00000000";
	   PenMode := "00000000";
	   RunCMD := "00000000";      
	   
	elsif rising_edge(clk) then
        If RunMotor = '0' and InsReg < HALT then                --CPU
            ProgCount <= ProgCount_Next;    
            DataReg <= DataReg_Next;
            InsReg <= InsReg_Next;
            
            if InsReg = SPD then                                --Getting Speedcommand
                Speed := Insreg_Next;
            end if; 
            
            if InsReg = PDN then                                --Setting Pen mode on command
                PenMode := "00000001";
            elsif InsReg = PUP then
                PenMode := "00000000";
            end if; 
            
            If (InsReg >= MF) and (InsReg <= MRL) then         --Stop CPU on movement commands
                RunMotor <= '1'; 
                RunCMD := InsReg - "11100000";   
            end if;         
        else
            if InsReg = HALT then
                output <= "00000000";
            else
                output <= std_logic_vector(RunCMD + Speed + PenMode);
           
                if RunCounter = 0 then          --Initializing counter for Movement Commands
                    RunCounter:= (to_integer(DataReg_Next))*2000000;            
                elsif RunCounter = 1 then                                               --Reenabling CPU
                    RunMotor <= '0';
                    output <= "00000000";
                end if;            
                
                if RunMotor = '1' then                                                  --Movement Counter
                    RunCounter := RunCounter -1;
                end if;            
            end if;
        end if;
	end if;	

end process;

ProgCount_Next <= unsigned(datab) when ( InsReg = JRNZ and DataReg = "00000000")        --Jump if empty register
                                  else ProgCount+1;
                                  
DataReg_Next <=  DataReg + 1 when (InsReg = INCR)                                                                   --Incrementing Data register
                             else DataReg - 1 when (InsReg = DECR)                                                  --Decrementing Data Register
                             else unsigned(datab) when (InsReg = LDRM ) or ((InsReg <= MRL) and (InsReg >= MF)) or (InsReg = SPD)     --Data value after Command
                             else DataReg;

InsReg_Next <=  InsReg when (InsReg >= SPD) and (InsReg <= MRL) else unsigned(datab);                              --Holding instruction increment on Movement related commands

addb <= std_logic_vector(ProgCount);



end HAL9000;