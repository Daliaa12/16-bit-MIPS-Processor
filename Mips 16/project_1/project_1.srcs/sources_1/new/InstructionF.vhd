
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity IFetch is
    Port (Jump: in std_logic;
    JumpAddress: in std_logic_vector(15 downto 0);
    BranchAddress: in std_logic_vector (15 downto 0);
    PCSrc:in std_logic;
    en:in std_logic;
    rst:in std_logic;
    clk:in std_logic;
    Instruction: out std_logic_vector(15 downto 0);
    PCinc: out std_logic_vector (15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
    signal mux1: std_logic_vector (15 downto 0);
    signal mux2: std_logic_vector(15 downto 0);
    signal add: std_logic_vector(15 downto 0);
    signal q: std_logic_vector(15 downto 0);
    signal d: std_logic_vector(15 downto 0);
    type tROM is array (0 to 31) of std_logic_vector(15 downto 0);
    signal ROM: tROM:=(
    B"000_000_000_001_0_001", -- 1 --x"11", add $1,$0,$0 , initializez i=0,contorul buclei
    B"001_000_100_0000100", -- 2 --x"2204", addi $4,$0,4, se salveaza nr maxim de iteratii=4
    B"000_000_000_010_0_001", -- 3 --x"21", add $2,$0,$0, initializez indexul locatiei de memorie
    B"000_000_000_101_0_001", -- 4 --x"51", add $5,$0,$0, sum=0
    B"011_001_100_0000110", -- 5 --x"6606", beq $1,$4,6, daca s-au facut 10 iteratii salt inafara buclei
    B"111_010_011_0000000", -- 6 --x"E980", lw $3,0($2), in $3 se aduce elementul curent al sirului
    B"010_010_011_0000000", -- 7 --x"4980", sw $3,0($2), salvezz noua valoare din sir ca fiind curenta in $3
    B"000_101_011_101_0_001", -- 8 --x"15D1", add $5,$5,$3 se adunã la suma partialã din $5 elementul curent
    B"001_010_010_0000001", -- 9 --x"2901", addi $2,$2,1, indexul urmãtorului element din sir
    B"001_001_001_0000001", -- 10 --x"2481", addi $1,$1,1, i = i + 1, actualizarea contorului buclei
    B"110_0000000000100", -- 11 --x"C004", j 4, salt inceput bucla
    B"010_000_101_0000001", -- 12 --x"4281", sw $5,1($0), salvez suma in memorie la adresa sum
    others=>"0000000000000000");
begin
--PC
    process(clk)
    begin
    if clk='1' and clk'event then
       if rst='1' then
          q<="0000000000000000";
       elsif en='1' then 
          q<=mux2;
       end if;
    end if;
    end process;
add<=q+1;
--mux1
    process(add,PCSrc,BranchAddress)
    begin 
        case PCSrc is 
        when '1' => mux1<=BranchAddress;
        when '0' => mux1<=add;
        when others=>mux1<=(others=>'X');
    end case;
    end process;
--mux2
    process(Jump,JumpAddress,mux1)
    begin
        case Jump is 
        when '1' =>mux2<=JumpAddress;
        when '0' =>mux2<=mux1;
        when others=>mux2<=(others=>'X');
        end case;
    end process;
Instruction<=ROM(conv_integer(q(4 downto 0)));
PCInc<=add;

end Behavioral;
