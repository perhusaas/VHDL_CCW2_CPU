----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2019 19:43:44
-- Design Name: 
-- Module Name: PenCtrl - Behavioral
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

entity PenCtrl is
    Port ( 
           clk, reset: in std_logic;
           Penable : in STD_LOGIC;
           JB : out std_logic_vector(7 downto 0)
           );
end PenCtrl;

architecture WriteStuff of PenCtrl is

begin


end WriteStuff;
