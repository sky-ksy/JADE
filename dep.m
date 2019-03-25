function [ deps ] = dep( wim,zim,theta )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if(norm(wim)~=0)
bim=2*sin(theta);
deps=(bim*wim/norm(wim))^2;  %求向量b在向量w上的投影模的平方
else
    deps=0;
    fprintf(2,'!!!!!wim为0!!!!!!!!');
end

