function id=findGroup(virS,virGroup)
%��virGroup���ҵ���virS��ͬ��һ��ê��
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
