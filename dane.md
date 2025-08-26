#utworz plik dane.te
#skompiluj i zaladuj modul

checkmodule -M -m -o dane.mod dane.te
semodule_package -o dane.pp -m dane.mod
semodule -i dane.pp

#ustaw uprawnienia:
semanage fcontext -a -t dane_exec_t "/dane/bin/myapp"
restorecon -v /dane/bin/myapp

#test:
ausearch -m avc -ts recent

