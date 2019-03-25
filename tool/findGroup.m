function id=findGroup(virS,virGroup)
%在virGroup中找到与virS相同的一组锚点
n=length(virGroup);
for i=1:n
    vi=virGroup{i};
    if size(vi)==size(virS)
        if all(all(abs(vi-virS)<1e-3))
            id=i;
            return;
        end
    end
end
id=0;
