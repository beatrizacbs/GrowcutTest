name = 'mdb315';
imageName = strcat(name, '.bmp');
fileName = strcat(name, '.mat');
image = imread(imageName);
%image = rgb2gray(image);
[linha, coluna] = size(image);
labelimg = load(fileName);
labelimg = labelimg.labels;
maxC = 600;

%pixels de vizinhança
Nx = [-1, -1, 1, 0, 1, 1, -1,  0]; 
Ny = [-1, 0, -1, 1,  1, 0, 1, -1];
	
image4 = edge(image, 'sobel');
strengthimg = labelimg;

%cria a matriz de força de acordo com os pontos do arquivo
strengthimg(strengthimg == -1) = 1;
labelimgc = labelimg;
strengthimgc = strengthimg;
sair = true;
vez = 1;
figure();

while(sair)
    
    for i = 2 : (linha-1)
        %tempimg = img(i-1:i+1,:);
        %templabel = labelimg(i-1:i+1,:);
        %tempstr = strengthimg(i-1:i+1,:);
        for j = 2 : (coluna-1)

            if((i == 1 || j == 1) || (i == linha || j == coluna))	
                    %aqui tem nada porque é a parte de borda.	
            else
                labelimgc(i,j) = labelimg(i,j);
                strengthimgc(i, j) = strengthimg(i, j);
                for q = 1 : 8
                    %maxC = max(max(image));
                    g = 1 - (abs((image(i, j)) - (image(i + Nx(q), j + Ny(q)))) / maxC);
                    resultado = g * strengthimg(i + Nx(q), j + Ny(q));
                    %resultado = g * tempstr(2 + Nx(q), j + Ny(q));

                    if((resultado > (strengthimg(i, j))))
                        if((image(i, j)) == 1)
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
bin = labelimg;
imouro = strcat(name,'_bin.bmp');
ouro = imread(imouro);

somaTP = sum(sum(((bin==1)& (ouro ==1))));
somaTN =  sum(sum((bin==0) & (ouro==0)));
somaFP =  sum(sum((bin==1) & (ouro==0)));
somaFN =  sum(sum((bin==0)&(ouro==1)));

Sensitivity = somaTP/ double(somaTP + somaFN);
Specificity = somaTN /double(somaFP + somaTN);
Jaccard = somaTP/double(somaTP + somaFN + somaFP);
Dice = 2*(somaTP)/double(sum(sum(bin==1))+sum(sum(ouro==1)));
BAC = (Specificity+Sensitivity)/2.0
