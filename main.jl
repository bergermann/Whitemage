
using Whitemage, Blackmage

md, ctrl = Whitemage.main(; config="config_test.toml")

Whitemage.applySettings!(md,ctrl)
Whitemage.confirmPositions!(md,ctrl)

Whitemage.updateConfig!(md,ctrl,"config_test.toml")

close(md)



getMeasurementEnabled(md)

