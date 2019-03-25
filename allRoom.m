%���ĸ�����ѡȡһ����ΪAPλ��
%֮��user�������������Թ��������ͼ
clc; clear all;
warning off;

saveData=1;
folder_name='rightUpTx/';
load(['./data/',folder_name,'uGroup.mat']); %sortByVirS��������
load('./data/userPos.mat');

data.tRefPoint={};
data.refPoint={};
data.errorDis={};
% param.srcPos=[1 9.5];  %leftUpTx
% param.srcPos=[0.5 0.5];  %leftDownTx
param.srcPos=[7.5 9.5];  %rightUpTx
% param.srcPos=[7.5 0.5];  %rightDownTx
param=initParam(param); %ֻ��Txλ���й�
n=length(uGroup);

%���Ƶ�ǰTxλ�����ܽ���ê����Ƶ�userλ��
aviPos=[];
for i=1:n
    if size(uGroup(i).matAoA,2)>3  %�����ĸ�ê��
        uId=uGroup(i).uId;
        aviPos=[aviPos;userPos(uId,:)];
    end
end
plotAPUser(110,param,aviPos);

%���Ƶ�ǰTxλ�����ܼ�����ķ����
for i=1:n
    uGroupi= uGroup(i);
    if size(uGroupi.matAoA,1)<3
        fprintf('uGroup%d ���������<3\n',i);
        continue;
    end
    if size(uGroupi.matAoA,2)<4   %�����ĸ�ê��
        fprintf('uGroup%d ê�����<4\n',i);
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

