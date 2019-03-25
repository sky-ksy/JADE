function data=JadeT(uGroupi,allPos,jade_param,data)
% clc; clear all;
% warning off;
% userPos=[2.5,1.5,-2,-0.5;
%     -1,0.5,2,-1];  %�趨�������û�λ��
% userPos=[-2.6 -1.4 0.3 1.7 2.4  2.4 2.4 2.4 2.4  1.7 0.3 -1.4 -2.6  -2.6 -2.6 -2.6;
%     2.1 2.1 2.1 2.1 2.1  1.3 0.7 -0.2 -1.3  -1.3 -1.3 -1.3 -1.3  -0.2 0.7 1.3 ];
% jade_param.srcPos=[0,0];  %Tx����
jade_param.r=0.3;  %Tx��Rx����
srcPos=jade_param.srcPos;
gid=jade_param.gid;
% r=jade_param.r;
% count=0;
% for i=0:pi/2:3/2*pi  %��Tx����Ϊ0.3��һЩRx����
%     count=count+1;
%     userPos(1,count)=srcPos(1)+r*cos(i);
%     userPos(2,count)=srcPos(2)+r*sin(i);
% end
% for i=0:pi/8:2*pi
%     if(mod(i,pi/2)~=0)
%         count=count+1;
%         userPos(1,count)=srcPos(1)+r*cos(i);
%         userPos(2,count)=srcPos(2)+r*sin(i);
%     end
% end
uId=uGroupi.uId;
userPos=allPos(uId,:);
T=size(userPos,1);

% jade_param.left=-9; jade_param.right=9;   %����������Χ
% jade_param.down=-5.5; jade_param.up=6.5;
jade_param=getGridRange(srcPos,jade_param);  %�趨����������Χ
lenX=length(jade_param.xRange);
lenY=length(jade_param.yRange);
jade_param.gridsize=2;  %������������
% lenX=floor((jade_param.right-jade_param.left)/jade_param.gridsize)+1;
% lenY=floor((jade_param.up-jade_param.down)/jade_param.gridsize)+1;
jade_param.equ=1e-3;  %��ȵĲ�ֵ����
jade_param.MaxIT=50;  %��������

%�����û�λ�ò�ͬ�����ê��Ĺ������
% jade_param=initParam(srcPos,jade_param);

for t=1:T
    if mod(t,10)==0
        fprintf('%d/%d\n',t,T);
    end
%     [AoA,virS,RSS]=getAoARSS(userPos(t,:),jade_param);
    AoA=uGroupi.matAoA(t,:);
    virS=uGroupi.matVirS;
    RSS=uGroupi.matRSS(t,:);
    
    %����RSS��AoA����� 
    AoA=genErrorAoA(AoA,RSS);  
    
    n=size(AoA,2);
    if n<4  %ê�����С��4ʱ�޷�����
        fprintf('virS<4,�޷�����\n');
        continue;
    end
    if(t==1)
        jade_param.s=zeros(1,lenX^2*lenY^2);
        jade_param.sn=zeros(lenX,lenY,n);  %����tʱ��֮ǰ��f(w,z,b)
        jade_param.MatAoA=zeros(T,n);
        jade_param.MatRSS=zeros(T,n);
        jade_param.MatVirS=cell(T,1);
        jade_param.Vt=zeros(2,n);
        jade_param.Xt=zeros(2,n);
    end
    jade_param.t=t;
    try
        jade_param.MatAoA(t,:)=AoA;
        jade_param.MatRSS(t,:)=RSS;
    catch
        fprintf(2,'wrong AoA number\n');
%         pause;
    end
    posM=[];
    for ii=1:n
        posM(ii,:)=virS(ii).pos;
    end
    jade_param.MatVirS{t}=posM;    
    
    %     [X]=new( jade_param,virS,userPos )
    %     [X]=unionOne( jade_param,virS,userPos )
    [X,y,jade_param]=Jade(RSS,virS,jade_param);
    %     m=testMSE(X,AoA,1,y);  %���������
    %     fprintf('final MSE:%e',m);
    
    tRefPoint{t}=getRefPoint(posM,userPos(t,:));  %��ʵ�����λ��
    refPoint{t}=getRefPoint(X',userPos(t,:));  %���Ʒ����λ��
    errorDis(t)=getErrorDis(tRefPoint{t},refPoint{t}); %��������
    
%     if t==1
        %ʵʱ���ƹ���λ��ͼ
        f=figure(101); clf(f);
        plotReflector(jade_param.env_param, jade_param.sys_param);
        for i=1:length(virS)
            realArchX(i)=virS(i).pos(1);
            realArchY(i)=virS(i).pos(2);
        end
        hold on;
        p0=plot(realArchX,realArchY,'m.','Markersize',15);  %��ʵê��λ��
        hold on;
        p1=plot(userPos(t,1),userPos(t,2),'r.','MarkerSize',13); %��ʵ�û�λ��
        
        %p2=plot(jade_param.initialX(1,1:n),jade_param.initialX(2,1:n),'g.-','MarkerSize',13);
        %p2=plot(jade_param.optiX(1,1:n),jade_param.optiX(2,1:n),'g.-','MarkerSize',13);
        p2=plot(X(1,1:n),X(2,1:n),'o-','Color',[0 0.3 1],'MarkerSize',6,'LineWidth',1.3); %����ê��λ��
        p3=plot(y(1),y(2),'^','Color',[0 0.3 1],'MarkerSize',6,'LineWidth',1.3);  %�����û�λ��
        xlim([-8,16]);
        ylim([-10,20]); 
        legd=legend([p0,p1,p2,p3],'��ʵê��','��ʵ�û�','����ê��','�����û�','location','best');
        title(['t=',num2str(t)]);
        pause(1);
%     end    
    %     saveas(101,['D:\Users\ksy\Desktop\ʵ��ͼƬ\indepM\ͬʱ����x3,x4 �Ż�t=',num2str(t),'.jpg']);
    
    %     %ʵʱ���Ʒ����
    %     f=figure(102);
    %     if t==1
    %         clf(f);
    %         plotReflector(jade_param.env_param, jade_param.sys_param);
    %     else
    %         hold on;
    %         p4=plot(refPoint{t}(:,1),refPoint{t}(:,2),'k.','MarkerSize',12); %���Ʒ����λ��
    %         title(['t=',num2str(t)]);
    %     end
end
data.tRefPoint=[data.tRefPoint,tRefPoint];
data.refPoint=[data.refPoint,refPoint];
data.errorDis{gid}=errorDis;

plotRefPoint(1+(gid-1)*4,tRefPoint,jade_param);
plotRefPoint(2+(gid-1)*4,refPoint,jade_param);
plotAPUser(3+(gid-1)*4,jade_param,userPos);
f=figure(4+(gid-1)*4); clf(f);  %����������û��ƶ�λ�����Ĺ�ϵ
plot(errorDis(3:end),'.-','MarkerSize',12,'LineWidth',1.3);
xlabel('�û��ƶ�λ����');
ylabel('�����������');

% save('./data/4APTemp/jade_param.mat','jade_param');
% save('./data/4APTemp/tRefPoint.mat','tRefPoint');
% save('./data/4APTemp/refPoint.mat','refPoint');
% save('./data/4APTemp/errorDis.mat','errorDis');

% fprintf('userPos error:');
% d=norm(userPos(1,t)-y(1),userPos(2,t)-y(2))  %�û��������

% for i=1:n
%     tAoA(i) = angle(complex(X(1,i)-y(1),X(2,i)-y(2))); %Դ������-Ŀ������� ת��Ϊ �����
% end
% [adoa,~]=generateR(tAoA,3,n)
% 2*sin(adoa)
