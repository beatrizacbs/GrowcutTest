name = 'mdb005';
imageName = strcat(name, '.bmp');
fileName = strcat(name, '.mat');
image = imread(imageName);
%image2 = rgb2gray(image2);
%image = imresize(image2, 0.1);
[linha, coluna, cores] = size(image);
labels = load(fileName);
maxC = 600;

Nx = [-1, -1, 1, 0, 1, 1, -1,  0]; 
Ny = [-1, 0, -1, 1,  1, 0, 1, -1];
	
labelimg = zeros(linha, coluna);
strengthimg = zeros(linha, coluna);
%imshow(labelimg);
imshow(image);

npoints = 9;

%pra fora
	[col,lin] = ginput(npoints); %da o input
    for u = 1: npoints
        labelimg(int16(lin(u)),int16(col(u))) = 1; % atualiza label
        strengthimg(int16(lin(u)),int16(col(u))) = 1;
    end
   

%pra dentro
	[col_in,lin_in] = ginput(npoints);
    for k = 1 : npoints
        labelimg(int16(lin_in(k)),int16(col_in(k))) = -1;
        strengthimg(int16(lin_in(k)),int16(col_in(k))) = 1;
    end
    
%labelimgc(linha, coluna/3);
%strengtheimgc(linha, coluna/3);
labelimgc = labelimg;
strengthimgc = strengthimg;
sair = true;
vez = 1;
figure();
%himg = imshow(labelimgc,[]);
%figure();imshow(image);
image4 = edge(image, 'sobel');
 
%myCluster = parcluster('local');
%myCluster.NumWorkers = 2;  %
%delete(gcp);
%parpool('local',2);
while(sair)
    
    parfor i = 2 : (linha-1)
        %tempimg = img(i-1:i+1,:);
        %templabel = labelimg(i-1:i+1,:);
        %tempstr = strengthimg(i-1:i+1,:);
        for j = 2 : (coluna-1)

            if((i == 1 || j == 1) || (i == linha || j == coluna))	
                    %aqui tem nada porque � a parte de borda.	
            else
                labelimgc(i,j) = labelimg(i,j);
                strengthimgc(i, j) = strengthimg(i, j);
                for q = 1 : 8
                    %maxC = max(max(image));
                    g = 1 - (abs((image(i, j)) - (image(i + Nx(q), j + Ny(q)))) / maxC);
                    resultado = g * strengthimg(i + Nx(q), j + Ny(q));
                    %resultado = g * tempstr(2 + Nx(q), j + Ny(q));

                    if((resultado > (strengthimg(i, j))))
                        if((image4(i, j)) == 1)
                           break; 
                        else
                            labelimgc(i,j) = labelimg(i + Nx(q), j + Ny(q));
                            %labelimgc(i,j) = templabel(2 + Nx(q), j + Ny(q));
                            %strengthimgc(i,j) = g * strengthimg(i + Nx(q), j + Ny(q));
                            strengthimgc(i,j) = resultado;
                            %break;
                        end
                    end
                end
            end
        end	
    end
    
    contador = mod(vez, 3);
    
    if(contador == 0) 
       
        imshow(image);
        hold on
        contour(labelimgc,[0 0],'g','linewidth',1);
        hold off
    %set(himg, 'CData', labelimgc);
        drawnow;
    end
    
    vez = vez + 1;
    
    if(isequal(labelimg,labelimgc))
        sair = false;
    end
    labelimg = labelimgc;
    strengthimg = strengthimgc;
    
end
