function [cell_polygons]=setup_grid_latlong_train(lat_up,lat_down,long_up,long_down,cell_size)


dkx=haversine([lat_up long_down], [lat_down long_down]); 

dky=haversine([lat_up long_up], [lat_up long_down]); 



Mx = ceil(1000*dkx/(cell_size));
My = ceil(1000*dky/(cell_size));


DX=(lat_up-lat_down)/Mx;
DY=(long_up-long_down)/My;

cell_polygons=[];

k=0;
for i=1:Mx
    for j=1:My
        k=k+1;
        
        z2=lat_down+(i-1)*(lat_up-lat_down)/Mx;
        z1=z2+DX;
        z4=long_down+(j-1)*(long_up-long_down)/My;
        z3=z4+DY;
        
        V1=[z1 z2 z2 z1];
        V2=[z3 z3 z4 z4];
        cell_polygons{k}=[V1' V2'];
        
    end
end


end
