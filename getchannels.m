function [lfpind,spkind,eyeind,namarr]=getchannels(dataset)

header=getnexheader(dataset);
numvar = size(header.varheader,2);
clear typarr
for varlop = 1:numvar
    typarr(varlop) = header.varheader(varlop).typ;
end
clear namarr
for varlop = 1:numvar
    namarr(varlop,1:64) = char(header.varheader(varlop).nam');
end
spkind = find(typarr == 0);
analogind = find(typarr == 5);
lfpindbzganalog = find(double(namarr(analogind,1)) == 65);
lfpind = analogind(lfpindbzganalog);
eyeind=analogind([find(double(namarr(analogind,1)) == 88) find(double(namarr(analogind,1)) == 89)]);
sortindx=find(double(namarr(spkind,7)) ~= 105);
spkind=spkind(sortindx);
