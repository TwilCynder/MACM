TEST_ENT = entite_test

SRC = combi.vhd mem.vhd reg_bank.vhd decode.vhd etages.vhd proc.vhd test.vhd

all: clear simul

analysis: $(SRC)
	ghdl  -a $^ 

elab:	analysis
	ghdl -e $(TEST_ENT) 

simul: elab
	ghdl -r $(TEST_ENT) $(ARCH) --vcd=out.vcd

clear:
	clear

wave: simul
	gtkwave out.vcd
