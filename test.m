clc;clear;
addpath('./clustering/')
addpath('./tools/')
addpath('./symnmf/')

%% input A: the adjacency matrix
dataSet=load('dataset\3sources.mat')
data=dataSet.data;
truelabel=dataSet.truelabel;
gnd=truelabel{1};
AData=zeros(169,169,3);

nn= floor(log2(169)) + 1;
for i = 1:length(data)
        KK=scale_dist3_knn(pdist2(data{i}',data{i}','cosine'),7,nn,true);
    AData(:,:,i) = KK;
end

option.maxiter = 1000;
option.tolfun = 1e-6;
option.maxiter_pre = 500;
option.verbose = 1;
option.UpdateVi = 1;
option.lambda = [1,1,1];
option.kmeans=1;
K = length(unique(gnd));

option.K=K;





layers = [169,128,option.K]; %% three layers, the last layer corresponds to the number of communities to detect

p = numel(layers);


%% Deep AE NMF
[U, V,VP, dnorm, dnormarray]=MDaNMF(AData, layers, option);

Vp = VP';

[ac,nmi_value,RI]=printResult( Vp, gnd', option.K, option.kmeans);
