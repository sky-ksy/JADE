% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotLightArea.m                                                     
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotdata = plotLightArea(area_data, sys_param)

N_area_data = length(area_data);    %Ҫ���Ƶ�ͼ����������N_area_data
if N_area_data >= 1
    area_size = size(area_data(1).area_s);  %ÿ������ͼ�Ĵ�С
    plotdata = zeros(area_size);            %��������ͼ�ĳ�ʼ�վ���
    
    for gg = 1:N_area_data      %ÿ������ͼ����
        area_s = area_data(gg).area_s;  %��õ�ǰ����ͼ��[·���� ������ʧ]
        for ii = 1:area_size(1)         %ÿ�����ӱ���
            for kk = 1:area_size(2)     
                plotdata(ii, kk) = plotdata(ii, kk) + ...   %����ÿ�����ӵ���ɫ��Ϣ��������ʧ��
                    db2amp(-(getPathLoss(area_s(ii, kk).pathlen)+area_s(ii, kk).refloss));%------��ʧ ���� �ź�ǿ��
            end
        end
    end
    
    if sys_param.lightArea_plot == true
        colormap('hot')
        imagesc(flip(plotdata));
        yTicks = get(gca,'YTick');
        stepy = (sys_param.yhigh-sys_param.ylow)/length(yTicks);
        yTicks = sys_param.ylow+stepy:stepy:sys_param.yhigh;
        set(gca,'YTickLabel',num2str(yTicks.'));
        xTicks = get(gca,'XTick');
        stepx = (sys_param.xhigh-sys_param.xlow)/length(xTicks);
        xTicks = sys_param.xlow+stepx:stepx:sys_param.xhigh;
        set(gca,'XTickLabel',num2str(xTicks.'));
    end
end