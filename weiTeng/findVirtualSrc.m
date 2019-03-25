% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     findVirtualSrc.m                                                    
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                                                                                                                      
%  *************************************************************************************

function [RetvirSrc, RetvirRF] = findVirtualSrc(env_param, sys_param, inVirSrc, inVirRF)

%����������ݹ���ȣ������ʾ
if sys_param.rec_depth > sys_param.max_recDepth
    RetvirSrc = [];
    RetvirRF = [];
    if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
            sys_param.findVirtualSrc_progress_enable
        for ii = 1:sys_param.max_recDepth-1
%             fprintf('\t');
        end
%         fprintf('Reach max recursion %d, return\n', sys_param.max_recDepth);
    end
    return; %-----------------------------------------------------------���ﷵ���ˣ�����
%��û�д��ڣ�ÿ�ݹ�һ�������ǰ�ݹ����
else
    if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
            sys_param.findVirtualSrc_progress_enable
        for ii = 1:sys_param.rec_depth-1
%             fprintf('\t');
        end
%         fprintf('Current depth %d -- ', sys_param.rec_depth);
    end
end

src_pos = inVirSrc.pos;         %Դ������
src_pathlen = inVirSrc.pathlen; %·��
src_refloss = inVirSrc.refloss; %������ʧ

reflector_id = env_param.reflector_id;      %������ID
reflector_list = env_param.reflector_list;  %�������б�

virSrc = [];
virRF = [];
idx = 0;

if reflector_id == -1
    N_ref = size(reflector_list, 1);    %�õ����������
    for ii = 1:N_ref                    %����������
        ref_pos = reflector_list(ii, 1:2);      %�õ�����������
        mirrp = mirrorPoint(src_pos, ref_pos);  %����mirrorPoint�����Ӧ��������
        
 % consider the situation that a reflecotr is blocked by other reflectors. 
 % In this case, we need to divide the reflector into multiple segments       
 %���Ƿ����汻�赲��������뽫�÷������Ϊ���
        seg_ref = getRefSeg(src_pos, reflector_list, ...    %����getRefSeg�����赲�ķ�����ֶ�
            reflector_list(ii, 1:2), ii, true);
        
        Nseg = size(seg_ref, 2);    %�õ��ֶε�ĸ���
        
        for kk = 1:Nseg-1   %����ÿ��
            ret = getIntensity(inVirSrc, reflector_list, ...                %������ʧ��·������
                (seg_ref(:,kk)+seg_ref(:,kk+1)).'/2, reflector_id, ii);
            
            idx = idx+1;
            virSrc(idx).pos = mirrp;    %ָ����ǰ��λ��Ϊ����λ��
            virSrc(idx).pathlen = 0;    %��ʼ����ǰ��·����
            virSrc(idx).refloss = ret.refloss+getRefLoss(reflector_list(ii,3)); %��ǰ�η�����ʧ
            virSrc(idx).depth = sys_param.rec_depth;    %��ǰ�εݹ���ȣ�
            virSrc(idx).ID = sys_param.virSrcN + idx;   %��ǰ��ID=virSrc����+�ö�id
            virSrc(idx).parentID = inVirSrc.ID;         %���ø���ID
            virRF(idx).info = [complex(seg_ref(1,kk), seg_ref(2,kk)), ...   %��������Ϣ��
                            complex(seg_ref(1,kk+1), seg_ref(2,kk+1)),...
                            reflector_list(ii, 3:4)];
            virRF(idx).ref = ii;                        %���õ�ǰvirRF��ID
            virRF(idx).ID = sys_param.virSrcN + idx;
        end
    end
else
    N_ref = size(reflector_list, 1);    %�ó���������������N_ref
    ref_ref = inVirRF.info;             %����RF����Ϣ����ref_ref
    for ii = 1:N_ref            %ÿ�����������һ��
        if ii == reflector_id   %����
            continue;
        end
        
        ref_pos = reflector_list(ii, 1:2);          %�õ�����������յ�
        seg_proj = getRefSeg(src_pos, ref_ref, ...  %����getRefSeg����ii����������ΪĿ�귴���棬�����ref_ref�ֶ�
            reflector_list(ii,1:2), [], false);     
        
        mirrp = mirrorPoint(src_pos, ref_pos);      %����mirrorPoint�ó����������
        
        seg_ref = getRefSeg(src_pos, reflector_list, ...       %����getRefSeg����ii����������ΪĿ�귴���棬�����reflector_list
            reflector_list(ii, 1:2), [ii], true);              %�ֶΣ�������ii��
        if size(seg_proj,2)>=2  %�������ref_ref�ķֶΣ����ڷֶε�
            seg_refidx = seg_ref(1, :)<=max(seg_proj(1,:))&...  %seg_proj x����Сֵ <= seg_ref��x <= seg_proj x�����ֵ
                seg_ref(1,:)>=min(seg_proj(1,:))&...            %seg_proj y����Сֵ <= seg_ref��y <= seg_proj y�����ֵ
                seg_ref(2,:)<=max(seg_proj(2,:))&...            %�����жϽ������seg_refidx��ȫ������Ϊ1������Ϊ0
                seg_ref(2,:)>=min(seg_proj(2,:));               
            seg_ref = seg_ref(:, seg_refidx);                   %ȡseg_ref�ĵ�1��*********��������������������������������
        else    %�������ڷֶε㣬�������²���
            continue;
        end
        
        Nseg = size(seg_ref, 2);    %seg_ref�ڷֶε���������Nseg
        
        for kk = 1:Nseg-1   %����ÿ���ֶε�
            ret = getIntensity(inVirSrc, reflector_list, ...    %�������ǿ�Ⱥͷ�����ʧ
                (seg_ref(:,kk)+seg_ref(:,kk+1)).'/2,...
                reflector_id, [ii, reflector_id]);
            
            idx = idx+1;
            virSrc(idx).pos = mirrp;
            virSrc(idx).pathlen = src_pathlen + getPathLen(src_pos, mirrp);
            virSrc(idx).refloss = src_refloss + ret.refloss+...
                getRefLoss(reflector_list(ii,3));
            virSrc(idx).depth = sys_param.rec_depth;
            virSrc(idx).ID = sys_param.virSrcN + idx;
            virSrc(idx).parentID = inVirSrc.ID;
            virRF(idx).info = [complex(seg_ref(1,kk), seg_ref(2,kk)), ...
                            complex(seg_ref(1,kk+1), seg_ref(2,kk+1)),...
                            reflector_list(ii, 3:4)];
            virRF(idx).ref = ii;
            virRF(idx).ID = sys_param.virSrcN + idx;
        end
    end
end

RetvirSrc = virSrc; %���������Դ�����RetvirSrc
RetvirRF = virRF;   %��Ӧ�����ⷴ�������RetvirRF
N_vir = idx;        %idxΪ��������N_vir
sys_param.rec_depth = sys_param.rec_depth+1;    %�ݹ����+1
sys_param.virSrcN = sys_param.virSrcN+N_vir;    %���µ�����Դ������ܼ�
if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
        sys_param.findVirtualSrc_progress_enable
%     fprintf('%d children\n', N_vir);
end
for ii = 1:N_vir    %�ݹ��ѭ��
    env_param.reflector_id = virRF(ii).ref;
    [tmpVirSrc, tmpVirRF] = findVirtualSrc(env_param, sys_param, virSrc(ii), virRF(ii));    %�ݹ�
    sys_param.virSrcN = sys_param.virSrcN+length(tmpVirSrc);
    
    RetvirSrc = [RetvirSrc, tmpVirSrc];
    RetvirRF = [RetvirRF, tmpVirRF];
end



