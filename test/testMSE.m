function  [mse]=testMSE( X,AoA,flag,viOry )

X;   %�����Ծ���
mse=0;
n=size(AoA,2);
if(flag==1)  %���������û�λ��y
    for i=1:n
        Xii=transCol(X,i,n);
        [thetai,Ri]=generateR(AoA,i,n);
        Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
        bi=2*sin(thetai);
        y=viOry;
        vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;  %y�����յ�ƽ��ֵ
        sub=vi'*Mi-bi;
        mse=mse+norm(sub)^2;
    end
else   %������������еľ�����ı仯����ʱy��û�м������
    for i=3:n
        Xii=transCol(X,i,n);
        [thetai,Ri]=generateR(AoA,i,n);
        Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
        bi=2*sin(thetai);
        vi=viOry(:,i);
        sub=vi'*Mi-bi;
        mse=mse+norm(sub)^2;
    end
end
end

