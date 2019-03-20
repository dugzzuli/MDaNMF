function [U, V,VP, dnorm,Obj_LCCF, dnormarray] = MDaNMF(A, layers, option,alpha)

%%%%%%%%%%%%%%%%%%%%
% A: n x n x v
% layers: layer size array
% option: maxiter, tolfun, maxiter_pre, verbose, UpdateVi
%%%%%%%%%%%%%%%%%%%%
maxiter = option.maxiter;
tolfun = option.tolfun;
maxiter_pre = option.maxiter_pre;
verbose = option.verbose;
UpdateVi = option.UpdateVi;
lambda = option.lambda;

dnormarray = zeros(maxiter,1);

p = numel(layers);
[xx yy zz]=size(A);
U = cell(zz, p);
V = cell(zz, p);
alpha=[1,1,1]';
xp = -4.4;
gamma = 10^xp;
%%%%%%%%%%%%%%%%%%%%
% Pre-training
%%%%%%%%%%%%%%%%%%%%
for i_view=1:zz
    A_V=A(:,:,i_view);
    for i_layer = 1:p
        
        if i_layer == 1
            Z = A_V;
        else
            Z = V{i_view,i_layer - 1};
        end
        if verbose
            display(sprintf('Initialising Layer #%d ...View#%d...', i_layer,i_view));
        end
        [U{i_view,i_layer}, V{i_view,i_layer}, ~] = ShallowNMF(Z, layers(i_layer), maxiter_pre, tolfun);
        
        if verbose
            display('Finishing initialization ...');
        end
        
    end
    
end
VP=V{end,end};
for i_view=2:zz
    VP=VP+V{i_view,end};
end
VP=VP/zz;
%%%%%%%%%%%%%%%%%%%%
% Fine-tuning
%%%%%%%%%%%%%%%%%%%%

if verbose
    display('Fine-tuning ...');
end

% \Psi -> P; \Phi -> Q; \Pi -> R

Q = cell(zz, p + 1);
P=cell(zz,1);
for i_view=1:zz %视图循环
    D{i_view} = diag(sum(A(:,:,i_view)*alpha(i_view)));
    L{i_view} = D{i_view} - A(:,:,i_view)*alpha(i_view);
end

for iter = 1:maxiter
    display(sprintf('Update iter #%d ...', iter));
    for i = 1:p %循环层
        
        for i_view=1:zz %视图循环
            display(sprintf('Update Layer #%d ...视图#%d ... ', i,i_view));
            
            Q{i_view,p + 1} = eye(layers(p));
            for i_layer = p:-1:2
                Q{i_view,i_layer} = U{i_view,i_layer} * Q{i_view,i_layer + 1};
            end
            
            VpVpT = VP * VP';
            AAT=A(:,:,i_view)*A(:,:,i_view)';
            
            
            %             更新Ui
            if i==1
                R = U{i_view,1} * (Q{i_view,2} * VpVpT *  Q{i_view,2}') + AAT * (U{i_view,1} * (Q{i_view,2} * Q{i_view,2}'));
                Ru = 2 * A(:,:,i_view) * (VP' * Q{i_view,2}');
                U{i_view,1} = U{i_view,1}.* Ru ./ max(R, 1e-10);
            else
                R = P{i_view}' * P{i_view} * U{i_view,i} * Q{i_view,i + 1} * VpVpT * Q{i_view,i + 1}' + P{i_view}' * AAT * P{i_view} * U{i_view,i} * Q{i_view,i + 1} * Q{i_view,i + 1}';
                Ru = 2 * P{i_view}' * A(:,:,i_view) * VP' * Q{i_view,i + 1}';
                U{i_view,i} = U{i_view,i}.* Ru ./ max(R, 1e-10);
            end
            
            % Update Vi
            if i == 1
                P{i_view} = U{i_view,i};
            else
                P{i_view} = P{i_view} * U{i_view,i};
            end
            
            
            if (i < p) && UpdateVi
                Vu = 2 * P{i_view}' * A(:,:,i_view);
                Vd = P{i_view}' * P{i_view} * V{i_view,i} + V{i_view,i};
                V{i_view,i} = V{i_view,i} .* Vu ./ max(Vd, 1e-10);
            else
                display('更新VP时,最后.....');
                
            end
        end  %视图循环
        
        % 更新VP
        if(i==p)
            Vu_sum=zeros(layers(end),xx);
            Vd_sum=zeros(layers(end),xx);
            VPA=zeros(layers(end),xx);
            VPD=zeros(layers(end),xx);
            
            for i_view=1:zz %视图循环
                VPA=VPA+ lambda(i_view) * VP * A(:,:,i_view)*alpha(i_view);
                Vu_sum = Vu_sum+2 * P{i_view}' * A(:,:,i_view) ;
                
                VPD= VPD+ lambda(i_view) * VP * D{i_view};
                Vd_sum =Vd_sum+ P{i_view}' * P{i_view} * VP+VP ;
            end
            
            
            VP = VP .* (Vu_sum+VPA) ./ max((Vd_sum+VPD), 1e-10);
            display(sprintf('Update Layer #%d ...#%d ...VP ', i,i_view));
        end
        % 更新VP
        
    end %循环层终止
    
    
    
    [dnorm,Obj_LCCF] = cost_function_all(A, P, VP,L,lambda);
    
    display(sprintf('Converged at iteration #%d ...', iter));
    
    
    dnormarray(iter) = dnorm;
    if iter > 1 && abs(dnorm0 - dnorm) <= tolfun
        display(sprintf('Converged at iteration #%d ...', iter));
        break; % converge
    end
    display(sprintf('Converged at iteration #%f ...', dnorm));
    dnorm0 = dnorm;
end
end
function [error_sum,Obj_LCCF] = cost_function_all(A_All, Up_All, Vp, L_all, lambda_all)
error_sum=0;

[xx yy zz]=size(A_All);
Obj_LCCF = zeros(zz,1);

for i_view=1:zz
    L=L_all{i_view};
    Up=Up_All{i_view};
    lambda=lambda_all(i_view);
    A=A_All(:,:,i_view);
    error = norm(A - Up * Vp, 'fro')^2 + norm(Vp - Up' * A, 'fro')^2 + lambda * trace(Vp * L * Vp');
    error = sqrt(error);
    Obj_LCCF(i_view)=error;
    error_sum=error_sum+error;
end
end


