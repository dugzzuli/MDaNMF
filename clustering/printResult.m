function [ac,nmi_value,RI] = printResult(X, label, K, kmeansFlag)

if kmeansFlag == 1
    indic = litekmeans(X, K, 'Replicates',20);
else
    [~, indic] = max(X, [] ,2);
end
result = bestMap(label, indic);
[ac, nmi_value, cnt] = CalcMetrics(label, indic);
RI=RandIndex(label+1, indic+1);

disp(sprintf('RI:%0.4f\tac: %0.4f\t%d/%d\tnmi:%0.4f\t', RI,ac, cnt, length(label), nmi_value));
