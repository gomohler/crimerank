
word='PortlandSTREET'; % PAI PASDA 86.95683693 TAMERZONE 83.94753617
%word='PortlandALL'; % PAI Codilime 60.52651667	PASDA 58.80171595	TAMERZONE 59.1736587

data = fopen('portland_street.csv', 'rt');
%data = fopen('portland_all.csv', 'rt');
a = textscan(data, '%s %f %f %s', ...
      'Delimiter',',', 'HeaderLines',1);
fclose(data);

rng(1);

date=a{1};
lat=a{2};
long=a{3};
type=a{4};



date_num=datenum(date);
[year, mnth, day, hr, mn, sec]=datevec(date_num);
date_mnth=mnth;
date_day=day;

latmax=max(lat);
latmin=min(lat);
longmax=max(long);
longmin=min(long);



cell_size=76.2;


train_start_date=datenum('03/01/2013');
train_end_date=datenum('05/31/2016');
test_start_date=datenum('03/01/2017');
test_end_date=datenum('5/31/2017');

[cell_locations]=setup_grid_latlong_train(latmax,latmin,longmax,longmin,cell_size);
[cell_locations_test]=setup_grid_latlong(lat(date_num<test_start_date),long(date_num<test_start_date),latmax,latmin,longmax,longmin,cell_size);


                                     
Xtrain_on=[];
Ytrain_on=[];

j=0;                                     
for i=train_start_date:30:train_end_date
%for i=train_start_date:train_start_date
j=j+1;
[year, mnth, day, hr, mn, sec]=datevec(i);
    

[target_on]=cell_crime_counts(cell_locations,i,i+90,...
                                         lat,long,date_num);

                                     

[var1_on]=cell_crime_counts(cell_locations,i-7,i,...
                                         lat,long,date_num);

                                     
 % 2nd variable is crime in last 90 days
[var2_on]=cell_crime_counts(cell_locations,i-30,i,...
                                         lat,long,date_num);

                                     
 % Third variable is crime in last 90 days
[var3_on]=cell_crime_counts(cell_locations,i-90,i,...
                                         lat,long,date_num);

                                     
 % Fourth variable is crime in last year
[var4_on]=cell_crime_counts(cell_locations,i-365,i,...
                                         lat,long,date_num);

                                     
 % Fifth variable is crime in last 2 year
[var5_on]=cell_crime_counts(cell_locations,i-10*365,i,...
                                         lat,long,date_num);

var5_on=var5_on/max(var5_on);

                                                                                                       
Xtrain_on{j}=[var1_on var2_on var3_on var4_on var5_on];




Ytrain_on{j}=target_on;


[j size(Xtrain_on{j},1)]


end
    
save(strcat(word,'Xtrain_on.mat'),'Xtrain_on','-v7.3');
save(strcat(word,'Ytrain_on.mat'),'Ytrain_on','-v7.3');



Xtest_on=[];
Ytest_on=[];

celltest_loc_on=[];                             
i=test_start_date;
[year, mnth, day, hr, mn, sec]=datevec(i);
j=1;
    
[target_on]=cell_crime_counts(cell_locations_test,i,i+95,...
                                         lat,long,date_num);

                                     

[var1_on]=cell_crime_counts(cell_locations_test,i-7,i,...
                                         lat,long,date_num);

                                     
 % 2nd variable is crime in last 90 days
[var2_on]=cell_crime_counts(cell_locations_test,i-30,i,...
                                         lat,long,date_num);

                                     
 % Third variable is crime in last 90 days
[var3_on]=cell_crime_counts(cell_locations_test,i-90,i,...
                                         lat,long,date_num);

                                     
 % Fourth variable is crime in last year
[var4_on]=cell_crime_counts(cell_locations_test,i-365,i,...
                                         lat,long,date_num);

                                     
 % Fifth variable is crime in last 2 year
[var5_on]=cell_crime_counts(cell_locations_test,i-10*365,i,...
                                         lat,long,date_num);

var5_on=var5_on/max(var5_on);

                                                                                                       
Xtest_on{j}=[var1_on var2_on var3_on var4_on var5_on];


j=1;
Ytest_on{j}=target_on;
celltest_loc_on{j}=cell_locations_test;
S=[];
S{1}=var5_on;


[j size(Xtest_on{j},1)]


total_test_crime=sum(date_num>test_start_date);

save(strcat(word,'total_test_crime.mat'),'total_test_crime','-v7.3');
save(strcat(word,'Xtest_on.mat'),'Xtest_on','-v7.3');
save(strcat(word,'Ytest_on.mat'),'Ytest_on','-v7.3');
save(strcat(word,'celltest_loc_on.mat'),'celltest_loc_on','-v7.3');




