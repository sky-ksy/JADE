function dis=getErrorDis(tRp,rp)
%����tRp��rp�еĵ�������һһ��Ӧ��
n=size(rp,1);
nt=size(rp,1);
if(n~=nt)
   fprintf(2,'�����������ԣ�') ;
   pause;
end
dis=0;
for i=1:n
    vec=tRp(i,:)-rp(i,:);
    dis=dis+norm(vec);
end
dis=dis/n;
