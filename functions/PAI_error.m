function [PAI Ncrimes ys]=PAI_error(y,S,Rank)
Ndays=max(size(y));
E=zeros(Ndays,1);
Crime=zeros(Ndays,1);
yavg=zeros(Rank,1);

for i=1:Ndays
   
   [xs index]=sort(S{i},'descend');
   ys=y{i};
   ys=ys(index);
   yavg=yavg+ys(1:Rank)/Rank;
   E(i)=sum(ys(1:Rank));
   Crime(i)=sum(ys);

    
end
PAI=sum(E)/sum(Crime);

Ncrimes=sum(E);
ys=sort(yavg,'descend');

end