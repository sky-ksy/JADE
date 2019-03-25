function  [mse]=testMSE( X,AoA,flag,viOry )

X;   %待测试矩阵
mse=0;
n=size(AoA,2);
if(flag==1)  %传入最终用户位置y
    for i=1:n
        Xii=transCol(X,i,n);
        [thetai,Ri]=generateR(AoA,i,n);
        Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
        bi=2*sin(thetai);
        y=viOry;
        vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;  %y是最终的平均值
        sub=vi'*Mi-bi;
        mse=mse+norm(sub)^2;
    end
else   %计算迭代过程中的均方差的变化，此时y还没有计算出来
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

