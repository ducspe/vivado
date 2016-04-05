library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity SineWave_Rom_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end SineWave_Rom_v1_0;

architecture arch_imp of SineWave_Rom_v1_0 is
-- create array data type
type rom_type is array(0 to 31) of std_logic_vector(15 downto 0);
-- address for the ROM
signal addr:std_logic_vector(11 downto 0):=(others=>'0');
-- valid signal to be used internally
signal valid : std_logic := '0';
-- delay counter to make 25 clock cycles delay after reset
signal delay : integer range 0 to 25 := 0;
-- create a signal of type array and initialize it with a sine period
signal Rom:rom_type:=(
conv_std_logic_vector(33,16),
conv_std_logic_vector(32,16),
conv_std_logic_vector(30,16),
conv_std_logic_vector(27,16),
conv_std_logic_vector(23,16),
conv_std_logic_vector(18,16),
conv_std_logic_vector(13,16),
conv_std_logic_vector(6,16),
conv_std_logic_vector(0,16),
conv_std_logic_vector(-6,16),
conv_std_logic_vector(-13,16),
conv_std_logic_vector(-18,16),
conv_std_logic_vector(-23,16),
conv_std_logic_vector(-27,16),
conv_std_logic_vector(-30,16),
conv_std_logic_vector(-32,16),
conv_std_logic_vector(-33,16),
conv_std_logic_vector(-32,16),
conv_std_logic_vector(-30,16),
conv_std_logic_vector(-27,16),
conv_std_logic_vector(-23,16),
conv_std_logic_vector(-18,16),
conv_std_logic_vector(-13,16),
conv_std_logic_vector(-6,16),
conv_std_logic_vector(0,16),
conv_std_logic_vector(6,16),
conv_std_logic_vector(13,16),
conv_std_logic_vector(18,16),
conv_std_logic_vector(23,16),
conv_std_logic_vector(27,16),
conv_std_logic_vector(30,16),
conv_std_logic_vector(32,16)
);
begin

-----------------------------------
    -- tvalid logic
-----------------------------------    
process(m00_axis_aclk,m00_axis_aresetn)
    begin
    if rising_edge(m00_axis_aclk) then
   --     when reset is applied the initial delay counter is reset
   --     and the internal valid signal is set to zerp
            if m00_axis_aresetn='0' then
                delay <= 0;
                valid <= '0';
				-- after 25 clock cycle the valid signal is set to high
            elsif (delay = 24) then
                delay <= 24;
                valid <= '1';
            else
                delay <= delay + 1;    
            end if;
     --   end if;
    end if;
end process;  
-- connect the internal valid to the output valid port
m00_axis_tvalid <= valid;

-----------------------------------
--        tlast logic
-----------------------------------   
process(m00_axis_aclk,m00_axis_aresetn)
begin
if rising_edge(m00_axis_aclk) then
-- when reset is applied set the address to zero
        if (m00_axis_aresetn='0') then
            m00_axis_tlast <= '0';
            addr <= (others=>'0');
			-- when the input ready is high and the core is initialized(25 clock cycles done)
        elsif (m00_axis_tready='1' and valid='1') then
		-- if 1023 samples are outputted tlast is set high and the address is reset
            if (addr=1023) then
                m00_axis_tlast <= '1';
                addr <= (others=>'0');
				-- output the data from the rom by applying new address
            else
                m00_axis_tlast <= '0';
                addr <= addr + 1;
            end if;
        end if;
    end if;
end process;
m00_axis_tstrb <= (others=>'1');
-- the output port is imaginary & real, the imaginary is set to zero and the real is set to ROM output
m00_axis_tdata<=x"0000"&Rom(conv_integer(addr(4 downto 0)));
end arch_imp;
