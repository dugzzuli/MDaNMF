clc;clear;
addpath('./clustering/')
addpath('./tools/')
addpath('./symnmf/')

xp = -4.4;
gamma = 10^xp;

%% input A: the adjacency matrix
dataSet=load('dataset\WebKB.mat')
data=dataSet.data;
truelabel=dataSet.truelabel;
gnd=truelabel{1};
gnd_len=length(gnd);
AData=zeros(gnd_len,gnd_len,length(data));
kk= floor(log2(gnd_len)) + 1;
nn=7;

lambdas=[0.001,0.01,0.1,1,10100,1000];

for i = 1:length(data)
    options=[];
    options.WeightMode='Cosine';
    Ws{i}=constructW_cai(data{i}',options);
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
        option.lambda = [lambdas(l_i),lambdas(l_i),lambdas(l_i)];
        option.kmeans=1;
        K = length(unique(gnd));
        option.K=K;
        layers = [169,96,option.K];
        p = numel(layers);
        %% Deep AE NMF
        J_old = 1; J_new = 10; EPS = 1e-3;
        alpha=[1,1,1]';
        while abs((J_new - J_old)/J_old) > EPS
            [U{loop,l_i}, V{loop,l_i},VP{loop,l_i}, dnorm{loop,l_i},Obj_LCCF, dnormarray{loop,l_i}]=MDaNMF_A_a(AData, layers, option,alpha);
            alpha = EProjSimplex_new(-Obj_LCCF/(2*gamma), 1);
            J_old = J_new;
            J_new = alpha'*Obj_LCCF + gamma*(alpha'*alpha);
        end
        Vp = VP{loop,l_i}';
        [ac(loop,l_i),nmi_value(loop,l_i),RI(loop,l_i)]=printResult(Vp, gnd', option.K, option.kmeans);
    end
    
end

mAc=mean(ac);
mNmi=mean(nmi_value);
mRi=mean(RI);
save ./result/WebKB1
