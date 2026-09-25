
using Whitemage, Blackmage

ctrl, s = Whitemage.main(; config="config_test.toml")

# close(ctrl.md); close(s)
close(s)

# mcTargetP(ctrl.md,[0.,0.,0.,])
# typeof(ctrl.md[1].settings.mrss)

mcZeroSoft(md,offset)
resetAxes(md)
