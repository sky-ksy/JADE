function [ theta,R ] = generate_R( AoA,im,n )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
R=zeros(2,2,2);
theta=zeros(1,2);
beta=zeros(1,2);
j=1;
for i=[1,2,n]
    if(i~=im)
        theta(j)=AoA(i)-AoA(im);
        beta(j)=pi/2-theta(j);
        R(:,:,j)=[cos(beta(j)),-sin(beta(j));sin(beta(j)),cos(beta(j))];
        j=j+1;
    end
end

end

