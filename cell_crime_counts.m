function [cell_counts]=cell_crime_counts(cell_locations,start_date,end_date,...
                                         crimelat,crimelong,crimetime)
N=max(size(cell_locations));                        
cell_counts=zeros(N,1);

c=[crimelat crimelong crimetime];
index=c(:,3)>=start_date&c(:,3)<end_date;
c=c(index,:);


for i=1:N
cell_counts(i)=sum(inpolygon(c(:,1),c(:,2),cell_locations{i}(:,1),cell_locations{i}(:,2)));
end
end