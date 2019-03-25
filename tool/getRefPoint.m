function refPoint=getRefPoint(virS,userPos)

apN=length(virS);
refPoint=[];

userN=size(userPos,1);
for i=2:apN
    for j=1:userN
        abs1=abs(virS(1,2)-virS(i,2));  %考虑斜率不存在的情况
        abs2=abs(userPos(j,1)-virS(i,1));
        midpoint=[virS(1,1)+virS(i,1),virS(1,2)+virS(i,2)]./2;
        if(abs1<1e-3 && abs2<1e-3)  %两个斜率都不存在时无法求交点
            continue;
        elseif(abs1<=1e-3 && abs2>1e-3)
            uVapK=(userPos(j,2)-virS(i,2))/(userPos(j,1)-virS(i,1));
            A=[1,0;uVapK,-1];
            B=[midpoint(1);uVapK*userPos(j,1)-userPos(j,2)];            
        elseif(abs1>1e-3 && abs2<=1e-3)
            bisectorK=-(virS(1,1)-virS(i,1))/(virS(1,2)-virS(i,2));
            A=[bisectorK,-1;1,0];
            B=[bisectorK*midpoint(1)-midpoint(2);userPos(j,1)];
        else
            bisectorK=-(virS(1,1)-virS(i,1))/(virS(1,2)-virS(i,2));
            uVapK=(userPos(j,2)-virS(i,2))/(userPos(j,1)-virS(i,1));
            A=[bisectorK,-1;uVapK,-1];
            B=[bisectorK*midpoint(1)-midpoint(2);uVapK*userPos(j,1)-userPos(j,2)];
        end
        refPoint=[refPoint;(A\B)'];
    end
end