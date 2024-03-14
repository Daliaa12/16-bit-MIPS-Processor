
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture Behavioral of test_env is


component SSD is
    Port ( clk: in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;


component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;


component IFetch is
    Port (Jump: in std_logic;
          JumpAddress: in std_logic_vector(15 downto 0);
          BranchAddress: in std_logic_vector (15 downto 0);
          PCSrc:in std_logic;
          en:in std_logic;
          rst:in std_logic;
          clk:in std_logic;
          Instruction: out std_logic_vector(15 downto 0);
          PCinc: out std_logic_vector (15 downto 0));
end component;


component MainControl is
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
end component;

component ID is
     Port (instr: in std_logic_vector(15 downto 0);
            clk: in std_logic;
            en: in std_logic;
            wd: in std_logic_vector(15 downto 0);
            rd1: out std_logic_vector(15 downto 0);
            rd2: out std_logic_vector(15 downto 0);
            ext_imm: out std_logic_vector(15 downto 0);
            func: out std_logic_vector(2 downto 0);
            sa: out std_logic;
            RegWrite: in std_logic;
            RegDst: in std_logic;
            ExtOp: in std_logic);
end component;

component EX is
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
end component;

component MEM is
        Port(ALUResin: in std_logic_vector (15 downto 0);
             rd2: in std_logic_vector (15 downto 0);
             clk: in std_logic;
             en: in std_logic;
             MemData: out std_logic_vector (15 downto 0);
             MemWrite:in std_logic;
             ALUResout: out std_logic_vector(15 downto 0)); 
end component;

component reg_file is
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    wen : in std_logic;
    en : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
    );
end component;



    signal en: std_logic;
    signal en2: std_logic;
    signal ins: std_logic_vector(15 downto 0);
    signal PCInc: std_logic_vector(15 downto 0);
    signal RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite: std_logic;
    signal rd1,rd2,Ext_Imm: std_logic_vector(15 downto 0);
    signal func: std_logic_vector (2 downto 0);
    signal sa,zero: std_logic;
    signal sum: std_logic_vector(15 downto 0);
    signal muxOut: std_logic_vector (15 downto 0);
    signal ALUOp: std_logic_vector (2 downto 0);
    signal wd:std_logic_vector(15 downto 0);
    signal MemData, ALUResout,ALURes,ALUResin:std_logic_vector(15 downto 0);
    signal BranchAdress:std_logic_vector(15 downto 0);
    signal JumpAdress:std_logic_vector(15 downto 0);
    signal PCSrc:std_logic;
    --signal wb: std_logic_vector(15 downto 0);
    signal BA: std_logic_vector(15 downto 0);

begin

iff: IFetch port map (Jump,JumpAdress,BA,PCSrc,en,en2,clk,ins,PCInc);
debouncer: MPG port map (en,btn(0),clk);
debouncer2: MPG port map (en2, btn(1),clk);
led(10 downto 0)<=ALUOp&RegDst&ExtOp&ALUSrc&Branch&Jump&MemWrite&MemtoReg&RegWrite;
Main: MainControl port map (RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite,ins);
IDD: ID port map (ins,clk,en,wd,rd1,rd2,Ext_Imm,func,sa,RegWrite,RegDst,ExtOp);
mux:process (sw(7 downto 5),PCInc,ins,rd1,rd2,sum,Ext_Imm,MemData,wd)
begin
    case sw(7 downto 5) is 
        when "000"=> muxOut<=ins;
        when "001"=>muxOut<=PCInc;
        when "010"=>muxOut<=rd1;
        when "011"=>muxOut<=rd2;
        when "100"=>muxOut<=Ext_Imm;
        when "101"=>muxOut<=ALURes;
        when "110"=>muxOut<=MemData;
        when "111"=>muxOut<=wd;
        when others=>muxOut<=(others=>'X');
    end case;
end process;
BA<=BranchAdress;
ssdd: SSD port map (clk,muxOut,an,cat);
exx: EX port map (rd1,ALUSrc,rd2,Ext_Imm,sa,func,ALUOp,PCInc,zero,ALURes,BranchAdress);
meem: MEM port map (ALURes,rd2,clk,en,MemData,MemWrite,ALUResout);
mux2: process(MemData,ALUResout,MemtoReg)
begin 
    case MemtoReg is 
        when '1'=>wd<=MemData;
        when '0'=>wd<=ALUResout;
        when others=>wd<=(others=>'X');
    end case;
end process;

PCSrc<=Branch and zero;
JumpAdress<=PCInc(15 downto 13)&ins(12 downto 0);

end Behavioral;

