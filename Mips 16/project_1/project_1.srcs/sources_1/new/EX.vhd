
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EX is
      Port( rd1: in std_logic_vector(15 downto 0);
      ALUSrc: in std_logic;
      rd2: in std_logic_vector (15 downto 0);
      Ext_Imm: in std_logic_vector (15 downto 0);
      sa: in std_logic;
      func: in std_logic_vector (2 downto 0);
      ALUOp: in std_logic_vector (2 downto 0);
      PCInc: in std_logic_vector(15 downto 0);
      zero: out std_logic;
      AluRes: inout std_logic_vector (15 downto 0);
      BranchAdress: out std_logic_vector (15 downto 0));
end EX;

architecture Behavioral of EX is
signal muxOut:std_logic_vector (15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);
begin
AluControl: process(ALUOp,func)
begin
    case ALUOp is 
        when "001"=>
            case func is 
                when "001"=>ALUCtrl<="010"; --fAdd 
                when "010"=>ALUCtrl<="000"; --fsub
                when "011"=>ALUCtrl<="011"; --fand
                when "100"=>ALUCtrl<="111"; --for
                when "101"=>ALUCtrl<="100"; --fxor
                when "110"=>ALUCtrl<="101"; --fsll
                when "111"=>ALUCtrl<="110"; --fsrl
                when "000"=>ALUCtrl<="001";
                when others=>ALUCtrl<=(others=>'X');
            end case;
       when "010"=> ALUCtrl<="010";
       when "000"=>ALUCtrl<="000";
       when "111"=>ALUCtrl<="111";
       when "011"=>ALUCtrl<="011";
       when others=>ALUCtrl<=(others=>'X');
   end case;
end process;
mux: process(ALUSrc,rd2,Ext_Imm)
    begin 
        case ALUSrc is 
            when '0'=>muxOut<=rd2;
            when '1'=>muxOut<=Ext_Imm;
            when others=>muxOut<=(others=>'X');
        end case;
    end process;
ALU: process(ALUCtrl,rd1,muxOut,sa)
begin 
    case ALUCtrl is 
        when "010"=>AluRes<=rd1+muxOut;
        when "000"=>AluRes<=rd1-muxOut;
        when "011"=>AluRes<=rd1 and muxOut;
        when "111"=>AluRes<=rd1 or muxOut;
        when "100"=>AluRes<=rd1 xor muxOut; 
        when "101"=> --<<sll
            if sa='1' then AluRes<=rd2(14 downto 0)&'0';
            else AluRes<=rd2;
            end if;
        when "110"=> -->>srl
            if sa='1' then AluRes<='0'&rd2(14 downto 0);
            else AluRes<=rd2;
            end if;
        when "001"=> --sllv
            case rd1 is
                when x"0000"=> ALURes<=muxOut;
                when x"0001"=> AluRes<=muxOut(14 downto 0)&'0';
                when x"0002"=> AluRes<=muxOut(13 downto 0)&"00";
                when x"0003"=> AluRes<=muxOut(12 downto 0)&"000";
                when x"0004"=> AluRes<=muxOut(11 downto 0)&"0000";
                when x"0005"=> AluRes<=muxOut(10 downto 0)&"00000";
                when x"0006"=> AluRes<=muxOut(9 downto 0)&"000000";
                when x"0007"=> AluRes<=muxOut(8 downto 0)&"0000000";
                when x"0008"=> AluRes<=muxOut(7 downto 0)&"00000000";
                when x"0009"=> AluRes<=muxOut(6 downto 0)&"000000000";
                when x"000A"=> AluRes<=muxOut(5 downto 0)&"0000000000";
                when x"000B"=> AluRes<=muxOut(4 downto 0)&"00000000000";
                when x"000C"=> AluRes<=muxOut(3 downto 0)&"000000000000";
                when x"000D"=> AluRes<=muxOut(2 downto 0)&"0000000000000";
                when x"000E"=> AluRes<=muxOut(1 downto 0)&"00000000000000";
                when x"000F"=> AluRes<=muxOut(0)&"000000000000000";
                when others=>ALURes<=x"0000";
           end case;
       when others=>AluRes<=(others=>'X');
     end case;
end process;
zeroDet:process(AluRes)
    begin 
    if AluRes=x"0000" then
           zero<='1';
           else zero<='0';
    end if;
end process;

BranchAdress<=Ext_Imm+PCInc;

end Behavioral;
