function [ bool ] = isIndep( Mim,equ )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
zero=1e-6;
%�޳�Mim��Ϊ0����
n=size(Mim,2);
i=1;
while(i<=n)
   if(abs(Mim(1,i))<1e-6&&abs(Mim(2,i))<zero)  %���Mim[:,i]ֵ����Ϊ0
       Mim(:,i)=[];
       i=i-1;
       n=n-1;
   end
   i=i+1;
end

wim=Mim(1,:);
zim=Mim(2,:);
n1=length(zim);
bool=0;
if(max(abs(zim))<zero)  %���zimֵ������Ϊ0�������  
    return;
end

if(isempty(find(zim==0, 1)))  %���zim��û�С�0��
    ratio=wim./zim;  %���б�ֵ
    for i=2:n1
        if(abs(ratio(i)-ratio(1))>equ)  %���б�ֵ������ȣ�����Ϊ�������
            bool=1;
            break;
        end
    end
    return;
end

bool=1;  %��������������������޹�

end

