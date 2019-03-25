M=[2 3 5 ;4 6 10 ];
equ=1e-4;
n=3;
if(isIndep(M,n,equ))
    fprintf('无关');
else
    fprintf('相关');
end