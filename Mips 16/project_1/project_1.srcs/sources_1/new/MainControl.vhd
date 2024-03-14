----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2023 21:34:54
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
Port( RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    Branch:out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector(2 downto 0);
    MemWrite: out std_logic;
    MemtoReg: out std_logic;
    RegWrite: out std_logic;
    Instr: in std_logic_vector(15 downto 0));
end MainControl;

architecture Behavioral of MainControl is
begin
process(Instr(15 downto 13))
begin
    RegDst<='0'; ExtOp<='0'; ALUSrc<='0';
    Branch<='0'; Jump<='0'; MemWrite<='0';
    MemtoReg<='0'; RegWrite<='0'; ALUOp<="000";
  case Instr(15 downto 13) is 
       when "000"=> RegDst<='1'; RegWrite<='1'; ALUOp<="001"; --R
       when "001"=> ExtOp<='1'; ALUSrc<='1';RegWrite<='1'; ALUOp<="010"; --ADDI
       when "010"=> ExtOp<='1'; ALUSrc<='1';MemWrite<='1'; ALUOp<="010"; --SW
       When "111"=> ExtOp<='1'; ALUSrc<='1'; MemtoReg<='1'; RegWrite<='1'; ALUOp<="010"; --LW
       when "011"=> ExtOp<='1'; Branch<='1';ALUOp<="000"; --BEQ
       when "100"=> ALUSrc<='1'; RegWrite<='1';ALUOp<="111"; --ORI
       when "101"=> ExtOp<='1'; ALUSrc<='1'; RegWrite<='1';ALUOp<="011"; --ANDI
       when "110"=> Jump<='1'; --Jump
       when others=>Jump<='0';
  end case;
end process;
end Behavioral;
