function AoA=genErrorAoA(AoA,RSS)
%����RSSǿ�ȵ�˥���Ӵ�AoA���
oriAoA=AoA;
n=length(AoA);
rd=rand(1,n);
sig=zeros(1,n)-1;
sig(rd>0.5)=1; %�Ƕȵ�����ƫ��

% pian1=intersect(find(0.06<=RSS) ,find(RSS<0.12)); %���1m-2m
% AoA(pian1)=AoA(pian1)+sig(pian1).*(zeros(1,length(pian1))+pi/180); %ƫ��1��
% pian2=intersect(find(0.04<=RSS) ,find(RSS<0.06)); %���2m-3m
% AoA(pian2)=AoA(pian2)+sig(pian2).*(zeros(1,length(pian2))+1.5*pi/180); %ƫ��2��
% pian3=intersect(find(0.03<=RSS) ,find(RSS<0.04)); %���3m-4m
% AoA(pian3)=AoA(pian3)+sig(pian3).*(zeros(1,length(pian3))+2*pi/180); %ƫ��3��
pian4=intersect(find(0.01<=RSS) ,find(RSS<0.03)); %���4m-5m
AoA(pian4)=AoA(pian4)+sig(pian4).*(zeros(1,length(pian4))+0.5*pi/180); %ƫ��4��
pian5=find(RSS<0.01); %����5m
AoA(pian5)=AoA(pian5)+sig(pian5).*(zeros(1,length(pian5))+3*pi/180); %ƫ��5��

gtPi=find(AoA>pi);
AoA(gtPi)=AoA(gtPi)-2*pi;
leqNegPi=find(AoA<=-pi);
AoA(leqNegPi)=AoA(leqNegPi)+2*pi; %��Χ�����ڣ�-pi,pi]

