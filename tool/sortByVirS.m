%根据Tx、user位置，对user在某个位置观测到的锚点集的不同对所有user位置进行分组
clc; clear all;

param.srcPos=[7.5 0.5];  %Tx位置
x1=(0.5:0.5:7.5); %user遍历房间所有位置
y1=(0.5:0.5:9.5);
k=0;
for i=1:length(x1)
    for j=1:length(y1)
        k=k+1;
        userPos(k,:)=[x1(i),y1(j)];
    end
end

n=size(userPos,1);
cellAoA=cell(n,1);
cellVirS=cell(n,1);
cellVirSMat=cell(n,1);
cellRSS=cell(n,1);

param=initParam(param);
[AoA,virS,RSS]=getAoARSS(userPos(1,:),param); %一个src对应一个固定的param
virMat=st2matrix(virS);  %结构体转矩阵
cellAoA{1}=AoA;
cellVirS{1}=virS;
cellVirSMat{1}=virMat;
cellRSS{1}=RSS;


j=1;  %分组数
uGroup(j).uId=1;  %不同user组包括的userId
uGroup(j).matAoA=AoA;
uGroup(j).structVirS=virS;  %锚点结构体
uGroup(j).matVirS=virMat;  %锚点位置矩阵
uGroup(j).matRSS=RSS;
virGroup{j}=virMat;  %记录user遇到的不同的锚点组合

for i=2:n
    if mod(i,10)==0
        fprintf('%d/%d\n',i,n);
    end
    [AoA,virS,RSS]=getAoARSS(userPos(i,:),param);
    virMat=st2matrix(virS);
    cellAoA{i}=AoA;
    cellVirS{i}=virS;
    cellVirSMat{i}=virMat;
    cellRSS{i}=RSS;
    
    belongId=findGroup(virMat,virGroup);
    if belongId==0  %与之前观测到的锚点组合都不同，新的user组
        j=j+1;
        uGroup(j).uId=i;        
        uGroup(j).matAoA=AoA;  
        uGroup(j).structVirS=virS;
        uGroup(j).matVirS=virMat;  %锚点位置矩阵
        uGroup(j).matRSS=RSS;
        virGroup{j}=virMat;
    else  %原有user组
        uGroup(belongId).uId=[uGroup(belongId).uId;i];       
        uGroup(belongId).matAoA=[uGroup(belongId).matAoA;AoA];
        uGroup(belongId).matRSS=[uGroup(belongId).matRSS;RSS];
    end
end
save('./data/rightUpTx/uGroup.mat','uGroup');
save('./data/rightUpTx/cellAoA.mat','cellAoA');
save('./data/rightUpTx/cellRSS.mat','cellRSS');
save('./data/rightUpTx/cellVirS.mat','cellVirS');
save('./data/rightUpTx/cellVirSMat.mat','cellVirSMat');
