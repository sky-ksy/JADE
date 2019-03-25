function [ inds ] = indep( wim,zim,theta )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
bim=2*sin(theta);
wb=wim'*bim';
wz=wim'*zim;
zb=zim'*bim';

wm=norm(wim)^2;
zm=norm(zim)^2;

inds=wb^2*zm/(wm*zm-wz^2)+...  %公式17
    (zb^2*wm-2*wb*zb*wz)/(wm*zm-wz^2);

end

