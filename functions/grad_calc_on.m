function [lambda]=grad_calc_on(y,S,num_boxes)
N=max(size(y));
lambda=zeros(size(y));
in_or_out=zeros(N,1);


[Ss index]=sort(S,'descend');
[blah index2]=sort(index);
index=index2;

for i=1:N
    if(index(i)<=num_boxes)
        in_or_out(i)=1;
    end
end


for i=1:N
    for j=i+1:N
       if(y(i)~=y(j))&&(in_or_out(i)~=in_or_out(j))
       DZ=y(i)-y(j);
     
           if(y(i)>y(j))
               rho=1/(1+exp(S(i)-S(j)));
               lambda(i)=lambda(i)+rho*abs(DZ);
               lambda(j)=lambda(j)-rho*abs(DZ);
           else
               rho=1/(1+exp(S(j)-S(i)));
               lambda(i)=lambda(i)-rho*abs(DZ);
               lambda(j)=lambda(j)+rho*abs(DZ);
           end
       end
    end
end

end