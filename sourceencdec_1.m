
%%===============ADV DIGITAL COMMUNICATION PROJECT===================%%
%% There are 3 files in this project:
%%  1. Source encoder & decoder  - Huffman coding is used
%   2. Channel encoder & decoder - Linear block coding is used
%   3. Modulation                - QPSK modulation is used
%% The flow of the program:
%  reading 'text.txt'-->source encoder in 'sourceencdec_1'-->
%-->channel encoder in 'channelencdec_1'-->QPSK modulation in 'modulation'-->
%-->channel decoder in 'channelencdec_1'-->source decoder in 'sourceencdec_1'


clc;
clear all;
close all;
dict=32:127;
%%Reading the text file
fileID = fopen('test.txt','r');
data=fread(fileID);
dat=data';
fclose(fileID);
snr = input('enter the snr:');
%%SOURCE ENCODING--HUFFMAN CODING 
% for iteration = 1:10
%     disp(iteration)
    a=[];
    cod=[];
    co=[];
    count=0;
    for i=1:length(dict)
        for j=1:length(dat)
            if dict(i)==dat(j)
                count=count+1;
            end
        end
        co=[co count];
        count=0;
    end
    a=[];
    co1=[];
    for i=1:length(co)
        if co(i)~=0
            a=[a dict(i)];
            co1=[co1 co(i)];
        end
    end
    p=co1/length(dat);
    proba=p;
    code=[];
    codebook={length(a),2};
    ty=0;
    w=length(p);
    clen=[];
    u=1;

   for m=1:length(p)
       for n=1:length(p)
           if(p(m)>p(n))
             aa=p(n);  aa1=a(n);
             p(n)=p(m);a(n)=a(m);  
             p(m)=aa;   a(m)=aa1;
           end
       end
   end

   q=w;
   while q~=0
       d=[];
       for i=1:w-1    
           if p(i+1)== p(i)
              d=[d,i];
           end
       end
       q=length(d);
       for i=1:q
           o=d(i);
           p(o);
           p(o)=p(o)+10^-5*d(i);
       end
   end
   i=1;
   p=sort(p,'descend');
   %%codebook formation
   bb=p;
   q=[0];
   su=[];
   w=length(p);
   l=[w];
   b(i,:)=p;
   while(length(p)>2) 
       r=p(length(p))+p(length(p)-1);
       for f=1:length(p)
           if b(1,f)==r
              r=r-10^-8;
           end
       end
       su=[su,r];
       p=[p(1:length(p)-2),r];
       p=sort(p,'descend');
       i=i+1;
       b(i,:)=[p,zeros(1,w-length(p))];
       w1=0;
       l=[l,length(p)];
 
       for temp=1:length(p) 
           if p(temp)==r;
              w1=temp;
           end
       end
       q=[w1,q];
   end
   sizeb(1:2)=size(b);
   td=0;
   t2=[]; 
   for i= 1:sizeb(2)   
       t2=[t2,b(1,i)];
   end 
   su=[0,su];
   var=[];
   e=1;
   cd=1;
   for ifinal= 1:sizeb(2)
       c=[];
       for j=1:sizeb(1) 
           td=0; 
           for i1=1:sizeb(2) 
               if( b(j,i1)==t2(e))  
                 td=b(j,i1);     
               end
               if(td==0 & b(j,i1)==su(j))
                 td=b(j,i1);
               end
           end
           var=[var,td];
           if td==b(j,l(j)) 
              c=['1',c]; 
           elseif td==b(j,l(j)-1)
              c=['0',c];
           else
              c=['',c];
           end 
           t2(e)=td;  
       end  
       clen=[clen length(c)];
       codebook{cd,2}=strcat(c(1:length(c)));
       codebook{cd,1}=a(cd);
       cd=cd+1;
       e=e+1;
  end
 codets=[];
 zz=0;
for i=1:length(codebook)
    zz=dec2bin(codebook{i,1},8);
    codets=[codets zz];
end
ja=[];
for i=1:length(clen)
    mr=dec2bin(clen(i),5);
    ja=[ja mr];
    mr=[];
end
cd1=[];
for i=1:length(codebook)
    cd1=[cd1 codebook{i,2}];
end
%%encoding the text file according to the codebook
encode_1=[];
lc=[];
san= 0;
for i=1:length(dat)
        for k=1:46
            if dat(i)==codebook{k,1}
                lc=[lc length(codebook{k,2})];
                encode_1=[encode_1 codebook{k,2}];
            end
        end
end
lc1=[];
for i=1:length(lc)
lc1=[lc1 dec2bin(lc(i),5)];
end
enlen=length(encode_1);
encode_2 = (encode_1);
compression=(length(dat)*8)/enlen

%%CHANNEL CODING
%calling for channel encoding & decoding 
encode = channelencdec_1(encode_2,snr);


%%SOURCE DECODER
%decoding the bits received from the channel decoder
codebook1={length(codets)/8,2};
k=[];
d2=[];
n=1;
for i=n:length(codets)
    if n<length(codets)
    k=strcat(k,codets(n:n+7));
    d1=bin2dec(k);
    d2=[d2 d1];
    n=n+8;
    k=[];
    end
end
for i=1:length(d2)
    codebook1{i,1}=d2(i);
end

jaa=ja;
js=[];
jj=[];
mn=1;
while (length(ja)~=0)
    jj=ja(1:5);
    jk=bin2dec(jj);
    ja=ja(6:end);
    js=[js jk];
end
cdd1=cd1;
cs=1;
nn=[];
while (length(cd1)~=0)
    nn=cd1(1:js(cs));
    codebook1{cs,2}=nn;
    cd1=cd1(js(cs)+1:end);
    cs=cs+1;
end
lcc=lc1;
lo=[];
lc2=[];
while (length(lc1)~=0)
    lo=lc1(1:5);
    kl=bin2dec(lo);
    lc1=lc1(6:end);
    lc2=[lc2 kl];
end

encoder=[];
for kj=1:length(encode)
    encoder = [encoder num2str(encode(kj))];
end
decoder=zeros(length(dat),1);
pp=1;
bc=1;
k1=[];
for i=1:length(dat)
    %display(i)
    bc=1;
    k1=encoder(1:lc2(pp));
    a=9;
    while a~=10
        if bc < 47
            if strcmp(k1,codebook1{bc,2})==1
               decoder(i)=codebook1{bc,1};
               a=10;        
               encoder=encoder(lc2(pp)+1:end);
               pp=pp+1;
            else bc=bc+1;
            end
        else
           
            assign_1 = [];
            count = [];
            for m = 1:length(codebook1)
                if length(k1)==length(codebook1{m,2})
                     count_1 = 0;
                    assign_1=[assign_1 m];
                    for s=1:length(k1)
                        if k1(s)~=codebook1{m,2}(s)
                            count_1=count_1+1;
                        end
                    end
                    count = [count count_1];
                end
            end
            [y,ind] = min(count);
            decoder(i) = codebook1{assign_1(ind),1};
            a = 10;
            encoder=encoder(lc2(pp)+1:end);
            pp=pp+1;
        end
     end                     
end
%copp = zeros(1,10);
copp = 0;
say = dat-decoder';
for p=1:length(dat)
    if say(p)~=0
%         copp(iteration) = copp(iteration) + 1;
          copp = copp + 1;
    end
end
% end
% disp(mean(copp))
disp(copp)
disp(char(decoder)')







