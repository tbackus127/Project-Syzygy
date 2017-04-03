@echo off
set xv_path=G:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim BarrelShifter16B_behav -key {Behavioral:sim_1:Functional:BarrelShifter16B} -tclbatch BarrelShifter16B.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
