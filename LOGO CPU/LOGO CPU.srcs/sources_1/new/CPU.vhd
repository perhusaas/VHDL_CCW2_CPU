-- Basic CPU 

library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity	cpu is
	port(
		clk, reset: in std_logic;
		datab: in std_logic_vector(7 downto 0);  -- data bus
		addb: out std_logic_vector(7 downto 0); -- address bus
		output: out std_logic_vector(7 downto 0)  -- output bus
		);
end cpu;

architecture HAL9000 of cpu is
    constant AddrBW: integer:=8;
    constant DataBW: integer:=8;
	constant LDRM: unsigned := "10100000"; -- A0H	
	constant INCR: unsigned := "10110000"; -- B0H	
	constant DECR: unsigned := "11000000"; -- C0H
	constant JRNZ: unsigned := "11010000"; -- D0H	
	constant MxT: unsigned := "11100000"; -- E0H	
	constant PUP: unsigned := "11110000"; -- F0H	
	constant PDN: unsigned := "10100001"; -- A1H
	constant HALT: unsigned := "11111111"; -- FFH
	
	type	state_type is (
		  all_0, all_1   -- common to all instructions
		 );
	signal	State, Next_State:	state_type;
	signal	Pcount, Pcount_Next: unsigned(AddrBW-1 downto 0);
	signal	InsReg, InsReg_Next: unsigned(DataBW-1 downto 0);
	signal	Reg, Reg_Next: unsigned(DataBW-1 downto 0);

begin
process(clk,reset)						-- state register code section
begin
	if (reset='1') then
		State <= all_0;
		Pcount <= (others => '0');	-- reset address is all-0
		InsReg <= (others => '1'); 	-- default opcode is HALT (all '1')
		Reg  <= (others => '0');	-- initialize data register to 0
	elsif (clk'event and clk='1') then
		State <= Next_State;
		Pcount <= Pcount_Next;
		InsReg <= InsReg_Next;
		Reg <= Reg_Next;
	end if;
end process;

process(State,datab,Pcount,Reg)	-- next state + (Moore) outputs code section
begin
	Next_State <= State;
	Pcount_Next <= Pcount;	
	InsReg_Next <= InsReg;
	Reg_Next <= Reg;
	
	case State is
		when all_0 => 					 
			InsReg_Next <= unsigned(datab);  
			Pcount_Next <= Pcount+1;
			Next_State <= all_1;
		when all_1 =>			
			if (InsReg = LDRM) then	  
			    Reg_Next <= unsigned(datab);
                Pcount_Next <= Pcount+1;
				Next_State <= all_0;
			elsif (InsReg = INCR) then
                 Reg_Next <= Reg+1;            
                 Next_State <= all_0;
			elsif (InsReg = DECR) then
                 Reg_Next <= Reg-1;            
                 Next_State <= all_0;
			elsif (InsReg = JRNZ) then
			    Pcount_Next <= unsigned(datab);		    
                Next_State <= all_0;
            elsif (InsReg = MxT) then	  
			    Reg_Next <= unsigned(datab);
                Pcount_Next <= Pcount+1;
				Next_State <= all_0;
			elsif (InsReg = HALT) then
				Next_State <= all_1;
			else 
				Next_State <= all_0;
			end if;
			
	end case; 
end process;

addb <= std_logic_vector(Pcount);
output <= std_logic_vector(Reg);

end HAL9000;