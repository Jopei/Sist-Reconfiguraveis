Library ieee;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_1164.all;

Entity ula is
	Port (
		a_in : in std_logic_vector(7 Downto 0);
		b_in : in std_logic_vector(7 Downto 0);
		c_in : in std_logic;
		op_sel : in std_logic_vector(3 Downto 0);
		r_out : out std_logic_vector(7 Downto 0);
		c_out : out std_logic;
		z_out : out std_logic;
		v_out : out std_logic
		);
End Entity;
--------------------------

Architecture ULA of ula is
		Signal ponto : std_logic_vector(7 Downto 0);
		Signal aux : std_logic_vector(8 Downto 0);
        Signal aux2 : std_logic_vector(4 Downto 0);
		Constant Zero : std_logic_vector(7 Downto 0) := "00000000";
		Constant Um : std_logic_vector(7 Downto 0) := "00000001";
		Constant OP_SRL : std_logic_vector (3 Downto 0) := "0000";
		Constant OP_SRA : std_logic_vector (3 Downto 0) := "0001";
		Constant OP_SLL : std_logic_vector (3 Downto 0) := "0010";
		Constant PASS_B : std_logic_vector (3 Downto 0) := "0011";
		Constant OP_RR : std_logic_vector (3 Downto 0) := "0100";
		Constant OP_RL : std_logic_vector (3 Downto 0) := "0101";
		Constant OP_RRC : std_logic_vector (3 Downto 0) := "0110";
		Constant OP_RLC : std_logic_vector (3 Downto 0) := "0111";
		Constant OP_ADD : std_logic_vector (3 Downto 0) := "1000";
		Constant OP_SUB : std_logic_vector (3 Downto 0) := "1001";
		Constant OP_ADDC : std_logic_vector (3 Downto 0) := "1010";
		Constant OP_SUBC : std_logic_vector (3 Downto 0) := "1011";
		Constant OP_OR : std_logic_vector (3 Downto 0) := "1100";
		Constant OP_AND : std_logic_vector (3 Downto 0) := "1101";
		Constant OP_XOR : std_logic_vector (3 Downto 0) := "1110";
		Constant OP_NOT : std_logic_vector (3 Downto 0) := "1111";
		
Begin 
		WITH op_sel SELECT
			aux <= '0' & c_in & a_in(7 DOWNTO 1) WHEN OP_SRL,
			'0' & a_in(7) & a_in(7 DOWNTO 1)  WHEN OP_SRA,
			'0' & a_in(6 DOWNTO 0) & c_in WHEN OP_SLL,
			'0' & (b_in) WHEN PASS_B,
			(a_in(0) & c_in & a_in(7 DOWNTO 1)) WHEN OP_RR,
			(a_in(7) & a_in(6 DOWNTO 0) & c_in) WHEN OP_RL,
			a_in(0) & a_in(7 DOWNTO 0) WHEN OP_RRC,
			a_in(7 DOWNTO 0) & c_in WHEN OP_RLC,
			(('0' & a_in) + ('0' & b_in)) WHEN OP_ADD,
			'0' & (a_in - b_in) WHEN OP_SUB,
			'0' & (a_in + b_in + c_in) WHEN OP_ADDC,
			'0' & (a_in - b_in - c_in) WHEN OP_SUBC,
			'0' & (a_in OR b_in)  WHEN OP_OR,
			'0' & (a_in AND b_in) WHEN OP_AND,
			'0' & (a_in XOR b_in) WHEN OP_XOR,
			'0' & (NOT a_in) WHEN OP_NOT,
			"000000000" WHEN OTHERS;
		
		r_out <= aux(7 DOWNTO 0);
		z_out <= '1' WHEN aux(7 DOWNTO 0) = "00000000";
		
		WITH op_sel SELECT
			c_out  <= 	a_in(7) WHEN OP_SLL,
						a_in(0) WHEN OP_SRA,
						a_in(0) WHEN OP_SRL,
						a_in(7) WHEN OP_RL,
						a_in(0) WHEN OP_RR,
						aux(8) WHEN OP_ADDC,
						aux(8) WHEN OP_ADD,
						NOT aux(8) WHEN OP_SUB,
						NOT aux(8) WHEN OP_SUBC,
						a_in(7) WHEN OP_RLC,
						a_in(0) WHEN OP_RRC,
						'0' WHEN OTHERS;	
		
		WITH op_sel SELECT
		v_out <= '1' WHEN OP_ADD, 
				'1' WHEN OP_SUB,
				'1' WHEN OP_ADDC,
				'1' WHEN OP_SUBC,
				'0' WHEN OTHERS;
		
End ULA;