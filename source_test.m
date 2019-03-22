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
lambdas=[1000,100,10,1,0.1,0.01,0.001];
for loop=1:20
    for l_i=1:length(lambdas)
        option.maxiter = 1000;
        option.tolfun = 1e-6;
        option.maxiter_pre = 500;
        option.verbose = 1;
        option.UpdateVi = 0;
         option.lambda = [lambdas(l_i),lambdas(l_i),lambdas(l_i)];
        option.kmeans=1;
        K = length(unique(gnd));
        option.K=K;
        layers = [169,128,option.K]; %% three layers, the last layer corresponds to the number of communities to detect
        p = numel(layers);
        %% Deep AE NMF
        [U{loop,l_i}, V{loop,l_i},VP{loop,l_i}, dnorm{loop,l_i}, dnormarray{loop,l_i}]=MDaNMF_A(AData, layers, option);
        Vp = VP{loop,l_i}';
        [ac(loop,l_i),nmi_value(loop,l_i),RI(loop,l_i)]=printResult(Vp, gnd', option.K, option.kmeans);
    end
end
mAc=mean(ac);
mNmi=mean(nmi_value);
mRi=mean(RI);
save ./finalresult/3sourceResult