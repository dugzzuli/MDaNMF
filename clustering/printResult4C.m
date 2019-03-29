function [ac,nmi_value,RI] = printResult4C(indic, label)
[ac, nmi_value, cnt] = CalcMetrics(label, indic);
RI=RandIndex(label+1, indic+1);
