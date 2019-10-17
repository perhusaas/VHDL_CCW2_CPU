--Checks OUTPUTS Segment

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Steppercheck is
end Steppercheck;

architecture Behavioral of Steppercheck is

component Outputs
    port(
      clk, reset: in std_logic;
      ob: in std_logic_vector(7 downto 0);
      JA: out std_logic_vector(7 downto 0);
      JB: out std_logic_vector(7 downto 0)
        );        
end component;

   signal clk : std_logic := '0';
   signal reset : std_logic := '0';      
   Signal JB : std_logic_vector(7 downto 0);
   signal output: std_logic_vector(7 downto 0);
   Signal JA: std_logic_vector(7 downto 0); --0-3: Left Motor, 4-7: Right Motor
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
begin

	  uut: Outputs
	  port map( clk => clk, reset => reset, 
	            ob => output, 
	            JA => JA, 
	            JB => JB	
				);	  	

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin		
        reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "10000110"; -- MOVE
		wait for clk_period*4500000;		
        reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01101101"; -- MOVE	
		wait for clk_period*4500000;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "00101111"; -- MOVE	
		wait for clk_period*4500000;

   end process;
   
end Behavioral;
