function [ Xt ] = trans_Col( X,im,n )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Xt=zeros(2,2);
j=1;
for i=[1,2,n]
    if(i~=im)
        Xt(:,j)=X(:,i)-X(:,im);
        j=j+1;
    end    
end

end

