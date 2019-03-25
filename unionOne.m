function [ X ] = unionOne( jade_param,virS,userPos )
%利用正弦定理求锚点位置

t=jade_param.t;
r=jade_param.r;   %TX与RX距离
AoA=jade_param.MatAoA(t,:);
AoD=jade_param.AoD;
%ToA=jade_param.ToA;  %与AOA对应的到达时间差 单位ns
n=size(AoA,2);
left=jade_param.left;
right=jade_param.right;
down=jade_param.down;
up=jade_param.up;
gridsize=jade_param.gridsize;

X=zeros(2,n);
X(:,1)=jade_param.srcPos';  %发射器坐标

x1=X(:,1);
y=userPos(:,t);
v1=2*(y-x1)/norm(y-x1)^2;
i=1;
[thetai,Ri]=generateR(AoA,i,n);  %AoA(1)对应的必须为TX的到达角
bi=2*sin(thetai);

%将结构体中的锚点坐标放入数组
realArchX=zeros(1,length(virS));
realArchY=zeros(1,length(virS));
for i=1:length(virS)
    realArchX(i)=virS(i).pos(1);
    realArchY(i)=virS(i).pos(2);
end

fprintf('t=%d\n',t);
for ix=2:n
     abs_theta=abs(thetai(ix-1));
    if(abs_theta<1e-13||abs(abs_theta-pi)<1e-13)
        fprintf('TX-RX与墙壁垂直\n');
       continue; 
    end
    falseX=[];
    k=0;
    for x0=left:gridsize:right  %寻找满足公式 5 的其他锚点坐标
        for y0=down:gridsize:up
            xj=[x0,y0]';
            sub=v1'*Ri(:,:,ix-1)*(xj-x1)-bi(ix-1);
            if(abs(sub)<1e-2)   %网格搜索出距离偏差在一定范围的点
                fprintf(' ix=%d, x0=%f, y0=%f\n',ix,x0,y0);
                k=k+1;
                falseX(:,k)=xj; %记录所有满足公式 5 的锚点坐标
            end
        end
    end
    
%     f=figure(ix); clf(f);   
%     plotReflector(jade_param.env_param, jade_param.sys_param);%绘制房间
%     hold on;
%     pf=plot(falseX(1,:),falseX(2,:),'bo','Markersize',6); %绘制符合条件的锚点
%     p0=plot(realArchX(ix),realArchY(ix),'m.','Markersize',12);%绘制真实锚点
%     p1=plot(userPos(1,t),userPos(2,t),'r.','MarkerSize',12);  %绘制RX
%     p2=plot(jade_param.srcPos(1),jade_param.srcPos(2),'k.','Markersize',12);%TX
%     axis equal
%     xlim([-12,12]);
%     ylim([-8,8]);
%     legend([pf,p0,p1,p2],'假锚点','真锚点','RX','TX');
%     title(['t=',num2str(t),'锚点',num2str(ix)]);
     
    %计算几何图中的到达角度差
   if(abs_theta>pi)
        abs_theta=2*pi-abs_theta;
    end
    %计算几何图中的反射角
    refAngle=abs(AoD(ix)-AoA(ix));
    if(refAngle>pi)
       refAngle=2*pi-refAngle; 
    end
%     abs_AoD=abs(AoD(ix));
%     if(abs_AoD>pi/2)
%        refAngle=pi-2*(pi-abs_AoD); 
%     else
%         refAngle=pi-2*abs_AoD; %abs_AoD=pi/2时为0
%     end
%     if(refAngle+abs_theta>=pi)
%        refAngle=pi-refAngle; 
%     end
    %计算第三个角
    thirdAngle=pi-abs_theta-refAngle;
    %利用正弦定理求锚点到用户距离
    Tx_ref=r/sin(refAngle)*sin(abs_theta);
    Rx_ref=r/sin(refAngle)*sin(thirdAngle);
    Dis=Tx_ref+Rx_ref;  %角度无误差时的真实距离
    
    %利用到达距离和到达角计算出锚点坐标
    xi=y(1)+Dis*cos(AoA(ix));
    yi=y(2)+Dis*sin(AoA(ix));
    X(:,ix)=[xi,yi];
    
%     user_X=falseX-userPos(:,t);
%     for i=1:size(user_X,2)
%         disOfFalseX(i)=norm(user_X(:,i));
%         AoAofFalseX(i)=angle(complex(user_X(1,i),user_X(2,i)));
%     end
%     fitDis=find(abs(disOfFalseX-Dis)<1e-1); %筛选距离接近的点
%     fitAoA=find(abs(AoAofFalseX-AoA(ix))<1e-1); %筛选AOA正确的点
%     fitX=intersect(fitDis,fitAoA);
    
    %X(:,ix)=falseX(:,fitX);
  
end

