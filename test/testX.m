function  test0( X,AoA,sys_param )

X   %¥˝≤‚ ‘æÿ’Û
n=size(AoA,2);
for i=1:n
    Xii=transCol(X,i,n);
    [thetai,Ri]=generateR(AoA,i,n);
    Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
    bi=2*sin(thetai);   
    y=sys_param.target.pos';
    vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;
    sub=vi'*Mi-bi
end

end

