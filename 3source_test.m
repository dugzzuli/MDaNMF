clc;clear;
addpath('./clustering/')
addpath('./tools/')
addpath('./symnmf/')

%% input A: the adjacency matrix
dataSet=load('dataset\3sources.mat')
data=dataSet.data;
truelabel=dataSet.truelabel;
gnd=truelabel{1};
gnd_len=length(gnd);
AData=zeros(gnd_len,gnd_len,length(data));
kk= floor(log2(gnd_len)) + 1;
nn=7;
for i = 1:length(data)
    KK=scale_dist3_knn(pdist2(data{i}',data{i}','cosine'),nn,kk,true);
    AData(:,:,i) = KK;
end
for loop=1:20
    option.maxiter = 1000;
    option.tolfun = 1e-6;
    option.maxiter_pre = 500;
    option.verbose = 1;
    option.UpdateVi = 0;
    option.lambda = [1,1,1];
    option.kmeans=1;
    K = length(unique(gnd));
    option.K=K;
    layers = [169,128,option.K]; %% three layers, the last layer corresponds to the number of communities to detect
    p = numel(layers);
    %% Deep AE NMF
    [U{i}, V{i},VP{i}, dnorm{i}, dnormarray{loop}]=MDaNMF(AData, layers, option);
    Vp = VP{i}';
    [ac(loop),nmi_value(loop),RI(loop)]=printResult(Vp, gnd', option.K, option.kmeans);
end
mAc=mean(ac);
mNmi=mean(nmi_value);
mRi=mean(RI);
save ./result/3sourceResult