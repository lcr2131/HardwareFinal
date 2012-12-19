TOP = submission/top.sv
DUV = $(filter-out $(TOP), $(wildcard submission/*.sv))
OUTPUT = testbench.exe


.PHONY: help all indent bench test clean

all:
	make clean
	make bench
	make test

help:
	@echo "make all    - cleans, builds, and tests"
	@echo "make bench  - builds the testbench"
	@echo "make test   - runs the testbench"
	@echo "make indent - indents verilog files"
	@echo "make clean  - cleans testbench and associated files"

indent:
	emacs --batch *.sv -f verilog-batch-indent
	indent -linux *.c *.h
	rm *~

bench:
	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE $(TOP) $(DUV) -o $(OUTPUT)

coverage:

	/sim/synopsys/vcs/bin/urg -dir "$(OUTPUT).vdb"

test:
	./$(OUTPUT)

clean:
	rm -rf *~ csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd *.vdb  DVEfiles urgReport
