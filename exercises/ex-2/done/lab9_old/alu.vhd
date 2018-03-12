library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
port(   Clk : in std_logic; --clock signal
        A,B : in signed(31 downto 0); --input operands
        Op : in unsigned(3 downto 0); --Operation to be performed
        R : out signed(31 downto 0)  --output of ALU
        );
end alu;

architecture Behavioral of alu is

--temporary signal declaration.
signal Reg1,Reg2,Reg3 : signed(31 downto 0) := (others => '0');

begin

Reg1 <= A;
Reg2 <= B;
R <= Reg3;

process(Clk)
    variable prod : signed(63 downto 0);
begin

    if(rising_edge(Clk)) then --Do the calculation at the positive edge of clock cycle.
        case Op is
            when "0000" =>
                Reg3 <= Reg1 + Reg2;  --addition
            when "0001" =>
                Reg3 <= Reg1 - Reg2; --subtraction
            when "0010" =>
                Reg3 <= not Reg1;  --NOT gate
            when "0011" =>
                Reg3 <= Reg1 nand Reg2; --NAND gate
            when "0100" =>
                Reg3 <= Reg1 nor Reg2; --NOR gate
            when "0101" =>
                Reg3 <= Reg1 and Reg2;  --AND gate
            when "0110" =>
                Reg3 <= Reg1 or Reg2;  --OR gate
            when "0111" =>
                Reg3 <= Reg1 xor Reg2; --XOR gate
            when "1000" =>
                prod := Reg1 * Reg2; --multiplication
                Reg3 <= prod(31 downto 0); --multiplication
            when others =>
                NULL;
        end case;
    end if;

end process;

end Behavioral;
