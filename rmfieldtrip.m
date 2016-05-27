% remove fieldtrip subdirectories from path
p=path;
p1=[];
parse=[0 find(p==';')];
for k=1:length(parse)-1
    if ~strcmp('C:\Documents and Settings\mjutras\My Documents\MATLAB\fieldtrip-20101020\',p(parse(k)+1:parse(k)+73))
        p1=[p1 p(parse(k)+1:parse(k+1))];
    end
end
path(p1)
clear k p p1 parse

