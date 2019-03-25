% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     propagateMap.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function area_s = propagateMap(env_param, sys_param, inVirSrc, inVirRF)

src_pos = inVirSrc.pos; %���Դ�����걣�浽src_pos

if isempty(inVirRF) || isempty(inVirRF.info)    %��inVirRFΪ�� �� inVirRF.infoΪ��
    reflector_id = -1;                          %��reflector_id = -1
else
    reflector_id = inVirRF.ref;
end
reflector_list = env_param.reflector_list;      %�ӻ��������л��ԭ�������б����reflector_list

[area_s, area_c] = initializemap(sys_param);    %area_sΪ[·������������ʧ]
                                                %area_cΪϵͳxy������ֵ

if reflector_id == -1
    % to all directionss
    area_size = size(area_s);   %area_siseΪ[y������ x������]
    for ii = 1:area_size(1)
        for kk = 1:area_size(2) %ÿ���ӽ��б���
            area_s(ii, kk) = getIntensity(inVirSrc, ... %����ÿ�����ӵ��ź�ǿ��
                reflector_list, [area_c.x(kk), area_c.y(ii)], reflector_id, []);    
        end
    end
else
    refmir = inVirRF.info(1:2); %����������յ��������refmir
    
    area_size = size(area_s);   %area_siseΪ[y������ x������]
    for ii = 1:area_size(1)
        for kk = 1:area_size(2)
            target = [area_c.x(kk), area_c.y(ii)];  %��[kk,ii]�����ӵ��������target
            
            [xi,~] = polyxpoly([src_pos(1) target(1)],[src_pos(2) target(2)], ...
                real(refmir), imag(refmir));    %���� Դ���target�������� �� ������ �Ľ��� ��xֵ
            if ~isempty(xi) %�����ڽ��㣬˵���ڷ��������࣬����ʧ
                % instant penetration loss and accumulated transmission loss
                area_s(ii, kk) = getIntensity(inVirSrc, reflector_list, ... %����ø����ź�ǿ�ȣ��ó�·��������ʧ
                [area_c.x(kk), area_c.y(ii)], reflector_id, reflector_id);
                % accumulated reflection and penetration loss
                area_s(ii, kk).refloss = area_s(ii, kk).refloss+inVirSrc.refloss;   %�ۼ�Դ�㱾����ʧ
            else    %û�н��㣬�ڷ�����ͬ�࣬����ʧ
                area_s(ii, kk) = struct('pathlen', inf, 'refloss', 0);
                continue;
            end
        end
    end
end

end