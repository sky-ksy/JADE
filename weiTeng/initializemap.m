% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     initializemap.m                                                     
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function [area_s, area_c] = initializemap(sys_param)

x_cor = sys_param.xlow:sys_param.gridsize:sys_param.xhigh;
y_cor = sys_param.ylow:sys_param.gridsize:sys_param.yhigh;

%[area_c.x, area_c.y] = meshgrid(x_cor, y_cor);
area_c.x = x_cor;
area_c.y = y_cor;       %area_c��xy����Ϊϵͳ�����������xy����

Nx = length(x_cor);     %����xy���������
Ny = length(y_cor);
area_s(Ny, Nx) = struct('pathlen', 0, 'refloss', 0);    %area_c��NyNxΪ·�����ͷ�����ʧ