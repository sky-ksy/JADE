% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     recursiveBeamTrace.m                                                
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function aod = recursiveBeamTrace(virSrc, virRF, endp, sVirSrcID, plottype) %�ݹ�Ĳ���׷��

Srcidx = ([virSrc.ID] == sVirSrcID);    %�ҵ���ǰ������Ӧ��virSrc���λ��
startp = virSrc(Srcidx).pos;            %��virSrc��øþ��������
if sVirSrcID == 0   %��ΪԴ��
    % last reflection
    if plottype >= 2
        arrow('Start', startp, 'Stop', endp, 'Length', 4, 'TipAngle', 10);  %Դ��Ϊ��㣬���յ㣬����ͷ
    elseif plottype >= 1
        plot([endp(1) startp(1)], [endp(2) startp(2)], 'Color', 'blue','LineWidth', 2);
    end
    aod = angle(complex(endp(1)-startp(1), endp(2)-startp(2))); %Ŀ���-Դ�� ת��Ϊ �뿪��
else  %��Ϊ�����
    RFidx = ([virRF.ID] == sVirSrcID);  %�ҵ���Ӧ��������virRF���λ��
    ref = virRF(RFidx).info(1:2);       %��virRF��ø÷���������յ�
    [xi,yi] = polyxpoly([endp(1) startp(1)],[endp(2) startp(2)], ...    %�������Ŀ������� �� ������ ����
        real(ref), imag(ref));
    
    if plottype >= 2
        arrow('Start', [xi, yi], 'Stop', endp, 'Length', 4, 'TipAngle', 20);%����Ϊ��㣬���յ㣬����ͷ
    elseif plottype >= 1
        plot([endp(1) xi], [endp(2) yi], 'Color', 'blue','LineWidth', 2);
    end
    
    aod = recursiveBeamTrace(virSrc, virRF, [xi, yi], ...%�Խ���Ϊ�յ㣬�㼯ֻ�иþ���㣬�ĵݹ鲨��׷��
        virSrc(Srcidx).parentID, plottype);
end