clear all;
close all;
clc;

% Definindo parâmetros
Max=1000 ;
tol=0.001;
% carregando e plotando os dados

%uiopen('C:\Users\vitor\Desktop\Arquivos do Trabalho Prático 1-20190422\ImagensTeste\ImagensTeste\photo001.jpg',1);

i= input('Imagem: photo001 digite 1, photo002 digite 2,..., photo011 digite 11\n');
switch i
    case 1
        I = imread('photo001.jpg');
    case 2
        I = imread('photo002.jpg');
    case 3
        I = imread('photo003.jpg');
    case 4
        I = imread('photo004.jpg');
    case 5
        I = imread('photo005.jpg');
    case 6
        I = imread('photo006.jpg');
    case 7
        I = imread('photo007.jpg');
    case 8
        I = imread('photo008.jpg');
    case 9
        I = imread('photo009.jpg');
    case 10
        I = imread('photo010.jpg');
    case 11
        I = imread('photo011.png');
end
X = imresize(I, 0.33);
X = double(X);
subplot(1,2,1);
plot3(X(:,:,1), X(:,:,2), X(:,:,3),'b.');
hold on;

grid on;

% Algoritmo C-Means

% define o numero de grupos
C = input('Número de Clusters: \n'); 
fprintf("aguarde...\n");
% step 1: Randomly assign membership degrees to each of the observations. This is equivalent to the Membership Matrix U initialization step.
[n, nc, ne] = size(X);
U = zeros(C, n*nc);    % partition matrix
v = repmat(max(max(max(X))), C, 1).*rand([C, ne]);
U = rand([C, n*nc]);   % Randomly Membership Matrix U initialization step.

for j = 1:(n*nc)
      U(:, j) = U(:, j)./sum(U(:, j));
end

b=1;
Y = zeros(nc*n, ne);
for i=1:ne
    for j=1:nc
        for k =1:n
            Y(b, i)=X(k,j,i);
            b=b+1;
        end
    end
    b=1;
end


for i = 1:C
      v(i, :) = sum((Y(:,:).*repmat(U(i, :)'.^2, 1, ne)),1)./sum(U(i, :).^2);
end

xdata = v(:,1);
ydata = v(:,2);
zdata = v(:,3);
pause(1)
h = plot3(xdata, ydata, zdata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
set(h,'YDataSource','ydata')
set(h,'XDataSource','xdata')
set(h,'ZDataSource','zdata')
refreshdata

v_old = v;
delta = inf;
iterations = 0;
while  (iterations<Max && delta>tol)
    for i = 1:C
      for j = 1:(n*nc)
        U(i, j) = 1/sum(euclidean(Y(j, :), v(i, :))./euclidean(Y(j, :), v)).^(2);
      end
    end
    for i = 1:C
       v(i, :) = sum((Y (:, :).*repmat(U(i, :)'.^2, 1, ne)), 1)./sum(U(i, :).^2);  
    end
    % ploting the new centroids
    xdata = v(:,1);
    ydata = v(:,2);
    zdata = v(:,3);
    pause(1)
    
    h = plot3(xdata, ydata, zdata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize', 12);
    set(h,'YDataSource','ydata')
    set(h,'XDataSource','xdata')
    set(h,'ZDataSource','zdata')
    refreshdata
    v_new = v;
    delta = max(max(abs(v_new - v_old)));
    v_old = v;
    iterations = iterations+1;
end
fprintf(" O número de iterações foi: %d\n",iterations);

%criando vetor de designações D de cluster
D = zeros(n*nc,1);
k=1;
for j = 1:(n*nc)
    A = U(1,j);
    a=1;
    for i = 1:(C-1)
        if(A >= U(i+1,j))
            if(a==1) 
                D(k) = i;
                A = U(i,j);
                a=0;
            end
        else
            D(k) = i+1;
            A = U(i+1,j);
            a=1;
        end 
    end
    k=k+1;
end

clus=1:C;
colors = {'y.', 'r.', 'k.', 'm.', 'b.', 'c.','.g'};
hold off;
subplot(1,2,2);
for i = 1:C
    indexes = find(D==clus(i));
    teste = (indexes./n);
    indexe2 = fix(teste);
    indexe1 = indexe2;
    for j=1:length(teste)
        if (indexe2(j) ~= teste(j))
            indexe2(j) = indexe2(j) + 1;
        end
        aux = n * (indexe2(j)-1);
        indexe1(j) = indexes(j) - aux;
    end
    
    for j=1:length(indexe1)
        plot3(X(indexe1(j),indexe2(j),1), X(indexe1(j),indexe2(j),2), X(indexe1(j),indexe2(j),3), colors{i});
        hold on;
        grid on;
    end
    h = plot3(xdata, ydata, zdata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 12);
end


