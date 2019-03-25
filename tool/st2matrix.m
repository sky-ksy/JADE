function matrix=st2matrix(virS)
n=length(virS);
matrix=zeros(n,2);
for i=1:n
    matrix(i,:)=virS(i).pos;
end