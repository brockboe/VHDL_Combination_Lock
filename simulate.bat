iverilog -o lockFSM lock.v lock_tb.v
vvp lockFSM
pause