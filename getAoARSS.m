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
function [AoA,virS,RSS]=getAoARSS(userPos,param)

env_param=param.env_param;
sys_param=param.sys_param;
virSrc=param.virSrc;
virRF=param.virRF;
sys_param.target.pos = userPos;  %�趨Ŀ��λ��

% disptitle('AoA analysis');
[AoA,virS,RSS,AoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF);  %�ź�ǿ��С��ĳһ��ֵ��RSS��AoAΪ0
% jade_param.sys_param=sys_param;
% jade_param.env_param=env_param;
% jade_param.ToA=ToA;
% jade_param.AoD=AoD;
end

