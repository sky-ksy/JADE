%����Tx��userλ�ã���user��ĳ��λ�ù۲⵽��ê�㼯�Ĳ�ͬ������userλ�ý��з���
clc; clear all;

param.srcPos=[7.5 0.5];  %Txλ��
x1=(0.5:0.5:7.5); %user������������λ��
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
[AoA,virS,RSS]=getAoARSS(userPos(1,:),param); %һ��src��Ӧһ���̶���param
virMat=st2matrix(virS);  %�ṹ��ת����
cellAoA{1}=AoA;
cellVirS{1}=virS;
cellVirSMat{1}=virMat;
cellRSS{1}=RSS;


j=1;  %������
uGroup(j).uId=1;  %��ͬuser�������userId
uGroup(j).matAoA=AoA;
uGroup(j).structVirS=virS;  %ê��ṹ��
uGroup(j).matVirS=virMat;  %ê��λ�þ���
uGroup(j).matRSS=RSS;
virGroup{j}=virMat;  %��¼user�����Ĳ�ͬ��ê�����

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
    if belongId==0  %��֮ǰ�۲⵽��ê����϶���ͬ���µ�user��
        j=j+1;
        uGroup(j).uId=i;        
        uGroup(j).matAoA=AoA;  
        uGroup(j).structVirS=virS;
        uGroup(j).matVirS=virMat;  %ê��λ�þ���
        uGroup(j).matRSS=RSS;
        virGroup{j}=virMat;
    else  %ԭ��user��
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
