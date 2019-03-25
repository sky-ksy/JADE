function jade_param=getGridRange(srcPos,jade_param)
if all(abs(srcPos-[7.5 0.5])<1e-3)
    jade_param.left=-7.5; jade_param.right=8.5;   %Tx在右下
    jade_param.down=0.5; jade_param.up=19.5;
    jade_param.xRange=[-7.5 -6.5 -1.5  7.5 8.5];
    jade_param.yRange=[-0.5 0.5 12.5 14.5 19.5];
elseif all(abs(srcPos-[0.5 0.5])<1e-3)
    jade_param.left=-0.5; jade_param.right=15.5;   %Tx在左下
    jade_param.down=-0.5; jade_param.up=19.5;
    jade_param.xRange=[-0.5 0.5 5.5 15.5];
    jade_param.yRange=[-0.5 0.5 12.5 14.5 19.5];
elseif all(abs(srcPos-[1 9.5])<1e-3)
    jade_param.left=-1; jade_param.right=5;   %Tx在左上
    jade_param.down=-9.5; jade_param.up=10.5;
    jade_param.xRange=[-1 0 1 5 15];
    jade_param.yRange=[-9.5 3.3 5.5 9.5 10.5];
elseif all(abs(srcPos-[7.5 9.5])<1e-3)
    jade_param.left=-7.5; jade_param.right=8.5;   %Tx在右上
    jade_param.down=-9.5; jade_param.up=10.5;
    jade_param.xRange=[-7.5 -6.5 -1.5  7.5 8.5];
    jade_param.yRange=[-9.5 3.3 5.5 9.5 10.5];
else
    fprintf(2,'wrong srcPos\n');
end



