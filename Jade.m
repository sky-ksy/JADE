
function [X,y,jade_param]= Jade( ARSS,virS,jade_param)
%shaixuan(AoA,ARSS);%筛选到达角  
t=jade_param.t;
AoA=jade_param.MatAoA(t,:);  %t时刻的到达角(一行)
n=size(AoA,2);  %t时刻可见的锚节点数目
left=jade_param.left;
right=jade_param.right;
down=jade_param.down;
up=jade_param.up;
xRange=jade_param.xRange;
yRange=jade_param.yRange;
gridsize=jade_param.gridsize;
s=jade_param.s;  %记录前t个时刻所有不同x3,x4坐标取值时f(w,z,b)的累加值
sn=jade_param.sn;  %不同x5~xn坐标关于所有时刻的f(w,z,b)的累加值
% Vt=jade_param.Vt;
% Xt=jade_param.Xt;
MaxIT=jade_param.MaxIT;

X=zeros(2,n);%t时刻可见的锚点坐标矩阵
X(:,1)=virS(1).pos';%初始化t时刻的任意两个锚节点位置
X(:,2)=virS(2).pos';
% X=[0,-6,0,6,0;
%     0,0,5,0,-3];

% disptitle('initial Xi');
% for i=3:n
%     limX(i).left=jade_param.left;
%     limX(i).right=jade_param.right;
%     limX(i).down=jade_param.down;
%     limX(i).up=jade_param.up;
% end
% pos1
% limX(3).right=1.5; limX(3).down=0.5;
% limX(4).left=1.5;  limX(4).up=0.5;
% limX(5).right=1.5; limX(5).up=0.5;
% pos2
% limX(3).right=2.5; limX(3).down=-1;
% limX(4).left=2.5;  limX(4).down=-1;
% limX(5).right=2.5; limX(5).up=-1;
%pos3
% limX(3).left=-2; limX(3).down=2;
% limX(4).left=-2; limX(4).up=2;
% limX(5).left=-2; limX(5).up=2;

%利用网格法先同时估计t时刻第三、第四个锚点位置
smax=-inf;
i=0;
% tic
for y_3=yRange  %down:gridsize:up
    for y_4=yRange  %down:gridsize:up
        for x_3=xRange  %left:gridsize:right
            for x_4=xRange  %left:gridsize:right
                i=i+1;
                X(:,3)=[x_3,y_3]';  %X3的估计坐标
                X(:,4)=[x_4,y_4]';  %X4的估计坐标
                s(i)=s(i)+sumOutside( jade_param,X,4,x_4,y_4 );  %外部求和，因为记录了之前所有时刻之和，快一些
                if(s(i)>smax)
                    smax=s(i);
                    x3=x_3;y3=y_3;
                    x4=x_4;y4=y_4;  %记录当前使目标方程值最大的坐标值组合
                end
            end
        end
    end
end
% toc
% fprintf('initial over');
jade_param.s=s;
X(:,3)=[x3,y3]';
X(:,4)=[x4,y4]';

%  fprintf('  ix\txi\tyi\tsn\tx0\ty0\tt=%d\n',t); 
 for ix=5:n %估计t时刻的第3到第n个锚节点的位置
    snmax=-inf; %用来估计Xi位置的目标方程的值，需要求使目标方程最大的(x0,y0)作为Xi的坐标
    tempMax=[];
    i=0; j=0; 
    xi=left;yi=down;
    for x0=xRange  %left:gridsize:right
        j=j+1;k=0;
        for y0=yRange  %down:gridsize:up
            X(:,ix)=[x0,y0]'; %考虑Xi坐标为[x0，y0]时目标函数的取值
            k=k+1; 
            %sn(j,k,ix)=sn(j,k,ix)+sumOfInitialX( jade_param,X,ix,x0,y0 );
            sn(j,k,ix)=sumOfInitialX( jade_param,X,ix,x0,y0 );  %内部求和
%             if(x0==virS(ix).pos(1)&&y0==virS(ix).pos(2))
%                realZ= sn(j,k,ix);
%             end
            if(sn(j,k,ix)==snmax)  %待处理
                fprintf('等%d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,sn(j,k,ix),x0,y0);
                i=i+1; 
                tempMax(i).max=snmax;
                tempMax(i).x=x0;
                tempMax(i).y=y0;
            elseif(sn(j,k,ix)>snmax)
                snmax=sn(j,k,ix); xi=x0;yi=y0;  %记录当前使目标方程值最大的坐标值组合
            else 
                %fprintf('  %d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,sn(j,k,ix),x0,y0); %查看每次坐标选择变化情况
            end                     
        end
    end
    for ii=1:length(tempMax)  %找出重复的最大值
       if(tempMax(ii).max==snmax) 
           fprintf(2,'等于最大值%d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,...
        snmax,tempMax(ii).x,tempMax(ii).y);
       end
    end
    X(:,ix)=[xi,yi]';%确定出一个初始Xi的坐标
%     %绘制不同坐标的f(w,z,b)
%     f=figure(20+ix); 
%     pause(1);
%     clf(f);
%     [x,y]=meshgrid(left:gridsize:right,down:gridsize:up);
%     plot3(x,y,sn(:,:,ix)); %t时刻不同坐标估计出的f(w,z,b)
%     hold on;
%     h1=plot3(xi,yi,snmax,'r.','markersize',15); %最大值点
%     hold on;
%     %h2=plot3(virS(ix).pos(1),virS(ix).pos(2),realZ,'k.','markersize',15); %真实点
%     title(['t=',num2str(t)]);
%     text(xi+0.2,yi,snmax+0.5,num2str(snmax));  %标记最大值点
%     %text(virS(ix).pos(1)+0.2,virS(ix).pos(2),realZ+1,num2str(realZ)); %标记真实点
%     %legend([h1,h2],'初始估计点','真实点','location','best');
%     grid on;
%     xlabel('x'); ylabel('y'),zlabel('f(w,z,b)');  
    %saveas(20+ix,['D:\Users\ksy\Desktop\实验图片\indepM\基于x3,x4估计x5 t=',num2str(t),'.jpg'])
end  %整个循环过程中求Xi的坐标用到的就是前i个坐标的信息
%jade_param.sn=sn;
X;   %输出初始估计的锚点坐标
jade_param.initialX=X;    
D=0;
for i=3:n
D=D+norm(X(:,i)-virS(i).pos');
end
% fprintf('初始距离差%f ',D);


% disptitle('optimized Xi');
vi=zeros(2,n);
tempX=zeros(2,n);
mse=zeros(1,MaxIT);
ax=zeros(n,MaxIT);  %n个锚点MaxIT次迭代得到的x坐标
ay=zeros(n,MaxIT);  %n个锚点MaxIT次迭代得到的y坐标
d=zeros(n,MaxIT);   %n个锚点MaxIT次迭代与真实位置的距离差
for k=1:MaxIT  %校正锚节点坐标
    for i=3:n
        %计算Vi
        Xii=transCol(X,i,n);%Xii=（Xj-Xi）  2*(n-1)的矩阵
        [thetai,Ri]=generateR(AoA,i,n);%获取到达角度差矩阵theta：1*(n-1)，向量旋转矩阵Ri：2行*2列*(n-1)页
        Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2)); %Ri的每页与Xi的每列分别做矩阵乘积，得到Mi：2*(n-1)
        bi=2*sin(thetai);
        M=Mi*Mi';
        %if(~isIndep(M,2,jade_param.equ))  %看Mi*Mi'是否可逆
        if(rank(M)~=2)
            fprintf(2,'M不可逆k=%d,i=%d,M=\n',k,i);
            M;
            vi(:,i)=(Mi*Mi')\(Mi*bi');
        else
            vi(:,i)=(Mi*Mi')\(Mi*bi');   %2*1矩阵 公式（9） 左除与求逆结果差值低于1e-10
        end
        %计算Xi
        Qi=squeeze(sum(vi(:,i).*Ri, 1)); %2*(n-1)
        %Xii+X(:,i)
        Bi=sum(Qi.*(Xii+X(:,i)),1)-bi;   %1*(n-1)
        Q=Qi*Qi';
        %if(~isIndep(Q,2,jade_param.equ))  %看Qi*Qi'是否可逆
        if(rank(Q)~=2)
            fprintf(2,'Q不可逆k=%d,i=%d,Q=\n',k,i);
            Q;
        end
        tempX(:,i)=(Qi*Qi')\(Qi*Bi');   %2*1矩阵   公式（13）
        %作图用
        ax(i,k)=tempX(1,i);   %记录第i个锚点第k次迭代的横坐标
        ay(i,k)=tempX(2,i);   %记录第i个锚点第k次迭代的纵坐标
        detaD=[ax(i,k)-virS(i).pos(1),ay(i,k)-virS(i).pos(2)];  %真实位置到估计位置的向量
        d(i,k)=norm(detaD);     %真实位置到估计位置的距离
    end
    X(:,3:n)=tempX(:,3:n);
    mse(1,k)=testMSE(X,AoA,0,vi);
end
X;
jade_param.optiX=X;

% Vt=Vt+vi;  %记录t时刻的所有vi、xi
% Xt=Xt+X; 
% X=Xt./t;  %t时刻之前的所有vi、xi取均值作为t时刻的xi、vi
% vi=Vt./t;
% jade_param.Vt=Vt;
% jade_param.Xt=Xt;
D=0;  %所有估计锚点与实际位置的距离差之和
for i=3:n
D=D+norm(X(:,i)-virS(i).pos');
end
% fprintf('最终距离差%f ',D);

%分别绘制节点i每次迭代的横纵坐标相对真实位置的折线图
%disptitle('real position');
for i=3:n
    %virS(i).pos   %第i个锚点真实位置
%     f=figure(i);
%     clf(f);
    %     plot(1:MaxIT,zeros(1,MaxIT)+virSrc(i).pos(1),'r-');%红色真实横坐标
    %     hold on;
    %     plot(1:MaxIT,zeros(1,MaxIT)+virSrc(i).pos(2),'g-');%绿色真实纵坐标
    %     hold on;
%          plot(1:MaxIT,ax(i,:),'r.-','MarkerSize',8);  %迭代横坐标
    %     hold on;
    %     plot(1:MaxIT,ay(i,:),'g.-','MarkerSize',8);  %迭代纵坐标
    %     hold on;
    %plot(1:MaxIT,d(i,:),'bo-','MarkerSize',4);  %距离差
    %title(['节点',num2str(i),' gridsize=',num2str(gridsize)]);
    %xlabel('迭代次数');
    %     legd=legend(['真实横坐标:',num2str(virSrc(i).pos(1))],...
    %         ['真实纵坐标:',num2str(virSrc(i).pos(2))],'迭代横坐标','迭代纵坐标',...
    %         '距离差','location','best');
    %     set(legd,'Box','off');
%         saveas(gcf,['节点',num2str(i),'gridsize=',num2str(gridsize),...
%             '.jpg'])
end
%绘制各次迭代的均方差
% f=figure(11);
% clf(f);
% plot(1:MaxIT,mse,'r.-','MarkerSize',8);
% xlabel('迭代次数');
% ylabel('均方差');
%计算用户位置y
% disptitle('user position');
y=[0,0]';
for i=3:n
    y=y+X(:,i)+2.*vi(:,i)./norm(vi(:,i))^2;
end
y=y./(n-2);  %求均值

end

