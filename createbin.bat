data2mem -bd lockFSM.elf -bt lockFSM.bit
promgen -w -p bin -u 0x0 lockFSM.bit -spi -o lockFSMbin
pause