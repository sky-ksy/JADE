function [ X ] = unionOne( jade_param,virS,userPos )
%�������Ҷ�����ê��λ��

t=jade_param.t;
r=jade_param.r;   %TX��RX����
AoA=jade_param.MatAoA(t,:);
AoD=jade_param.AoD;
%ToA=jade_param.ToA;  %��AOA��Ӧ�ĵ���ʱ��� ��λns
n=size(AoA,2);
left=jade_param.left;
right=jade_param.right;
down=jade_param.down;
up=jade_param.up;
gridsize=jade_param.gridsize;

X=zeros(2,n);
X(:,1)=jade_param.srcPos';  %����������

x1=X(:,1);
y=userPos(:,t);
v1=2*(y-x1)/norm(y-x1)^2;
i=1;
[thetai,Ri]=generateR(AoA,i,n);  %AoA(1)��Ӧ�ı���ΪTX�ĵ����
bi=2*sin(thetai);

%���ṹ���е�ê�������������
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
        fprintf('TX-RX��ǽ�ڴ�ֱ\n');
       continue; 
    end
    falseX=[];
    k=0;
    for x0=left:gridsize:right  %Ѱ�����㹫ʽ 5 ������ê������
        for y0=down:gridsize:up
            xj=[x0,y0]';
            sub=v1'*Ri(:,:,ix-1)*(xj-x1)-bi(ix-1);
            if(abs(sub)<1e-2)   %��������������ƫ����һ����Χ�ĵ�
                fprintf(' ix=%d, x0=%f, y0=%f\n',ix,x0,y0);
                k=k+1;
                falseX(:,k)=xj; %��¼�������㹫ʽ 5 ��ê������
            end
        end
    end
    
%     f=figure(ix); clf(f);   
%     plotReflector(jade_param.env_param, jade_param.sys_param);%���Ʒ���
%     hold on;
%     pf=plot(falseX(1,:),falseX(2,:),'bo','Markersize',6); %���Ʒ���������ê��
%     p0=plot(realArchX(ix),realArchY(ix),'m.','Markersize',12);%������ʵê��
%     p1=plot(userPos(1,t),userPos(2,t),'r.','MarkerSize',12);  %����RX
%     p2=plot(jade_param.srcPos(1),jade_param.srcPos(2),'k.','Markersize',12);%TX
%     axis equal
%     xlim([-12,12]);
%     ylim([-8,8]);
%     legend([pf,p0,p1,p2],'��ê��','��ê��','RX','TX');
%     title(['t=',num2str(t),'ê��',num2str(ix)]);
     
    %���㼸��ͼ�еĵ���ǶȲ�
   if(abs_theta>pi)
        abs_theta=2*pi-abs_theta;
    end
    %���㼸��ͼ�еķ����
    refAngle=abs(AoD(ix)-AoA(ix));
    if(refAngle>pi)
       refAngle=2*pi-refAngle; 
    end
%     abs_AoD=abs(AoD(ix));
%     if(abs_AoD>pi/2)
%        refAngle=pi-2*(pi-abs_AoD); 
%     else
%         refAngle=pi-2*abs_AoD; %abs_AoD=pi/2ʱΪ0
%     end
%     if(refAngle+abs_theta>=pi)
%        refAngle=pi-refAngle; 
%     end
    %�����������
    thirdAngle=pi-abs_theta-refAngle;
    %�������Ҷ�����ê�㵽�û�����
    Tx_ref=r/sin(refAngle)*sin(abs_theta);
    Rx_ref=r/sin(refAngle)*sin(thirdAngle);
    Dis=Tx_ref+Rx_ref;  %�Ƕ������ʱ����ʵ����
    
    %���õ������͵���Ǽ����ê������
    xi=y(1)+Dis*cos(AoA(ix));
    yi=y(2)+Dis*sin(AoA(ix));
    X(:,ix)=[xi,yi];
    
%     user_X=falseX-userPos(:,t);
%     for i=1:size(user_X,2)
%         disOfFalseX(i)=norm(user_X(:,i));
%         AoAofFalseX(i)=angle(complex(user_X(1,i),user_X(2,i)));
%     end
%     fitDis=find(abs(disOfFalseX-Dis)<1e-1); %ɸѡ����ӽ��ĵ�
%     fitAoA=find(abs(AoAofFalseX-AoA(ix))<1e-1); %ɸѡAOA��ȷ�ĵ�
%     fitX=intersect(fitDis,fitAoA);
    
    %X(:,ix)=falseX(:,fitX);
  
end

