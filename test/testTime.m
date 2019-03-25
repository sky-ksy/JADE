
% clear all;
% %c=zeros(10000,100);%Ô¤·ÖÅä0.02s
% tic
% for i=100:-1:1
%     for j=10000:-1:1
%         c(j,i)=i^2*j;
%     end
% end
% toc %0.1s

% clear all
% c=zeros(10000,100);%Ô¤·ÖÅä0.02s
% tic
% for i=1:10000
%     for j=1:100
%         c(j,i)=i^2*j; %0.03s
%     end
% end
% toc %5.9s

% fprintf('j=1:10000');
% clear
% tic
% for i=1:100
%     for j=1:10000
%         a(j,i)=i*j^2;
%     end
% end
% toc

% clear
% tic
% for i=1:10000
%     for j=1:100
%         c(i,j)=i^2*j;
%     end
% end
% toc

% clear
% 
% tic
% for i=10000:-1:1
%     for j=1:100
%         c(i,j)=i^2*j;
%     end
% end
% toc