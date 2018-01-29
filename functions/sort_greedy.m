function [top_locations top_indices]=sort_greedy(cell_locations,S,cutoff)

% This function takes as input (possibly over lapping) cell locations 
% (an array with each row representing four corners of a cell) and a score for each
% cell and returns the top K=cutoff cells (ranked by S), but such that they
% don't overlap

N=max(size(cell_locations));

cell_temp=cell_locations;

[cellsorted cellindex]=sort(S,'descend');
cell_locations=cell_locations(cellindex(1:N));
S=S(cellindex(1:N));

cell_locations2=[];

cell_locations2{1}=cell_locations{1};
count=1;
j=1;
while(count<cutoff)
   output=ones(count,1);
   while(max(output)==1)
       j=j+1;
       for i=1:count

           output(i)=check_intersection(cell_locations2{i},cell_locations{j});
           if(output(i)==1)
               break
           end
       end
    
   end
   count=count+1;
   cell_locations2{count}=cell_locations{j};
 
end
top_locations=cell_locations2;


c1=zeros(max(size(cell_temp)),8);
c2=zeros(max(size(top_locations)),8);

for i=1:max(size(cell_temp))
    c1(i,:)=[cell_temp{i}(:,1)' cell_temp{i}(:,2)'];
end
for i=1:max(size(top_locations))
    c2(i,:)=[top_locations{i}(:,1)' top_locations{i}(:,2)'];
end


top_indices=find(ismember(c1,c2,'rows'));

end



function output=check_intersection(box1,box2)
poly1=polyshape(box1(:,1),box1(:,2));
poly2=polyshape(box2(:,1),box2(:,2));
output=area(intersect(poly1,poly2));
if(output>0)
    output=1;
end

end