function [ s ] = sumOfInitialX( jade_param,X,ix,x0,y0 )
s=0;  %估计Xi位置的目标方程的值
t=jade_param.t;
for i=1:t
    %for im=[1,2,ix]  %不累加
    for im=1:ix %选取第1到第ix个节点中的一个作为“中心节点”（中心节点为论文中的Xi，其余的是Xj）
        Xim=transCol(X,im,ix);%Xim=（Xj-Xi）  2*(ix-1)的矩阵
        %[theta,Rim]=generate_R(jade_param.AoA,im,ix);%获取到达角度差矩阵theta：1*(ix-1)，向量旋转矩阵Rim：2行*2列*(ix-1)页
        [theta,Rim]=generateR(jade_param.MatAoA(i,:),im,ix); %计算论文中所有（i,t）对
        Mim=squeeze(sum(Rim .* shiftdim(Xim, -1), 2)); %Rim的每页与Xim的每列分别做矩阵乘积，得到Mim：2*(ix-1)
        wim=Mim(1,:)'; %Mim的第1行
        zim=Mim(2,:)'; %Mim的第2行
        if(isIndep(Mim,jade_param.equ)) %Mim的两行线性无关的话
            %if(rank(Mim)==2)   %计算s会出现NaN的结果
            s=s+indep(wim,zim,theta); %计算估计Xi位置的目标方程的值
        else %Mim的两行线性相关的话
            %fprintf('ix=%d,x0=%f,y0=%f\n',ix,x0,y0);
            s=s+dep(wim,zim,theta);
            Mim;  %两行线性相关的Mim
        end
        if isnan(s)
            fprintf(2,'NaN t=%d,ix=%f,x0=%f,y0=%f',t,ix,x0,y0);
            Mim
            2*sin(theta)            
        end
    end
end

