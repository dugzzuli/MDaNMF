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


kk= 100;
nn= floor(log2(2000)) + 1;

AData(:,:,1) =scale_dist3_knn(EuDist2(dataSet.fourier,dataSet.fourier,1),nn,kk,true);

AData(:,:,2)=scale_dist3_knn(EuDist2(dataSet.pixel,dataSet.pixel,1),nn,kk,true);

lambdas=[0.001];
for loop=1:1
    for l_i=1:length(lambdas)
        option.maxiter = 1000;
        option.tolfun = 1e-10;
        option.maxiter_pre = 100;
        option.verbose = 1;
        option.UpdateVi = 1;
        option.lambda = [lambdas(l_i),lambdas(l_i)];
        option.kmeans=1;
        K = length(unique(gnd));
        option.K=K;
        option.gnd=gnd;
        layers = [option.K]; %% three layers, the last layer corresponds to the number of communities to detect
        p = numel(layers);
        %% Deep AE NMF
        [U{loop,l_i}, V{loop,l_i},VP{loop,l_i}, dnorm{loop,l_i}, dnormarray{loop,l_i}]=MDaNMF_A(AData, layers, option);
        Vp = VP{loop,l_i}';
        [ac(loop,l_i),nmi_value(loop,l_i),RI(loop,l_i)]=printResult(Vp, gnd', option.K, option.kmeans);
    end
    
end
% mAc=mean(ac);
% mNmi=mean(nmi_value);
% mRi=mean(RI);
save ./result/handwrite