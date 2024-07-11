# sv modules

this repo culminates the system verilog code i've written used and found useful over the years to find the best practices and gotchas.
consists of mostly simple modules.

simulations are primarily done by iverilog (verilog test benches) and verilator (cpp testbenches)

i don't think we have clear distinction between verilog and systemverilog anymore, i mean both
languages are from the ieee-1800 standard anyways
when you run iverilog without any -g flags it follows the 2005 standard
which was the last standard before the 2009 standard, which introduced systemverilog.
if you want to test your verilog skills that's the way to go (no flags or -g2005).
but hey, no promises.

i'll be doing the simulations for sv testbenches with -g2012 to keep my sanity

## todo

- [ ] finish with 0110 (systemverilog) and 1010 (verilog) sequence detectors
- [ ] find out other state machine types and implement a testbench for the sequence detector
- [ ] cleanup maxpooling code and implement and document it as a proper module
- [ ] experiment with cocotb on another branch

## conventions used in this repo

- usual module name = file name conventions are followed
- testbenches are named modulename_tb and kept in the same directory as the module
- all inputs and outputs must be mentioned separately and type defined, makes it easier for writing documentation too

### verilog ramblings

- there are so many fucking ways to write a verilog module and the standards are
  never followed completely by any damn tool so good luck finding what code does what magic

### systemverilog ramblings

- same problems with verilog magnified with all the non synthesizable part added to this
- ieee 1800 standard describes systemverilog and recently 2023 standard was also introduced
- no opensource software has full compliance with even ieee-1800-2017 and
  i'm absolutely certain that even closed source ones that cost an arm and a leg are not either.
  so good fucking luck again
