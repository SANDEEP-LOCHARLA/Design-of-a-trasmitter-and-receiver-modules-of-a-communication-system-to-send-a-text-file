function rec = modulation(r,snr)

%%QPSK MODULATION
num = length(r);
f=1;
tp=1/f;
rr=zeros(1,num*0.5*1000);
m=1;
k=1;
while m<length(r)
        if r(m)==0
            if r(m+1)==0
               for t=0:0.001:0.999
                   rr(k)=sin((2*pi*f*t)+(pi/4));
                   k=k+1;
               end
            else
               for t=0:0.001:0.999
                   rr(k)=sin((2*pi*f*t)+(3*pi/4));
                   k=k+1;
               end 
            end
        else 
            if r(m+1)==0
                for t=0:0.001:0.999
                    rr(k)=sin((2*pi*f*t)+(5*pi/4));
                    k=k+1;
                end
            else
                for t=0:0.001:0.999
                    rr(k) =sin((2*pi*f*t)+(7*pi/4));
                    k=k+1;
                end
            end
        end
        if m==length(r)
        rr(k)=r(m)*sin(2*pi*f*1);
        end
     m=m+2;
end

%%Passing through an AWGN channel
%receiver with noise
phi_1 = zeros(1,1000);
phi_2 = zeros(1,1000);
a=1;
for t1=0:0.001:0.999
     phi_1(a) = (2/tp)^0.5* cos(2*pi*f*t1);
     phi_2(a) = (2/tp)^0.5* sin(2*pi*f*t1);
    a = a + 1;
end

N=1000;
Pe = 0;
u=1;
iter=1;
while iter<11
    u=1;
% for snr=-50:20
y=awgn(rr,snr-10*log10(N/2),'measured');
l = 1;
f = 1;
rec=zeros(1,num);
while l<length(y)
    sum1 = y(l:l+999)*phi_1';
    sum2 = y(l:l+999)*phi_2';
    if sum1 > 0 
        if sum2 > 0
            rec(f) = 0;
            rec(f+1) = 0;
        else 
            rec(f) = 0;
            rec(f+1) = 1;
        end
    else
        if sum2 > 0
            rec(f) = 1;
            rec(f+1) = 1;
        else
            rec(f) = 1;
            rec(f+1) = 0;
        end
    end
    f = f + 2;
    l = l + 1000;
end
err=r-rec;
e1=0;
for p=1:length(err)
    if err(p)~=0
        e1=e1+1;
    end
end
Pe=Pe+(e1/num);
u=u+1;
iter=iter+1;
end

Pe=Pe/40;
disp(Pe)


