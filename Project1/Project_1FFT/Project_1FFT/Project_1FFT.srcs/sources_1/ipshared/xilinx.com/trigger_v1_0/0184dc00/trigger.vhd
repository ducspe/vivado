----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2015 10:07:10 PM
-- Design Name: 
-- Module Name: trigger - Behavioral
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

entity trigger is
    Port ( clk : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (23 downto 0);
           edge : out STD_LOGIC);
end trigger;

architecture Behavioral of trigger is
signal temp:std_logic_vector(23 downto 0);
begin
process(clk)
begin
if rising_edge(clk) then
    temp<=din;
    if (temp/=din) then
        edge<='1';
    else
        edge<='0';
    end if;
end if;
end process;

end Behavioral;
