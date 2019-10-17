----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2019 20:39:46
-- Design Name: 
-- Module Name: Steppercheck - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Steppercheck is
end Steppercheck;

architecture Behavioral of Steppercheck is

component Steppers
    port(
      clk, reset: in std_logic;
      LM: in std_logic_vector(4 downto 0);
      RM: in std_logic_vector(4 downto 0);
      JA: out std_logic_vector(7 downto 0)
        );        
end component;

   signal clk : std_logic := '0';
   signal reset : std_logic := '0';      
   Signal LM : std_logic_vector(4 downto 0):="00000";
   Signal RM : std_logic_vector(4 downto 0):="00000";
   Signal JA: std_logic_vector(7 downto 0); --0-3: Left Motor, 4-7: Right Motor
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
begin

uut: Steppers
port map( clk => clk, reset => reset, 
        LM => LM,
        RM => RM, 
        JA => JA
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
		RM <= "00001"; -- MOVE	
		LM <= "01111"; -- MOVE
		wait for clk_period*200;		
        reset <= '1';
        wait for clk_period*2;
		reset <= '0';	
		RM <= "10001"; -- MOVE	
		LM <= "11111"; -- MOVE
		wait for clk_period*200;

   end process;
   
end Behavioral;
