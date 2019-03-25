function [ bool ] = isIndep( Mim,equ )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
zero=1e-6;
%剔除Mim均为0的列
n=size(Mim,2);
i=1;
while(i<=n)
   if(abs(Mim(1,i))<1e-6&&abs(Mim(2,i))<zero)  %如果Mim[:,i]值近似为0
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
if(max(abs(zim))<zero)  %如果zim值都近似为0，则相关  
    return;
end

if(isempty(find(zim==0, 1)))  %如果zim中没有‘0’
    ratio=wim./zim;  %两行比值
    for i=2:n1
        if(abs(ratio(i)-ratio(1))>equ)  %两行比值基本相等，即认为线性相关
            bool=1;
            break;
        end
    end
    return;
end

bool=1;  %非以上两种情况，线性无关

end

