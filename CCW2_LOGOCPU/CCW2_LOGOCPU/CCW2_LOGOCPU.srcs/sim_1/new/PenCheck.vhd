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
   variable Waittime: Integer:= 60;
   begin		
        reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "10000010"; -- MOVE1
		wait for clk_period*Waittime;		
        reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01100101"; -- MOVE2	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01000110"; -- MOVE3	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "00101001"; -- MOVE4	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01001010"; -- MOVE5	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01101101"; -- MOVE6	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "10001110"; -- MOVE7	
		wait for clk_period*Waittime;
		reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		output <= "01110001"; -- MOVE8	
		wait for clk_period*Waittime;

   end process;
   
end Behavioral;
--  10000010	Ludicrous, Forward, Pen Up
--  01100101	Fast, Backward, Pen Down
--  01000110	Medium, Forward Right, Pen Up
--  00101001	Slow, Forward Left, Pen Down
--  01001010	Medium, Backward Right, Pen Up
--  01101101	Fast, Backward Left, Pen Down
--  10001110	Ludicrous, Rotate Right, Pen Up
--  01110001	Fast, Rotate Left, Pen Down