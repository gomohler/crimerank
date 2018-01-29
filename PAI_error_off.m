function [PAI Ncrimes ys top_locations]=PAI_error_off(y,S,Rank,cell_locations,sumY)
Ndays=max(size(y));
E=zeros(Ndays,1);
Crime=zeros(Ndays,1);
yavg=zeros(Rank,1);

for i=1:Ndays
   [top_locations top_indices]=sort_greedy(cell_locations{i},S{i},Rank);
   ys=y{i}(top_indices);
   yavg=yavg+ys(1:Rank)/Rank;
   E(i)=sum(y{i}(top_indices));
   %Crime(i)=sum(y{i});
   Crime(i)=sumY(i);

    
end
PAI=sum(E)/sum(Crime);
Ncrimes=sum(E);
ys=sort(yavg,'descend');

end
