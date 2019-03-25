function [ Xt ] = transCol( X,im,n )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
Xt=zeros(2,n-1);
for i=1:im-1
   Xt(:,i)=X(:,i)-X(:,im);
end
for i=im+1:n
    Xt(:,i-1)=X(:,i)-X(:,im);
end

end

