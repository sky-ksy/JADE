function [ deps ] = dep( wim,zim,theta )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if(norm(wim)~=0)
bim=2*sin(theta);
deps=(bim*wim/norm(wim))^2;  %������b������w�ϵ�ͶӰģ��ƽ��
else
    deps=0;
    fprintf(2,'!!!!!wimΪ0!!!!!!!!');
end

