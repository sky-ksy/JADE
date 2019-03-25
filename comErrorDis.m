% 统计AP分布在四个角落的综合误差
allErrDis=[];
load(['./data/','leftDownTx/','errdis.mat']);
allErrDis=[allErrDis,errdis];
load(['./data/','leftUpTx/','errdis.mat']);
allErrDis=[allErrDis,errdis];
load(['./data/','rightDownTx/','errdis.mat']);
allErrDis=[allErrDis,errdis];
load(['./data/','rightUpTx/','errdis.mat']);
allErrDis=[allErrDis,errdis];
minAll=min(allErrDis);
maxAll=max(allErrDis);
meanAll=mean(allErrDis);
stdAll=std(allErrDis);
sta=[minAll,maxAll,meanAll,stdAll];