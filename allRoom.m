%在四个角落选取一个作为AP位置
%之后user遍历整个房间以构建房间地图
clc; clear all;
warning off;

saveData=1;
folder_name='rightUpTx/';
load(['./data/',folder_name,'uGroup.mat']); %sortByVirS函数生成
load('./data/userPos.mat');

data.tRefPoint={};
data.refPoint={};
data.errorDis={};
% param.srcPos=[1 9.5];  %leftUpTx
% param.srcPos=[0.5 0.5];  %leftDownTx
param.srcPos=[7.5 9.5];  %rightUpTx
% param.srcPos=[7.5 0.5];  %rightDownTx
param=initParam(param); %只与Tx位置有关
n=length(uGroup);

%绘制当前Tx位置下能进行锚点估计的user位置
aviPos=[];
for i=1:n
    if size(uGroup(i).matAoA,2)>3  %至少四个锚点
        uId=uGroup(i).uId;
        aviPos=[aviPos;userPos(uId,:)];
    end
end
plotAPUser(110,param,aviPos);

%绘制当前Tx位置下能计算出的反射点
for i=1:n
    uGroupi= uGroup(i);
    if size(uGroupi.matAoA,1)<3
        fprintf('uGroup%d 采样点个数<3\n',i);
        continue;
    end
    if size(uGroupi.matAoA,2)<4   %至少四个锚点
        fprintf('uGroup%d 锚点个数<4\n',i);
        continue;
    end
    fprintf('uGroup%d\n',i);
    param.gid=i;
    data=JadeT(uGroupi,userPos,param,data);
end
if saveData
    save(['./data/',folder_name,'data1.mat'],'data');
end
plotRefPoint(111,data.tRefPoint,param);
plotRefPoint(112,data.refPoint,param);
saveas(111,['./data/',folder_name,'truth.jpg']);
saveas(112,['./data/',folder_name,'errRef1.jpg']);

