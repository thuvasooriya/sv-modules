# wip
set shell := ["nu", "-c"]
set fallback

alias v := iverilog2005
alias sv := iverilog2012
alias svca := iverilog2012checkall

topmodule := "fsm/sqd1010me_tb.v"
svtopmodule := "fsm/sqd0110me_tb.sv"

arch := arch()
num_cpus := num_cpus()
os := os()
home_dir := env_var('HOME')
inv_dir := invocation_directory()
abs_path := absolute_path("./")
chk_path := path_exists("./")

@_default:
  just --list --list-heading ""

# compiling verilog (ieee1800-2005) with iverilog
[unix]
iverilog2005 +FILES=topmodule:
  iverilog -I fsm -I adders -Wall -o ivout.o {{FILES}}
  vvp ivout.o

# compiling systemverilog (ieee1800-2012) with iverilog
[unix]
iverilog2012 +FILES=svtopmodule:
  iverilog -I fsm -I adders -g2012 -Wall -o isvout.o {{FILES}}
  vvp isvout.o

[unix]
iverilog2012checkall +FILES="fsm/*.sv":
  iverilog -I fsm -I adders -g2012 -Wall -o isvout.o {{FILES}}
  vvp isvout.o
  

# viewing waveform.vcd generated with simulators
waves:
  gtkwave -6  waveform.vcd

[confirm("this can't be right, r u sure?"), unix]
_clean:
  rm -rf something
