function [ theta,R ] = generateR( AoA,im,n )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
R=zeros(2,2,n-1);
theta=zeros(1,n-1);
beta=zeros(1,n-1);
for i=1:im-1
   %theta(i)=abs(AoA(i)-AoA(im));
   theta(i)=AoA(i)-AoA(im);
   beta(i)=pi/2-theta(i);
   %R(:,:,i)=[cos(beta(i)),sin(beta(i));-sin(beta(i)),cos(beta(i))]; %论文
   R(:,:,i)=[cos(beta(i)),-sin(beta(i));sin(beta(i)),cos(beta(i))];
end
for i=im+1:n
   %theta(i-1)=abs(AoA(i)-AoA(im));
   theta(i-1)=AoA(i)-AoA(im);
   beta(i-1)=pi/2-theta(i-1);
   %R(:,:,i-1)=[cos(beta(i-1)),sin(beta(i-1));-sin(beta(i-1)),cos(beta(i-1))]; %论文
   R(:,:,i-1)=[cos(beta(i-1)),-sin(beta(i-1));sin(beta(i-1)),cos(beta(i-1))];
end

end

