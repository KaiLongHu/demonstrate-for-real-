transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/speed_select.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/my_uart_tx.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/switch.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/demonstrate.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/LTC231512.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/switch_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/AD_FIFO.v}
vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/max1452_top.v}

vlog -vlog01compat -work work +incdir+D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/simulation/modelsim {D:/altera/project/513PROJECT/demonstrate_V009_debounce_keyreset/simulation/modelsim/switch_ctrl.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  switch_ctrl_vlg_tst

add wave *
view structure
view signals
run -all
