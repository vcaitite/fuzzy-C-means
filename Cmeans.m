clear all;
close all;
clc;

% Definindo parâmetros
Max=1000;
tol=0.001;
% carregando e plotando os dados
load SyntheticDataset.mat;
X = x;

figure(1);
hold on;
plot(X(:,1), X(:,2),'b.');
grid on;

%------------------------------------------------------------------------
% Algoritmo C-Means

% define o numero de grupos
C = 4;          

% step 1: Randomly assign membership degrees to each of the observations. This is equivalent to the Membership Matrix U initialization step.
[n, nc] = size(X);
U = zeros(C, n);    % partition matrix
v = repmat(max(X), C, 1).*rand([C, nc]);
U = rand([C, n]);   % Randomly Membership Matrix U initialization step.

for j = 1:n
      U(:, j) = U(:, j)./sum(U(:, j));      
end  

for i = 1:C
      v(i, :) = sum((X(:, :).*repmat(U(i, :)'.^2, 1, nc)),1)./sum(U(i, :).^2);
end

v_old = v;
delta = 1000;
iterations = 0;
while  (iterations<Max && delta>tol)
    for i = 1:C
      for j = 1:n
        U(i, j) = 1/sum(euclidean(X(j, :), v(i, :))./euclidean(X(j, :), v)).^(2);
      end
    end
    for i = 1:C
       v(i, :) = sum((X(:, :).*repmat(U(i, :)'.^2, 1, nc)), 1)./sum(U(i, :).^2);  
    end
    % ploting the new centroids
    xdata = v(:,1);
    ydata = v(:,2);
    pause(1)
    h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
    set(h,'YDataSource','ydata')
    set(h,'XDataSource','xdata')
    refreshdata   
    v_new = v;
    delta = max(max(abs(v_new - v_old)));
    v_old = v;
    iterations = iterations+1;
end
fprintf(" O número de iterações foi: %d\n",iterations);



