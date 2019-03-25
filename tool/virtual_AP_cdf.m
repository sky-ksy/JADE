%用来计算AOA的CDF
clear all;
% close all;
fname = sprintf('virtual_err_round_4_32.mat');
load(fname);
VPCDF = [];
VRCDF = [];
vpCount = 0;%虚拟AP
apCount = 0;%聚类AP
VPlength = 0;%总共的虚拟AP点数
vrCount = 0;%聚类真实点
trCount = 0;%虚拟折射点
VRlength = 0;%总共的虚拟折射点数
% for ii = 1:length(Cluster)
for ii = 1:100
    apminLen = [];
    vrminLen = [];
    %AP估计
    if ~isempty(Cluster{ii}.ap)
        for jj = 1:length(Cluster{ii}.ap(:,1))
            apLen = [];
            for kk = 1:length(Cluster{ii}.virPoint(:,1))
                apLen(kk) = sqrt((Cluster{ii}.ap(jj,1)-Cluster{ii}.virPoint(kk,1))^2+(Cluster{ii}.ap(jj,2)-Cluster{ii}.virPoint(kk,2))^2);
            end
            apminLen(jj) = min(apLen);
        end
    end
    %折射点估计
    if ~isempty(Cluster{ii}.rpMatrix)
        for jj = 1:length(Cluster{ii}.rpMatrix(:,1))
            vrLen = [];
            for kk = 1:length(Cluster{ii}.trpMatrix(:,1))
                vrLen(kk) = sqrt((Cluster{ii}.rpMatrix(jj,1)-Cluster{ii}.trpMatrix(kk,1))^2+(Cluster{ii}.rpMatrix(jj,2)-Cluster{ii}.trpMatrix(kk,2))^2);
            end
            vrminLen(jj) = min(vrLen);
        end
    end
    VPCDF = [VPCDF apminLen];
    VRCDF = [VRCDF vrminLen];
end
% for ii = 1:100
%     vpCount = sum(sum(Cluster{ii}.virPoint));
%     apCount = sum(sum(Cluster{ii}.ap));
%     VPlength = VPlength + length(Cluster{ii}.virPoint);
%     VPCDF = [VPCDF abs(vpCount-apCount)]/VPlength*100;
%     vrCount = sum(sum(Cluster{ii}.rpMatrix));
%     trCount = sum(sum(Cluster{ii}.trpMatrix));
%     VRlength = VRlength + length(Cluster{ii}.trpMatrix);
%     VRCDF = [VRCDF abs(vrCount-trCount)]/VRlength*100;
% end
figure();
hold on;
cdfplot(VPCDF);
cdfplot(VRCDF);
legend('virtual AP','reflecting Point');
hold off;
% AOACDF = [];
% AOACDF_count = [];
% for kk = 1:5
% %     fname1 = sprintf('data/bsv_group_%d.mat',kk);
% %     fname2 = sprintf('data/bsv_simu_%d_1.mat',kk);
%     fname1 = sprintf('result7/bsv_group_%d.mat',kk);
%     fname2 = sprintf('result7/bsv_simu_%d_0.mat',kk);
%     load(fname1);
%     load(fname2);
%     row=size(bsv_group,2);
%     angle_num = bsv_group{1}.angle_num; %路径的个数
%     CDF = [];
%     for ii = 1:1000
%         group_count = 0;
%         simu_count = 0;
%         for jj = 1:angle_num
%             %         path_count = path_count + abs(bsv_group{ii}.path(jj)-bsv_simu{ii}.esti_path(jj));
%             group_count = group_count + bsv_group{ii}.path(jj);
%             simu_count = simu_count + bsv_simu{ii}.esti_path(jj);
%             if jj == length(bsv_simu{ii}.esti_path)
%                 break;
%             end
%         end
%         CDF = [CDF abs(group_count-simu_count)*3/kk];%角度差
%     end
%     AOACDF(kk,:) = CDF;
%     AOACDF_count(kk,:) = sum(AOACDF(kk,:))/1000;
% end
% figure();
% hold on;
% for mm = 1:5
%     cdfplot(AOACDF(mm,:));
%     [max_val,max_id] = max(AOACDF(mm,:));
%     [sort_value, sort_id] = sort(AOACDF(mm,:),'descend');
% end
% legend('AOA:1','AOA:2','AOA:3','AOA:4','AOA:5');
% hold off;
% x = bsv_group{1}.path;
% y = bsv_simu{1}.esti_path;