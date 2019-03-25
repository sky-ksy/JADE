% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     main.m                                                              
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM 
%
%    Update:        add 3-D reflection and device orientation
%    Author:        Anfu Zhou
%    Date:          Feb 2017
%  *************************************************************************************
function [AoA,virS,RSS,jade_param]=generateAoA(jade_param,userPos,srcPos)
% clc; clear all;
% warning off;
% pathSetup

%src�Ľṹ��λ�ã�·������������ʧ����ȣ�ID������ID
src = struct('pos', srcPos, 'pathlen', 0, 'refloss', 0,...
    'depth', 0, 'ID', 0, 'parentID', -1);

%���������еķ�����ṹ����㣬�յ㣬�����ʣ���͸
% location1, location2, reflectivity, penetration

% env_param.reflector_list = ...      %��������������������
%     [0.5-1i, 1.5-1i, 1, 0;
%      2+0i,   2-2i, 1, 0;
%      0+2i, -1+1i, 1.0, 0.0;
%      -2-3i, -2+0.5i, 1.0, 0.0;
%      1+2i, 2+1i, 1.0, 0.0;
%      -0.5-0.5i, -0.5+0.5i, 1.0, 0.0];

% env_param.reflector_list = ...      %��������һ��6*4�ıڷ���
%     [-3-1.5i, -3+2.5i, 1, 0;
%      -3+2.5i,   3+2.5i, 1, 0;
%      3+2.5i, 3-1.5i, 1.0, 0.0;
%      3-1.5i, -3-1.5i, 1.0, 0.0;
%      ];
%  env_param.reflector_list = ...      %��������һ��ǽ����б����
%     [-4-2i, -3+3i, 1, 0;
%      -3+3i,   3+2.5i, 1, 0;
%      3+2.5i, 4-1.5i, 1.0, 0.0;
%      4-1.5i, -4-2i, 1.0, 0.0;
%      ];
% sys_param.xlow = -4; sys_param.xhigh = 4;       %x�᷶Χ
% sys_param.ylow = -2; sys_param.yhigh = 3;   %y�᷶Χ

env_param.reflector_list = ...      % Reflector list
    [-0.01-0.01i, 8.01- 0.01i, 0.5, 0;  %��Ȧǽ1
     8.01+10.01i, 8.01- 0.01i, 0.5, 0;  %��Ȧǽ2
     8.01+10.01i, 0.51+10.01i, 0.5, 0;  %��Ȧǽ3
     0.51+ 6.41i, 0.51+10.01i, 0.5, 0;  %��Ȧǽ4
     -0.01+6.41i, 2.51+ 6.41i, 0.8, 0;  %��Ȧ��ֽǽ5
     -0.01+6.41i, -0.01-0.01i, 0.3, 0;  %��Ȧ��ǽ6
     
     2.95+10.01i, 2.95+7.61i, 0.8, 0;  %�ڲ���ֽǽ1
     4.95+ 7.61i, 2.95+7.61i, 0.7, 0;  %�ڲ���Ļǽ2
     6.01+ 7.61i, 8.01+7.61i, 0.6, 0;  %�ڲ��װ�ǽ3
     
%      3.87+2.85i, 5.31+2.85i, 0.2, 0.8;  %����
%      5.31+5.15i, 5.31+2.85i, 0.2, 0.8;
%      5.31+5.15i, 3.87+5.15i, 0.2, 0.8;
%      3.87+2.85i, 3.87+5.15i, 0.2, 0.8;       
    ];
sys_param.xlow = -0.01; sys_param.xhigh = 8.01;  %��ͼ�������귶Χ
sys_param.ylow = -0.01; sys_param.yhigh = 10.01;

env_param.reflector_id = -1;        %������ID��ʼΪ-1
env_param.exclude_list = [];        %�ų����б�

%����ϵͳ����
sys_param.gridsize = 0.1;                       %�����С
sys_param.virSrcN = 0;                          %virsrc����
sys_param.target.pos = userPos';                 %�趨Ŀ��λ��
sys_param.target.RF = 60e9:1e6:61e9;            %Ŀ��Ƶ��
sys_param = figHandlerAsssign(sys_param);

%���㾵���λ��
% disptitle('Recursion tree for virtual source')
sys_param.rec_depth = 1;
sys_param.max_recDepth = 1;
[virSrc, virRF] = findVirtualSrc(env_param, sys_param, src, []);    %����findVirtualSrc���virSrc��virRF

%����ԭʼ�㣬����㣬������
% disptitle('Visualizing setup')
sys_param.plotSysSetup = true;
sys_param.plotVirRF_print = true;
sys_param.plotVirSrc_print = true;
virSrc = [src virSrc];  %���ڵ�virSrc��ǰ�벿����src
virRF = [struct('info',[], 'ref', [], 'ID', 0) virRF];
% plotSysSetup(env_param, sys_param, virRF, virSrc);      %���ƻ�������

%�����ź�ǿ��ͼ
% disptitle('Visualizing signal intensity');
sys_param.visualIntensity_parRun = false;   %ƽ�����б�־
sys_param.visualIntensity_plot = true;      %���Ʊ�־
sys_param.visualIntensity_savefig = false;  %����ͼƬ��־
sys_param.visualIntensity_allin1 = true;   %���Ƶ�һ��ͼ��־
%[plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF);


% disptitle('AoA analysis');
sys_param.AoAAnalysize_RSSthres = 1e-10;    %RSS��ֵ
sys_param.AoAAnalysize_plotAoA = 1;         %���Ƶ���Ǳ�־
sys_param.AoAAnalysize_plotEnv = 1;         %���ƻ�����־
sys_param.recursiveBeamTrace_useArrow = 1;  %ʹ�ü�ͷ��־
[AoA,virS,RSS,AoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF);
jade_param.sys_param=sys_param;
jade_param.env_param=env_param;
%jade_param.ToA=ToA;
jade_param.AoD=AoD;
end


%Jade(AoA,ARSS,virSrc);

%���Դ���1
% n=length(virSrc)
% fprintf('pR,mT\n');  %mR,mT:9�����㣬3��С��1�� pR,pT 2��0�� mR,pTȫ�㣻pR,mT 9�����㣬4��С��0�� 
% for i=1:n
%    for j=[1:i-1,i+1:n] 
%        %theta=abs(AoA(j)-AoA(i));%myT
%        theta=AoA(j)-AoA(i);%paperT
%        beta=pi/2-theta;
%        %R=[cos(beta),sin(beta);-sin(beta),cos(beta)]; %paperR
%        R=[cos(beta),-sin(beta);sin(beta),cos(beta)];%myR
%        
%        y=sys_param.target.pos;
%        xi=virSrc(i).pos;
%        xj=virSrc(j).pos;
%        vi=2*(y-xi)/(norm(y-xi))^2;
%        bi=2*sin(theta);
%        sub=vi*R*(xj-xi)'-bi;
%        fprintf('i=%d,j=%d,sub=%f\n',i,j,sub);
%    end
% end

%���Դ���2
% n=length(virSrc);
% X=zeros(2,n);
% for i=1:n
%    X(:,i)=virSrc(i).pos'; 
% end
% X
% for i=1:n
%     Xii=transCol(X,i,n);
%     [thetai,Ri]=generateR(AoA,i,n);
%     Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
%     bi=2*sin(thetai);   
%     y=sys_param.target.pos';
%     vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;
%     sub=vi'*Mi-bi
% end