clc;clear;
addpath('./clustering/')
addpath('./tools/')
addpath('./symnmf/')

%% input A: the adjacency matrix
dataSet=load('dataset\WebKB.mat')
data=dataSet.data;
truelabel=dataSet.truelabel;
gnd=truelabel{1};
gnd_len=length(gnd);
AData=zeros(gnd_len,gnd_len,length(data));
kk= floor(log2(gnd_len)) + 1;
nn=7;

lambdas=[1000,100,10,1,0.1,0.01,0.001];

for i = 1:length(data)
%     options=[];
%     options.WeightMode='Cosine';
%     Ws{i}=constructW_cai(data{i}',options);
    data{i} = data{i} / sum(sum(data{i}));
end
for i = 1:length(data)
    KK=scale_dist3_knn(dist2(data{i}',data{i}'),nn,kk,true);
    AData(:,:,i) = replaceNAN(KK);
end

for loop=1:1
    for l_i=1:length(lambdas)
        option.maxiter = 1000;
        option.tolfun = 1e-6;
        option.maxiter_pre = 500;
        option.verbose = 1;
        option.UpdateVi = 1;
%         option.lambda =[1000,1000,1000];
        option.lambda = [lambdas(l_i),lambdas(l_i),lambdas(l_i)];
        option.kmeans=1;
        K = length(unique(gnd));
        option.K=K;
         layers = [169,96,option.K]; 
%         layers = [169,32,option.K]; % 0.7241	
%         layers = [128,64,option.K]; %% three layers, the last layer corresponds to the number of communities to detect
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
save ./result/WebKB1
