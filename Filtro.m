foto = imread('foto01.jpg');
fotocortada = imcrop(foto,[43.5100 69.5100 235.9800 145.9800]); %fica 146X236
fotobinaria = im2bw(fotocortada,maps,0.3);
m = sum(~fotobinaria,1);
figure(1);
subplot(2,1,1);
imshow(foto);
title('Imagem Original');
subplot(2,1,2);
imshow(fotobinaria);
title('Imagem Binária Original');

m2 = medfilt1(m);

foto2 = medfilt3(foto);
% subplot(2,2,3);
% imshow(foto2);
% title('Imagem Filtro Mediana');
fotocortada2 = imcrop(foto2,[43.5100 69.5100 235.9800 145.9800]); %fica 146X236
fotobinaria2 = im2bw(fotocortada2,maps,0.3);
m3 = sum(~fotobinaria2,1);
% subplot(2,2,4);
% imshow(fotobinaria2);
% title('Imagem Binária Filtro Mediana');


% figure(2);
% subplot(2,1,1);
% stem(m);
% title('Formato padrão - Imagem Original');
% subplot(2,1,2);
% stem(m2,'r');
% title('Formato padrão - Imagem Filtrada');


figure(3);
stem(m);
hold on;
stem(m2,'r');
hold on;
stem(m3,'g');
