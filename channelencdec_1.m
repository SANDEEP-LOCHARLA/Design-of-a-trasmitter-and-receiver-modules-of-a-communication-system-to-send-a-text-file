function decoder_1 = channelencdec_1(xx,snr)

%%CHANNEL ENCODER
%LINEAR BLOCK CODE
g0=[1 1 0 1 0 0 0];
g1=[0 1 1 0 1 0 0];
g2=[1 1 1 0 0 1 0];
g3=[1 0 1 0 0 0 1];
l=4;
k=1;
V=[];
r=rem(length(xx),4);

u=[];
while k<(length(xx)-r-2)
    for i=k:k+l-1
        u=[u xx(i)];
    end
    v=u(1)*g0+u(2)*g1+u(3)*g2+u(4)*g3;
    v0=rem(v,2);
    V=[V v0];
    u=[];
    k=k+l;
end
if r~=0
vv=zeros(1,4-r);
v1=[vv xx(length(xx)-r+1:length(xx))];
for io=1:4
    u=[u v1(io)];
end
v=u(1)*g0+u(2)*g1+u(3)*g2+u(4)*g3;
v0=rem(v,2);
V=[V v0];
end

%%QPSK MODULATION
%calling for modulation before sending the bits into the channel
re = modulation(V,snr);

%%CHANNEL DECODER
%decoding the bits received directly from the channel
H=[1 0 0 1 0 1 1;0 1 0 1 1 1 0;0 0 1 0 1 1 1];
m=1;
b=[];
oo=H';
dec=[];
while m<length(re)-5
    for u=m:m+6
        b=[b re(u)];
    end
    s1=b*H';
    s=rem(s1,2);
    for f=1:7
        if s==oo(f,1:end)
            if b(f)==0
                b(f)=1;
            else if b(f)==1
                    b(f)=0;
                end
            end
        end
    end
    dec=[dec b];
    b=[];
    m=m+7;
end
decoder_1=[];
ss=1;
while ss<(length(dec)-r-4)
    decoder_1=[decoder_1 dec(ss+3:ss+6)];
    ss=ss+7;
end
if r~=0
    decoder_1=[decoder_1 dec((length(dec)-r+1):length(dec))];
end











