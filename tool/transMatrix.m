function trM=transMatrix(src,des)
%����������ϵ֮��ı任����δ���~~~
src(1,:)=[1 0];
src(2,:)=[0 1];
% des(1,:)=[0 0];
% des(2,:)=[-6 0];
trM=src\des;