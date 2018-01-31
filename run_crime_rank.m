%  Estimate CrimeRank
addpath(genpath(pwd));
rng(1);

word='PortlandSTREET'; dt=.00025; Nleafs=100; PAIr1=86.95683693; PAIr2=83.94753617; % PAI PASDA 86.95683693 TAMERZONE 83.94753617
%word='PortlandALL'; dt=.0005; Nleafs=50; PAIr1=60.52651667; PAIr2=59.1736587; PAIr3=58.80171595;% Codilime TAMERZONE PASDA

Nboxes=112;
Niter=50;
Area=382.567144*1000*1000;
cell_area=112*76.2^2;

load(strcat(word,'Xtest_on.mat'));
load(strcat(word,'Ytest_on.mat'));
load(strcat(word,'Xtrain_on.mat'));
load(strcat(word,'Ytrain_on.mat'));
load(strcat(word,'celltest_loc_on.mat'));
load(strcat(word,'total_test_crime.mat'));

Ndays=max(size(Xtrain_on));
for i=1:Ndays
    Ytrain_on{i}=Ytrain_on{i}(Xtrain_on{i}(:,5)>.01);
    Xtrain_on{i}=Xtrain_on{i}(Xtrain_on{i}(:,5)>.01,:);
end

S={};
for i=1:max(size(Ytrain_on))
    S{i}=randn(size(Ytrain_on{i}));
    
end
St={};
for i=1:max(size(Ytest_on))
    St{i}=randn(size(Ytest_on{i}));
    
end


Ndays_test=max(size(Xtest_on));
PAI=zeros(Niter,1);
PAItrain=zeros(Niter,1);


N1=zeros(Ndays,1);
for i=1:Ndays
    N1(i)=size(Ytrain_on{i},1);
end

lambda_days=S;

XTR=zeros(sum(N1),size(Xtrain_on{1},2));
YTR=zeros(sum(N1),1);
XTR(1:N1(1),:)=Xtrain_on{1};
YTR(1:N1(1))=Ytrain_on{1};
for i=2:Ndays
    istart=sum(N1(1:i-1))+1;
    iend=sum(N1(1:i));
    XTR(istart:iend,:)=Xtrain_on{i};
    YTR(istart:iend)=Ytrain_on{i};
end
lambda=zeros(sum(N1),1);

for i=1:Niter
    
    parfor j=1:Ndays
        lambda_days{j}=grad_calc_on(Ytrain_on{j},S{j},Nboxes);
    end
    
    lambda(1:N1(1))=lambda_days{1};
    for j=2:Ndays
    istart=sum(N1(1:j-1))+1;
    iend=sum(N1(1:j));
    lambda(istart:iend)=lambda_days{j};
    end
    
    index=randsample(sum(N1),ceil(sum(N1)/4),false);
    
    trees=RegressionTree.fit(XTR(index,:),lambda(index),'MinLeaf',Nleafs,'Prune','off');
    
    for j=1:Ndays
        S{j}=S{j}+dt*predict(trees,Xtrain_on{j});
    end
    
    for j=1:Ndays_test
        St{j}=St{j}+dt*predict(trees,Xtest_on{j});
    end

  
    [PAIt,~,~]=PAI_error(Ytrain_on,S,Nboxes);
    PAItrain(i)=PAIt/(cell_area/Area);
    [PAIt,~,~,top_locations]=PAI_error_off(Ytest_on,St,Nboxes,celltest_loc_on,total_test_crime);
    PAI(i)=PAIt/(cell_area/Area);

    
    plot([1:i],PAItrain(1:i),[1:i],PAI(1:i),'g',[1:i],ones(i,1)*PAIr1,'r',[1:i],ones(i,1)*PAIr2,'k');
    
    drawnow;
    
    
end



subplot(1,2,1)
plot([1:i],PAItrain(1:i),[1:i],PAI(1:i),'g',[1:i],ones(i,1)*PAIr1,'r',[1:i],ones(i,1)*PAIr2,'k');
subplot(1,2,2);
hold on
plot(long,lat,'.k');
for zz=1:112
    plot(top_locations{zz}([1 2 3 4 1],2),top_locations{zz}([1 2 3 4 1],1),'r','LineWidth',2);
end
hold off
drawnow;

