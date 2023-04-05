TEST_ENT = entite_test

SRC = combi.vhd mem.vhd reg_bank.vhd etages.vhd proc.vhd test.vhd

all: clear simul

analysis: $(SRC)
	ghdl  -a $^ 

elab:	analysis
	ghdl -e $(TEST_ENT) 

simul: elab
	ghdl -r $(TEST_ENT) --vcd=out.vcd

clear:
	clear

wave: simul
	gtkwave out.vcd