% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     AoAAnalysize.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function [finalAoA,virS,RSS,finalAoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF)

sys_param_ = sys_param;             %��ȡϵͳ����
target_pos = sys_param_.target.pos; %��ȡĿ��λ��

sys_param_.visualIntensity_plot = false;    %����ǿ�ȱ�־
sys_param_.visualIntensity_savefig = false; %����ͼ���־
sys_param_.visualIntensity_allin1 = false;  %����һͼ��־
sys_param_.xlow = target_pos(1);                            %x����Сֵ
sys_param_.xhigh = target_pos(1)+0.45*sys_param_.gridsize;  %x�����ֵ
sys_param_.ylow = target_pos(2);                            %y����Сֵ
sys_param_.yhigh = target_pos(2)+0.45*sys_param_.gridsize;  %y�����ֵ-----------��Ŀ��㿴��һ������

if sys_param.AoAAnalysize_plotEnv || sys_param.AoAAnalysize_plotAoA     
%     fii = figure(sys_param.figHandler.AoAAnalysize); clf(fii);
    figure('Visible','off');
end

if sys_param.AoAAnalysize_plotEnv       %���ƻ�����־
%     if sys_param.AoAAnalysize_plotAoA   %����AoA��־
%         subplot(2,1,1)
%     end
    sys_param_.plotVirRF_print = false;
    plotVirRF(sys_param_, virRF);       %������������з�����
    sys_param_.plotVirSrc_print = false;
    plotVirSrc(sys_param_, virSrc(1));  %����Դ��
    hold on
    plot(target_pos(1), target_pos(2), 'r.')    %����Ŀ���
    axis equal
    xlim([sys_param.xlow sys_param.xhigh])
    ylim([sys_param.ylow sys_param.yhigh]);
end

AoA = [];   %�����
AoD = [];   %�뿪��
ARSS = [];  %�����ź�ǿ��
APlen = []; %·������

[plotdata, area_data] = visualIntensity(env_param, sys_param_, virSrc, virRF);  %[����ǿ��][·������������ʧ]
idx = find([plotdata.data] > sys_param_.AoAAnalysize_RSSthres);     %�ҵ�����RSS��ֵ��data
N = length(idx);    %�����������N
if sys_param.AoAAnalysize_plotEnv
 %   fprintf('Recursive beam tracing: \n');
    parfor_progress(N);
end
j=1;
for ii = idx    %ÿ������RSS��ֵ��data����
    AoA(ii) = angle(complex(virSrc(ii).pos(1)-target_pos(1), ...%Դ������-Ŀ������� ת��Ϊ �����
        virSrc(ii).pos(2)-target_pos(2)));
    if sys_param.AoAAnalysize_plotEnv
        aod_ = recursiveBeamTrace(virSrc, virRF, target_pos, ...    %��Ŀ���Ϊ�յ�ĵݹ�Ĳ���׷�٣������뿪��
            virSrc(ii).ID, sys_param.recursiveBeamTrace_useArrow+...
            sys_param.AoAAnalysize_plotEnv);
        %plot([virSrc(ii).pos(1) target_pos(1)], [virSrc(ii).pos(2) ...
        %target_pos(2)], 'Color', 'blue','LineWidth', 2)
        parfor_progress;
    else
        aod_ = recursiveBeamTrace(virSrc, virRF, target_pos, virSrc(ii).ID, 0);
    end
    AoD(ii) = aod_; %�����뿪��
    ARSS(ii) = plotdata(ii).data(1);    %����RSS
    APlen(ii) = area_data(ii).area_s(1,1).pathlen;  %����·����
    
    ToA(ii)=APlen(ii)/3e8*1e9;  %���浽��ʱ��
    finalAoA(j)=AoA(ii);  %��¼�����ź�ǿ��Ҫ���AOA��virSrc
    finalAoD(j)=AoD(ii);
    virS(j)=virSrc(ii);
    RSS(j)=ARSS(ii);
    %ToA(j)=ToA(ii);
    j=j+1;
end

if N==0
    finalAoA=[];
    finalAoD=[];
    virS={};
    RSS=[]; 
end
if sys_param.AoAAnalysize_plotEnv
    parfor_progress(0);
end

if sys_param.AoAAnalysize_plotEnv
    hold off
end

% if sys_param.AoAAnalysize_plotAoA
%     if sys_param.AoAAnalysize_plotEnv
%         subplot(2,1,2)
%     end
%     plot(AoA/pi*180, ARSS, 'ro'); hold on;
%     plot(AoD/pi*180, ARSS, 'bx'); hold off;
%     xlim([-180 180]);
%     xlabel('Angle of arrival/departure (deg.)')
%     ylabel('Amplitude')
%     legend('AoA', 'AoD');
    
    
    
    
    %{
fii = figure(sys_param.figHandler.AoAAnalysize+10); clf(fii);
    % joint AoA,AoD,DoA plot
    [X, Y] = meshgrid(-180:180,-180:180);
    xidx = round(AoA/pi*180)+181;
    yidx = round(AoD/pi*180)+181;
    Z = zeros(size(X));
    for ii = 1:length(xidx)
        Z(yidx(ii), xidx(ii)) = APlen(ii)/3e8*1e9;  %·����ת����ʱ�ӣ���λΪ����
    end
    plot3(X,Y,Z,'LineWidth',3);
    xlim([-180 180])
    ylim([-180 180])
    xlabel('AoA (deg.)')
    ylabel('AoD (deg.)')
    zlabel('delay (ns)')
    %}
end

