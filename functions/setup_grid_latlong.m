function [cell_locations]=setup_grid_latlong(lat,long,lat_up,lat_down,long_up,long_down,cell_size)

% This function takes in lat long bounds (for a district or city) 
% and a cell_size in meters and returns an array of cell 
% bounding boxes i.e. four columns latmax, latmin,longmax, longmin
% for overlapping grid cells (cells are shifted by cell_size/10 m in each direction)

if(max(size(lat))<10000)
else
index=randsample(max(size(lat)),10000,false);
lat=lat(index);
long=long(index);
end
A=unique([lat long],'rows');
lat=A(:,1);
long=A(:,2);


dkx=haversine([lat_up long_down], [lat_down long_down]); 

dky=haversine([lat_up long_up], [lat_up long_down]); 



Mx = ceil(1000*dkx/(cell_size));
My = ceil(1000*dky/(cell_size));


DX=(lat_up-lat_down)/Mx;
DY=(long_up-long_down)/My;

N=max(size(lat));


DX2=DX*2;
DY2=DY/2;

cell_polygons=[];

k=0;
for i=1:N
  
           k=k+1;
        z2=lat(i)-DX/2;
        z1=z2+DX;
        z4=long(i)-DY/2;
        z3=z4+DY;
        
    V1=[z1 z2 z2 z1];
    V2=[z3 z3 z4 z4];
    cell_polygons{k}=[V1' V2'];
    
       
        z2=lat(i)-DX2/2;
        z1=z2+DX2;
        z4=long(i)-DY2/2;
        z3=z4+DY2;
        
    V1=[z1 z2 z2 z1];
    V2=[z3 z3 z4 z4];
     k=k+1;
    poly_rot=rotate(polyshape(V1,V2),45,[lat(i) long(i)]);
   cell_polygons{k}=poly_rot.Vertices;
   
    k=k+1;
    poly_rot=rotate(polyshape(V1,V2),135,[lat(i) long(i)]);
   cell_polygons{k}=poly_rot.Vertices;
   
    k=k+1;
    poly_rot=rotate(polyshape(V1,V2),0,[lat(i) long(i)]);
   cell_polygons{k}=poly_rot.Vertices;
   
   k=k+1;
    poly_rot=rotate(polyshape(V1,V2),90,[lat(i) long(i)]);
   cell_polygons{k}=poly_rot.Vertices;
   
   
%    for j=1:20
%        k=k+1;
%        x=lat(i)+randn()*DX2*2;
%        y=long(i)+randn()*DX2*2;
%        theta=365*rand();
%        
%        z2=x-DX2/2;
%         z1=z2+DX2;
%         z4=y-DY2/2;
%         z3=z4+DY2;
%         
%         V1=[z1 z2 z2 z1];
%         V2=[z3 z3 z4 z4];
%         poly_rot=rotate(polyshape(V1,V2),theta,[x y]);
%         cell_polygons{k}=poly_rot.Vertices;      
%    end
   
end
cell_locations=cell_polygons;

end
