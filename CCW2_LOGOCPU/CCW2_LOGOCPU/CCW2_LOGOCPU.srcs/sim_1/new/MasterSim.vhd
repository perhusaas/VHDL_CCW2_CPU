----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2019 14:07:38
-- Design Name: 
-- Module Name: MasterSim - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MasterSim is
--  Port ( );
end MasterSim;

architecture Behavioral of MasterSim is

component Master
    port(
			clk, reset: in std_logic;
			JA: out std_logic_vector(7 downto 0);
			ServoPWM: out std_logic
        );
end component;

   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   Signal JA: std_logic_vector(7 downto 0); --0-3: Left Motor, 4-7: Right Motor
   Signal ServoPWM: std_logic;
   
   -- Clock period definitions
   constant clk_period : time := 10 ns;

begin

uut: Master
port map( clk => clk, reset => reset, 
           JA => JA, ServoPWM => ServoPWM
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
		wait for clk_period*60000000;

   end process;      

end Behavioral;
