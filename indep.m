function [ inds ] = indep( wim,zim,theta )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
bim=2*sin(theta);
wb=wim'*bim';
wz=wim'*zim;
zb=zim'*bim';

wm=norm(wim)^2;
zm=norm(zim)^2;

inds=wb^2*zm/(wm*zm-wz^2)+...  %��ʽ17
    (zb^2*wm-2*wb*zb*wz)/(wm*zm-wz^2);

end

