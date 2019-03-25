function plotRefPoint(figId,refPoint,param)

rpMatrix=[];
for t=1:length(refPoint)
    rp=refPoint{t}; %tÊ±¿ÌµÄ·´Éäµã¾ØÕó
    rpMatrix=[rpMatrix;rp];
end
maxX=max(rpMatrix(:,1));
minX=min(rpMatrix(:,1));
maxY=max(rpMatrix(:,2));
minY=min(rpMatrix(:,2));

f=figure(figId); clf(f);
plotReflector(param.env_param, param.sys_param);
hold on;
plot(rpMatrix(:,1),rpMatrix(:,2),'k.','MarkerSize',12);
% colr=[1 0 1]; %·Û

% colr=[0.498 1 0];  %ÂÌ

% colr=[0.804 0.52 0.247];  %×Ø

% colr=[1 0.84 0];  %½ð
% colr=[1 0.078 0.576];  %Ç³·Û
% colr=[0.2745 0.51 0.7059];  %steel blue
% colr=[0.1177 0.56 1];  %dodger blue
colr1=[0 0 0.502];  %dodger blue
colr1=[0.4157 0.353 0.804];
colr2=[0 0.8 0.81]; %ÉîÇà
colr3=[0.13 0.545 0.13];  %ÂÌ
% colr4=[0.98 0.5 0.447];  %Ç³·Û
colr4=[0.698 0.133 0.133]; %ºì
if(param.cornerId==1)
%     plot(param.srcPos(1)+0.05,param.srcPos(2)+0.1,'p','color',colr1,'MarkerFaceColor',colr1,'MarkerSize',20);
elseif(param.cornerId==2)
    plot(param.srcPos(1)+0.1,param.srcPos(2)-0.03,'p','color',colr2,'MarkerFaceColor',colr2,'MarkerSize',20);
elseif(param.cornerId==3)
    plot(param.srcPos(1)-0.3,param.srcPos(2)-0.2,'p','color',colr3,'MarkerFaceColor',colr3,'MarkerSize',20);
elseif(param.cornerId==4)
    plot(param.srcPos(1)-0.3,param.srcPos(2)+0.2,'p','color',colr4,'MarkerFaceColor',colr4,'MarkerSize',20);
else
    fprintf('wrong srcPos\n');
end
% xlow=jade_param.sys_param.xlow;
% xhigh=jade_param.sys_param.xhigh;
% ylow=jade_param.sys_param.ylow;
% yhigh=jade_param.sys_param.yhigh;
% xlim([min(minX,xlow),max(maxX,xhigh)]);
% ylim([min([minY,ylow]),max(25,yhigh)]);  %min(minY,ylow)
% xlim([-8,16]);
% ylim([-10,20]);
xlim([-3,11]);
ylim([-2,12]);