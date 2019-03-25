function dis=getErrorDis(tRp,rp)
%限于tRp与rp中的点坐标是一一对应的
n=size(rp,1);
nt=size(rp,1);
if(n~=nt)
   fprintf(2,'反射点个数不对！') ;
   pause;
end
dis=0;
for i=1:n
    vec=tRp(i,:)-rp(i,:);
    dis=dis+norm(vec);
end
dis=dis/n;
