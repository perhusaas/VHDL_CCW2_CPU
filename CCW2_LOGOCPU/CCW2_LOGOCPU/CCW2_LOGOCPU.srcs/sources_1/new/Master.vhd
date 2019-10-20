library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Master is
	port(
			clk, reset: in std_logic;
			JA: out std_logic_vector(7 downto 0);
			ServoPWM: out std_logic
		);
end Master;

architecture Top_Level of Master is
	constant ABW: integer := 8; -- address bus width
	constant DBW: integer := 8;  -- date bus width
	signal output: std_logic_vector(7 downto 0);
    signal addb: std_logic_vector(ABW-1 downto 0);
	signal datab: std_logic_vector(DBW-1 downto 0);
	--signal RunMotor: std_logic;
	
component cpu
    port(
        clk, reset: in std_logic;
        datab: in std_logic_vector(7 downto 0); -- CPU input data bus
        output: out std_logic_vector(7 downto 0); -- CPU output data bus
        addb:  out std_logic_vector(7 downto 0) -- CPU address bus
        );
end component;
        
component ROM
    port(

      addb: in std_logic_vector(7 downto 0);
      datab: out std_logic_vector(7 downto 0)
        );        
end component;

component Outputs
    port(
      clk, reset: in std_logic;--, RunMotor: in std_logic;
      ob: in std_logic_vector(7 downto 0);
      JA: out std_logic_vector(7 downto 0);
      ServoPWM: out std_logic
        );        
end component;

begin  
        
	  ctr_unit: cpu	
      port map ( clk => clk, reset => reset,-- RunMotor=>RunMotor,
                 addb => addb, datab => datab, output => output
				);
					
      rom_unit: Rom	
      port map( addb => addb, 
				datab => datab
				);	
	  
	  Op_unit: Outputs
	  port map( clk => clk, reset => reset, --RunMotor=>RunMotor,
	            ob => output, 
	            JA => JA, 
	            ServoPWM => ServoPWM	
				);	  	

      
      	
end  Top_Level;