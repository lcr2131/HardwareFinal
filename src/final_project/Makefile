TOP=top.sv
INTERFACE=interface.sv
BENCH=bench.sv
DUT=cam.sv cam_row.sv cam_cell.sv dec.sv priority_en.sv mux.sv

.PHONY: help

tmp:
	make clean
	make bench

help:
	@echo "The following make targets are supported:" ;\
	echo " bench  - builds and runs the testbench";\
	echo " expand - expands veritedium directives (autoargs, inst etc.)";\
	echo " indent - automatically indents verilog and c files" ;\
	echo " clean  - cleans testbench and intermediate files" ;\
	echo " help   - show this information";\


indent:
	emacs --batch *.sv -f verilog-batch-indent
	indent -linux *.c *.h
	rm *~

dut:  
	vcs -PP -full64 -sverilog +define+SV +define+VPD $(INTERFACE) $(DUT) 

test: 
	vcs -PP -full64 -sverilog +define+SV +define+VPD $(INTERFACE) $(BENCH)

bench: 
	vcs -PP -full64 -sverilog +define+SV +define+VPD $(TOP) $(INTERFACE) $(DUT) $(BENCH) -o testbench.exe

clean:
	rm -rf *.o *~ *.vpd sim* csrc DVEfiles *daidir *exe

gtk:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &
leda:
	#leda -full64 -sverilog -top $(TOP) $(INTERFACE) $(DUT) $(BENCH).sv
	leda -full64 -sverilog -top $(TOP) $(INTERFACE) $(DUT) $(BENCH)
