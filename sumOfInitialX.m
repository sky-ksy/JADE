function [ s ] = sumOfInitialX( jade_param,X,ix,x0,y0 )
s=0;  %����Xiλ�õ�Ŀ�귽�̵�ֵ
t=jade_param.t;
for i=1:t
    %for im=[1,2,ix]  %���ۼ�
    for im=1:ix %ѡȡ��1����ix���ڵ��е�һ����Ϊ�����Ľڵ㡱�����Ľڵ�Ϊ�����е�Xi���������Xj��
        Xim=transCol(X,im,ix);%Xim=��Xj-Xi��  2*(ix-1)�ľ���
        %[theta,Rim]=generate_R(jade_param.AoA,im,ix);%��ȡ����ǶȲ����theta��1*(ix-1)��������ת����Rim��2��*2��*(ix-1)ҳ
        [theta,Rim]=generateR(jade_param.MatAoA(i,:),im,ix); %�������������У�i,t����
        Mim=squeeze(sum(Rim .* shiftdim(Xim, -1), 2)); %Rim��ÿҳ��Xim��ÿ�зֱ�������˻����õ�Mim��2*(ix-1)
        wim=Mim(1,:)'; %Mim�ĵ�1��
        zim=Mim(2,:)'; %Mim�ĵ�2��
        if(isIndep(Mim,jade_param.equ)) %Mim�����������޹صĻ�
            %if(rank(Mim)==2)   %����s�����NaN�Ľ��
            s=s+indep(wim,zim,theta); %�������Xiλ�õ�Ŀ�귽�̵�ֵ
        else %Mim������������صĻ�
            %fprintf('ix=%d,x0=%f,y0=%f\n',ix,x0,y0);
            s=s+dep(wim,zim,theta);
            Mim;  %����������ص�Mim
        end
        if isnan(s)
            fprintf(2,'NaN t=%d,ix=%f,x0=%f,y0=%f',t,ix,x0,y0);
            Mim
            2*sin(theta)            
        end
    end
end

