library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MEM is
        Port(ALUResin: in std_logic_vector (15 downto 0);
             rd2: in std_logic_vector (15 downto 0);
             clk: in std_logic;
             en: in std_logic;
             MemData: out std_logic_vector (15 downto 0);
             MemWrite:in std_logic;
             ALUResout: out std_logic_vector(15 downto 0)); 
end MEM;

architecture Behavioral of MEM is
type t_mem is array (0 to 32) of std_logic_vector(15 downto 0);
signal MEM2 : t_mem := (
    X"0005",
    X"0006",
    X"0007",
    X"0008",
    X"000B",
    X"000F",
    X"0009",
    X"0008",
    others => X"0000");
begin
process(clk)
    begin 
        if clk='1' and clk'event then
        if en='1' and MemWrite='1' then 
        MEM2(conv_integer(ALUResin(4 downto 0)))<=rd2;
        end if;
        end if;
end process; 
MemData<=MEM2(conv_integer(ALUResin(4 downto 0)));
ALUResout<=ALUResin;

end Behavioral;
