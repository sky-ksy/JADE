% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     getRefSeg.m                                                         
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function val = getRefSeg(src_pos, reflector_list, tgRF, excList, incEnd)

% Function usage: when ray originating from src_pos to tgRF, it may blocked
% by reflectors in reflector_list, and be separated into multiple
% segments. Here we drive these multiple segments.


N_list = size(reflector_list, 1);   %�����������

if incEnd   %��incEndΪtrue
    segx = [real(tgRF(1)) real(tgRF(2))];   %���������x����
    segy = [imag(tgRF(1)) imag(tgRF(2))];   %��ȡ�������y����
else
    segx = [];
    segy = [];
end

for ii = 1:N_list   %ÿ�����������
    if sum(excList == ii)>0     %������ii�������棬����ǰ����ķ�����
        continue;
    end
    
    test_RF = reflector_list(ii, 1:2);  %��ii�����������test_RF
    %��1=Դ��-Ŀ�귴����������� �� ��ii������ �Ľ���
    [p1x, p1y] = polyxpoly([src_pos(1) real(tgRF(1))],[src_pos(2) imag(tgRF(1))], ...
        real(test_RF), imag(test_RF));
     %��2=Դ��-Ŀ�귴�����յ����� �� ��ii������ �Ľ���
    [p2x, p2y] = polyxpoly([src_pos(1) real(tgRF(2))],[src_pos(2) imag(tgRF(2))], ...
        real(test_RF), imag(test_RF)); 
                                           
    if ~isempty(p1x)        %����1����
        p1x = real(tgRF(1));%��1xΪĿ�귴�������x
        p1y = imag(tgRF(1));%��1yΪĿ�귴�������y
    end
    if ~isempty(p2x)        %����2����
        p2x = real(tgRF(2));%��2xΪĿ�귴�����յ�x
        p2y = imag(tgRF(2));%��2yΪĿ�귴�����յ�y
    end

    % multiple 999999 equals to the effect of extending the line very long,
    % to make sure that the line is intersecting with the target reflector,
    % if exists.
    %��3=Դ�����ii������������ߵ��ӳ��� �� Ŀ�귴���� �Ľ���
    [p3x, p3y] = polyxpoly([src_pos(1) (real(test_RF(1))-src_pos(1))*999999], ...
        [src_pos(2) (imag(test_RF(1))-src_pos(2))*999999], ...
        real(tgRF), imag(tgRF));
    %��4=Դ�����ii�������յ����ߵ��ӳ��� �� Ŀ�귴���� �Ľ���
    [p4x, p4y] = polyxpoly([src_pos(1) (real(test_RF(2))-src_pos(1))*999999], ...
        [src_pos(2) (imag(test_RF(2))-src_pos(2))*999999], ...
        real(tgRF), imag(tgRF));
    
    if length([p1x p2x p3x p4x]) >= 2   %����1234�������������ڣ���ֶ�
        segx = [segx, p1x, p2x, p3x, p4x];
        segy = [segy, p1y, p2y, p3y, p4y];
    end
end

%��x�Ĳ�ֵ����y�Ĳ�ֵ��-1<б��<1��
if abs(real(tgRF(1))-real(tgRF(2))) > abs(imag(tgRF(1))-imag(tgRF(2)))
    [segx, ia] = unique(round(segx,2)); %segx�е�ֵ����ȷ��С�������λ������ȥ���ظ�ֵ
    segy = segy(ia);
else
    [segy, ia] = unique(round(segy,2)); %segy�е�ֵ����ȷ��С�������λ������ȥ���ظ�ֵ
    segx = segx(ia);
end
    
val = [segx; segy]; %�ó��ֶε�
    