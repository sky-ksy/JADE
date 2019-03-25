function [param]=initParam(param)
srcPos=param.srcPos;
%���������еķ�����ṹ����㣬�յ㣬�����ʣ���͸
% location1, location2, reflectivity, penetration

% env_param.reflector_list = ...      %����������6��������
%     [0.5-1i, 1.5-1i, 1, 0;
%      2+0i,   2-2i, 1, 0;
%      0+2i, -1+1i, 1.0, 0.0;
%      -2-3i, -2+0.5i, 1.0, 0.0;
%      1+2i, 2+1i, 1.0, 0.0;
%      -0.5-0.5i, -0.5+0.5i, 1.0, 0.0];

% env_param.reflector_list = ...      %��������һ��6*4���η���
%     [-3-1.5i, -3+2.5i, 1, 0;
%      -3+2.5i,   3+2.5i, 1, 0;
%      3+2.5i, 3-1.5i, 1.0, 0.0;
%      3-1.5i, -3-1.5i, 1.0, 0.0;
%      ];
% sys_param.xlow = -3; sys_param.xhigh = 3;       %x�᷶Χ
% sys_param.ylow = -1.5; sys_param.yhigh = 2.5;       %y�᷶Χ

% env_param.reflector_list = ...      %��������һ���������ıڷ���
%     [-4-2i, -3+3i, 1, 0;
%     -3+3i,   3+2.5i, 1, 0;
%     3+2.5i, 4-1.5i, 1.0, 0.0;
%     4-1.5i, -4-2i, 1.0, 0.0;
%     ];
% sys_param.xlow = -4; sys_param.xhigh = 4;       %x�᷶Χ
% sys_param.ylow = -2; sys_param.yhigh = 3;       %y�᷶Χ

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
%����RayTracerϵͳ����
sys_param.gridsize = 0.1;                       %RayTracer�����С
sys_param.virSrcN = 0;                          %virSrc����
sys_param.target.RF = 60e9:1e6:61e9;            %Ŀ��Ƶ��
sys_param = figHandlerAsssign(sys_param);

sys_param.rec_depth = 1;
sys_param.max_recDepth = 1;

sys_param.plotSysSetup = true;
sys_param.plotVirRF_print = true;
sys_param.plotVirSrc_print = true;

sys_param.visualIntensity_parRun = false;   %ƽ�����б�־
sys_param.visualIntensity_plot = true;      %���Ʊ�־
sys_param.visualIntensity_savefig = false;  %����ͼƬ��־
sys_param.visualIntensity_allin1 = true;   %���Ƶ�һ��ͼ��־

sys_param.AoAAnalysize_RSSthres = 1e-10;    %RSS��ֵ
sys_param.AoAAnalysize_plotAoA = 1;         %���Ƶ���Ǳ�־
sys_param.AoAAnalysize_plotEnv = 1;         %���ƻ�����־
sys_param.recursiveBeamTrace_useArrow = 1;  %ʹ�ü�ͷ��־

%src�Ľṹ��λ�ã�·������������ʧ����ȣ�ID������ID
src = struct('pos', srcPos, 'pathlen', 0, 'refloss', 0,...
    'depth', 0, 'ID', 0, 'parentID', -1);
% sys_param.target.pos = userPos';                %�趨Ŀ��λ��

%���㾵���λ��
% disptitle('Recursion tree for virtual source')
[virSrc, virRF] = findVirtualSrc(env_param, sys_param, src, []);    %����findVirtualSrc���virSrc��virRF

%����ԭʼ�㣬����㣬������
% disptitle('Visualizing setup')
virSrc = [src virSrc];  %���ڵ�virSrc��ǰ�벿����src
virRF = [struct('info',[], 'ref', [], 'ID', 0) virRF];
%�����ź�ǿ��ͼ
% disptitle('Visualizing signal intensity');
% [plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF);

plotSysSetup(env_param, sys_param, virRF, virSrc);   %���ƻ���
param.env_param=env_param;
param.sys_param=sys_param;
param.virSrc=virSrc;
param.virRF=virRF;