function st=flipStruct(st)
%处理结构体中的数据

% matVirS=st.matVirS;
% mPos=flip(cat(1,matVirS.pos));
% cPos=num2cell(mPos,2);
% [matVirS(1:end).pos]=deal(cPos{1:end});
% st.matVirS=matVirS;

st.uId=flip(st.uId);
st.matAoA=flip(st.matAoA);
st.matRSS=flip(st.matRSS);