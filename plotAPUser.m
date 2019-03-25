function plotAPUser(figId,jade_param,userPos)

f=figure(figId); clf(f);
plotReflector(jade_param.env_param, jade_param.sys_param);
hold on;

p1=plot(userPos(:,1),userPos(:,2),'.-','MarkerSize',12);
p2=plot(jade_param.srcPos(1),jade_param.srcPos(2),'b.','MarkerSize',18);
legend([p2,p1],'AP','User','location','best');
title('用户移动路线');