
function [X,y,jade_param]= Jade( ARSS,virS,jade_param)
%shaixuan(AoA,ARSS);%ɸѡ�����  
t=jade_param.t;
AoA=jade_param.MatAoA(t,:);  %tʱ�̵ĵ����(һ��)
n=size(AoA,2);  %tʱ�̿ɼ���ê�ڵ���Ŀ
left=jade_param.left;
right=jade_param.right;
down=jade_param.down;
up=jade_param.up;
xRange=jade_param.xRange;
yRange=jade_param.yRange;
gridsize=jade_param.gridsize;
s=jade_param.s;  %��¼ǰt��ʱ�����в�ͬx3,x4����ȡֵʱf(w,z,b)���ۼ�ֵ
sn=jade_param.sn;  %��ͬx5~xn�����������ʱ�̵�f(w,z,b)���ۼ�ֵ
% Vt=jade_param.Vt;
% Xt=jade_param.Xt;
MaxIT=jade_param.MaxIT;

X=zeros(2,n);%tʱ�̿ɼ���ê���������
X(:,1)=virS(1).pos';%��ʼ��tʱ�̵���������ê�ڵ�λ��
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

%����������ͬʱ����tʱ�̵��������ĸ�ê��λ��
smax=-inf;
i=0;
% tic
for y_3=yRange  %down:gridsize:up
    for y_4=yRange  %down:gridsize:up
        for x_3=xRange  %left:gridsize:right
            for x_4=xRange  %left:gridsize:right
                i=i+1;
                X(:,3)=[x_3,y_3]';  %X3�Ĺ�������
                X(:,4)=[x_4,y_4]';  %X4�Ĺ�������
                s(i)=s(i)+sumOutside( jade_param,X,4,x_4,y_4 );  %�ⲿ��ͣ���Ϊ��¼��֮ǰ����ʱ��֮�ͣ���һЩ
                if(s(i)>smax)
                    smax=s(i);
                    x3=x_3;y3=y_3;
                    x4=x_4;y4=y_4;  %��¼��ǰʹĿ�귽��ֵ��������ֵ���
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
 for ix=5:n %����tʱ�̵ĵ�3����n��ê�ڵ��λ��
    snmax=-inf; %��������Xiλ�õ�Ŀ�귽�̵�ֵ����Ҫ��ʹĿ�귽������(x0,y0)��ΪXi������
    tempMax=[];
    i=0; j=0; 
    xi=left;yi=down;
    for x0=xRange  %left:gridsize:right
        j=j+1;k=0;
        for y0=yRange  %down:gridsize:up
            X(:,ix)=[x0,y0]'; %����Xi����Ϊ[x0��y0]ʱĿ�꺯����ȡֵ
            k=k+1; 
            %sn(j,k,ix)=sn(j,k,ix)+sumOfInitialX( jade_param,X,ix,x0,y0 );
            sn(j,k,ix)=sumOfInitialX( jade_param,X,ix,x0,y0 );  %�ڲ����
%             if(x0==virS(ix).pos(1)&&y0==virS(ix).pos(2))
%                realZ= sn(j,k,ix);
%             end
            if(sn(j,k,ix)==snmax)  %������
                fprintf('��%d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,sn(j,k,ix),x0,y0);
                i=i+1; 
                tempMax(i).max=snmax;
                tempMax(i).x=x0;
                tempMax(i).y=y0;
            elseif(sn(j,k,ix)>snmax)
                snmax=sn(j,k,ix); xi=x0;yi=y0;  %��¼��ǰʹĿ�귽��ֵ��������ֵ���
            else 
                %fprintf('  %d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,sn(j,k,ix),x0,y0); %�鿴ÿ������ѡ��仯���
            end                     
        end
    end
    for ii=1:length(tempMax)  %�ҳ��ظ������ֵ
       if(tempMax(ii).max==snmax) 
           fprintf(2,'�������ֵ%d\t%f\t%f\t%.15f\t%f\t%f\n',ix,xi,yi,...
        snmax,tempMax(ii).x,tempMax(ii).y);
       end
    end
    X(:,ix)=[xi,yi]';%ȷ����һ����ʼXi������
%     %���Ʋ�ͬ�����f(w,z,b)
%     f=figure(20+ix); 
%     pause(1);
%     clf(f);
%     [x,y]=meshgrid(left:gridsize:right,down:gridsize:up);
%     plot3(x,y,sn(:,:,ix)); %tʱ�̲�ͬ������Ƴ���f(w,z,b)
%     hold on;
%     h1=plot3(xi,yi,snmax,'r.','markersize',15); %���ֵ��
%     hold on;
%     %h2=plot3(virS(ix).pos(1),virS(ix).pos(2),realZ,'k.','markersize',15); %��ʵ��
%     title(['t=',num2str(t)]);
%     text(xi+0.2,yi,snmax+0.5,num2str(snmax));  %������ֵ��
%     %text(virS(ix).pos(1)+0.2,virS(ix).pos(2),realZ+1,num2str(realZ)); %�����ʵ��
%     %legend([h1,h2],'��ʼ���Ƶ�','��ʵ��','location','best');
%     grid on;
%     xlabel('x'); ylabel('y'),zlabel('f(w,z,b)');  
    %saveas(20+ix,['D:\Users\ksy\Desktop\ʵ��ͼƬ\indepM\����x3,x4����x5 t=',num2str(t),'.jpg'])
end  %����ѭ����������Xi�������õ��ľ���ǰi���������Ϣ
%jade_param.sn=sn;
X;   %�����ʼ���Ƶ�ê������
jade_param.initialX=X;    
D=0;
for i=3:n
D=D+norm(X(:,i)-virS(i).pos');
end
% fprintf('��ʼ�����%f ',D);


% disptitle('optimized Xi');
vi=zeros(2,n);
tempX=zeros(2,n);
mse=zeros(1,MaxIT);
ax=zeros(n,MaxIT);  %n��ê��MaxIT�ε����õ���x����
ay=zeros(n,MaxIT);  %n��ê��MaxIT�ε����õ���y����
d=zeros(n,MaxIT);   %n��ê��MaxIT�ε�������ʵλ�õľ����
for k=1:MaxIT  %У��ê�ڵ�����
    for i=3:n
        %����Vi
        Xii=transCol(X,i,n);%Xii=��Xj-Xi��  2*(n-1)�ľ���
        [thetai,Ri]=generateR(AoA,i,n);%��ȡ����ǶȲ����theta��1*(n-1)��������ת����Ri��2��*2��*(n-1)ҳ
        Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2)); %Ri��ÿҳ��Xi��ÿ�зֱ�������˻����õ�Mi��2*(n-1)
        bi=2*sin(thetai);
        M=Mi*Mi';
        %if(~isIndep(M,2,jade_param.equ))  %��Mi*Mi'�Ƿ����
        if(rank(M)~=2)
            fprintf(2,'M������k=%d,i=%d,M=\n',k,i);
            M;
            vi(:,i)=(Mi*Mi')\(Mi*bi');
        else
            vi(:,i)=(Mi*Mi')\(Mi*bi');   %2*1���� ��ʽ��9�� �������������ֵ����1e-10
        end
        %����Xi
        Qi=squeeze(sum(vi(:,i).*Ri, 1)); %2*(n-1)
        %Xii+X(:,i)
        Bi=sum(Qi.*(Xii+X(:,i)),1)-bi;   %1*(n-1)
        Q=Qi*Qi';
        %if(~isIndep(Q,2,jade_param.equ))  %��Qi*Qi'�Ƿ����
        if(rank(Q)~=2)
            fprintf(2,'Q������k=%d,i=%d,Q=\n',k,i);
            Q;
        end
        tempX(:,i)=(Qi*Qi')\(Qi*Bi');   %2*1����   ��ʽ��13��
        %��ͼ��
        ax(i,k)=tempX(1,i);   %��¼��i��ê���k�ε����ĺ�����
        ay(i,k)=tempX(2,i);   %��¼��i��ê���k�ε�����������
        detaD=[ax(i,k)-virS(i).pos(1),ay(i,k)-virS(i).pos(2)];  %��ʵλ�õ�����λ�õ�����
        d(i,k)=norm(detaD);     %��ʵλ�õ�����λ�õľ���
    end
    X(:,3:n)=tempX(:,3:n);
    mse(1,k)=testMSE(X,AoA,0,vi);
end
X;
jade_param.optiX=X;

% Vt=Vt+vi;  %��¼tʱ�̵�����vi��xi
% Xt=Xt+X; 
% X=Xt./t;  %tʱ��֮ǰ������vi��xiȡ��ֵ��Ϊtʱ�̵�xi��vi
% vi=Vt./t;
% jade_param.Vt=Vt;
% jade_param.Xt=Xt;
D=0;  %���й���ê����ʵ��λ�õľ����֮��
for i=3:n
D=D+norm(X(:,i)-virS(i).pos');
end
% fprintf('���վ����%f ',D);

%�ֱ���ƽڵ�iÿ�ε����ĺ������������ʵλ�õ�����ͼ
%disptitle('real position');
for i=3:n
    %virS(i).pos   %��i��ê����ʵλ��
%     f=figure(i);
%     clf(f);
    %     plot(1:MaxIT,zeros(1,MaxIT)+virSrc(i).pos(1),'r-');%��ɫ��ʵ������
    %     hold on;
    %     plot(1:MaxIT,zeros(1,MaxIT)+virSrc(i).pos(2),'g-');%��ɫ��ʵ������
    %     hold on;
%          plot(1:MaxIT,ax(i,:),'r.-','MarkerSize',8);  %����������
    %     hold on;
    %     plot(1:MaxIT,ay(i,:),'g.-','MarkerSize',8);  %����������
    %     hold on;
    %plot(1:MaxIT,d(i,:),'bo-','MarkerSize',4);  %�����
    %title(['�ڵ�',num2str(i),' gridsize=',num2str(gridsize)]);
    %xlabel('��������');
    %     legd=legend(['��ʵ������:',num2str(virSrc(i).pos(1))],...
    %         ['��ʵ������:',num2str(virSrc(i).pos(2))],'����������','����������',...
    %         '�����','location','best');
    %     set(legd,'Box','off');
%         saveas(gcf,['�ڵ�',num2str(i),'gridsize=',num2str(gridsize),...
%             '.jpg'])
end
%���Ƹ��ε����ľ�����
% f=figure(11);
% clf(f);
% plot(1:MaxIT,mse,'r.-','MarkerSize',8);
% xlabel('��������');
% ylabel('������');
%�����û�λ��y
% disptitle('user position');
y=[0,0]';
for i=3:n
    y=y+X(:,i)+2.*vi(:,i)./norm(vi(:,i))^2;
end
y=y./(n-2);  %���ֵ

end

