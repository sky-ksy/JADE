%根据求得的反射点数据绘制真实环境和估计环境
clc; clear all;
warning off;

% param.srcPos=[0.5 0.5];  folder_name='leftDownTx'; param.cornerId=1;  %leftDownTx
param.srcPos=[1 9.5];  folder_name='leftUpTx'; param.cornerId=2;  %leftUpTx
% param.srcPos=[7.5 9.5];  folder_name='rightUpTx'; param.cornerId=3;  %rightUpTx
% param.srcPos=[7.5 0.5];  folder_name='rightDownTx'; param.cornerId=4;  %rightDownTx
param=initParam(param);
load(['./data/',folder_name,'/data.mat']);

plotRefPoint(111,data.tRefPoint,param);
plotRefPoint(113,data.refPoint,param);

saveas(113,['../../env/',folder_name,'2.pdf']);

% n=length(data.errorDis);
% errdis=[];
% for i=1:n
%     errdis=[errdis,data.errorDis{i}];    
% end
% 
% sortDis=sort(errdis,'descend');
% [maxv,id]=max(errdis);
% errdis(id)=[];
% save(['./data/',folder_name,'errdis.mat'],'errdis');
% 
% minCorner=min(errdis);
% maxCorner=max(errdis);
% meanCorner=mean(errdis);
% stdCorner=std(errdis);
% sta=[minCorner,maxCorner,meanCorner,stdCorner];
% 
