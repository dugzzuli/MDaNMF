clc;clear;
addpath('./clustering/')
addpath('./tools/')
addpath('./symnmf/')

%% input A: the adjacency matrix
dataSet=load('dataset\handwritten.mat')
truelabel=dataSet.gnd;

gnd=truelabel';
gnd_len=length(gnd);
AData=zeros(gnd_len,gnd_len,2);


kk= floor(log2(gnd_len)) + 1;
nn=7;

AData(:,:,1) =scale_dist3_knn(EuDist2(dataSet.fourier,dataSet.fourier,1),nn,kk,true);

AData(:,:,2)=scale_dist3_knn(EuDist2(dataSet.pixel,dataSet.pixel,1),nn,kk,true);

for loop=1:1
    option.maxiter = 1000;
    option.tolfun = 1e-6;
    option.maxiter_pre = 100;
    option.verbose = 1;
    option.UpdateVi = 0;
    option.lambda = [1,1,1];
    option.kmeans=1;
    K = length(unique(gnd));
    option.K=K;
    layers = [2000,128,option.K]; %% three layers, the last layer corresponds to the number of communities to detect
    p = numel(layers);
    %% Deep AE NMF
    [U{loop}, V{loop},VP{loop}, dnorm{loop}, dnormarray{loop}]=MDaNMF(AData, layers, option);
    Vp = VP{loop}';
    [ac(loop),nmi_value(loop),RI(loop)]=printResult(Vp, gnd', option.K, option.kmeans);
end
mAc=mean(ac);
mNmi=mean(nmi_value);
mRi=mean(RI);
save ./result/handwrite