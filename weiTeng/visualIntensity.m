% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     visualIntensity.m                                                   
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function [plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF)

NvirSrc = length(virSrc);   %����Դ����������NvirSrc
if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
%     fprintf('Fetching intensity distribution: \n');
    parfor_progress(NvirSrc);
end
sys_param.lightArea_plot = sys_param.visualIntensity_plot;

if sys_param.visualIntensity_parRun == true     %����������б�־==true
    parfor ii = 1:NvirSrc   %ÿ��Դ��+����Դ�����
        area_data(ii).area_s = propagateMap(env_param, sys_param, virSrc(ii), virRF(ii));%�����iiԴ���[·���� ������ʧ]
        if sys_param.visualIntensity_allin1 == false
            if sys_param.visualIntensity_plot == true
                fii_par = figure(sys_param.figHandler.visualIntensity+ii-1); clf(fii_par);  %�������ڣ����ؾ��
            end
            plotdata(ii).data = plotLightArea(area_data(ii), sys_param);    %����ÿһ��Դ������ɵĹ���
            if sys_param.visualIntensity_savefig == true
                saveas(fii_par, sprintf('./figures/%d.png',ii));
                close(fii_par);
            end
        end
        if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
            parfor_progress;
        end
    end
else    %�������б�־==false
    for ii = 1:NvirSrc      %ÿ��Դ��+����Դ�����
        area_data(ii).area_s = propagateMap(env_param, sys_param, virSrc(ii), virRF(ii));%�����ii��������[·���� ������ʧ]
        if sys_param.visualIntensity_allin1 == false
            if sys_param.visualIntensity_plot == true
                fii = figure(sys_param.figHandler.visualIntensity+ii-1); clf(fii);%�������ڣ����ؾ��
            end
            plotdata(ii).data = plotLightArea(area_data(ii), sys_param); %���Ƹ�Դ������ɵ�ÿ�����ӵĹ���
            if sys_param.visualIntensity_savefig == true
                saveas(fii, sprintf('./figures/%d.png',ii));
                close(fii);
            end
        end
        if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
            parfor_progress;
        end
    end
end

if sys_param.visualIntensity_allin1 == true  %����һͼ��
    if sys_param.visualIntensity_plot == true
        fii = figure(sys_param.figHandler.visualIntensity); clf(fii);
    end
    plotdata.data = plotLightArea(area_data, sys_param);%�źŵ�Ӱ����Ӳ���ֱ�Ӽӣ�Ӱ����������ܸ�
    if sys_param.visualIntensity_savefig == true
        saveas(fii, sprintf('./figures/allin1.png'));
        close(fii);
    end
end

if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
    parfor_progress(0);
end