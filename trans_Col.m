function [ Xt ] = trans_Col( X,im,n )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
Xt=zeros(2,2);
j=1;
for i=[1,2,n]
    if(i~=im)
        Xt(:,j)=X(:,i)-X(:,im);
        j=j+1;
    end    
end

end

