function zoomphoto( )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
img=imread('1.jpg');
imshow(img);
r=img(:,:,1);
g=img(:,:,2);
b=img(:,:,3);
[h w1]=size(img);
w=w1/3;
imgr=zeros(h,w);
imgg=zeros(h,w);
imgb=zeros(h,w);
psize=10;
ww=floor(w/psize)*psize;
hh=floor(h/psize)*psize;
file_path =  '.\images\';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量
imgmatr=[psize,psize*img_num];
imgmatg=[psize,psize*img_num];
imgmatb=[psize,psize*img_num];
ave=[4,img_num];
if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));
            imagezoom=imresize(image,[psize,psize]);
            imgmatr(1:psize,j*psize-psize+1:j*psize)=imagezoom(:,:,1);
            imgmatg(1:psize,j*psize-psize+1:j*psize)=imagezoom(:,:,2);
            imgmatb(1:psize,j*psize-psize+1:j*psize)=imagezoom(:,:,3);
            rr=imagezoom(:,:,1);
            gg=imagezoom(:,:,2);
            bb=imagezoom(:,:,3);
            ave(j,1)=mean(rr(:));
            ave(j,2)=mean(gg(:));
            ave(j,3)=mean(bb(:));
            ave(j,4)=0; 
            
        end
end
for x=1:psize:hh
    for y=1:psize:ww
        imgr(x:x+psize-1,y:y+psize-1)=mean(mean(r(x:x+psize-1,y:y+psize-1)));
        imgg(x:x+psize-1,y:y+psize-1)=mean(mean(g(x:x+psize-1,y:y+psize-1)));
        imgb(x:x+psize-1,y:y+psize-1)=mean(mean(b(x:x+psize-1,y:y+psize-1))); 
    end

    imgr(x:x+psize-1,ww+1:w)=mean(mean(r(x:x+psize-1,ww+1:w)));  
    imgg(x:x+psize-1,ww+1:w)=mean(mean(g(x:x+psize-1,ww+1:w)));  
    imgb(x:x+psize-1,ww+1:w)=mean(mean(b(x:x+psize-1,ww+1:w)));  
   
end

for y=1:psize:ww
    imgr(hh+1:h,y:y+psize-1)=mean(mean(r(hh+1:h,y:y+psize-1)));  
    imgg(hh+1:h,y:y+psize-1)=mean(mean(g(hh+1:h,y:y+psize-1))); 
    imgb(hh+1:h,y:y+psize-1)=mean(mean(b(hh+1:h,y:y+psize-1))); 
      
end

imgr(hh+1:h,ww+1:w)=mean(mean(r(hh+1:h,ww+1:w)));    
imgg(hh+1:h,ww+1:w)=mean(mean(g(hh+1:h,ww+1:w))); 
imgb(hh+1:h,ww+1:w)=mean(mean(b(hh+1:h,ww+1:w))); 
newr=imgr;
newg=imgg;
newb=imgb;
for x=1:psize:hh
    for y=1:psize:ww
         min=(imgr(x,y)-ave(1,1))^2+(imgg(x,y)-ave(1,2))^2+(imgb(x,y)-ave(1,3))^2;
         minz=0;
        for z=1:img_num            
            distance=(imgr(x,y)-ave(z,1))^2+(imgg(x,y)-ave(z,2))^2+(imgb(x,y)-ave(z,3))^2;
            if distance<min&&ave(z,4)<10
                min=distance;
                minz=z-1;
            end            
        end
        ave(minz+1,4)=ave(minz+1,4)+1;
        newr(x:x+psize-1,y:y+psize-1)=imgmatr(1:psize,minz*psize+1:minz*psize+psize);
        newg(x:x+psize-1,y:y+psize-1)=imgmatg(1:psize,minz*psize+1:minz*psize+psize);
        newb(x:x+psize-1,y:y+psize-1)=imgmatb(1:psize,minz*psize+1:minz*psize+psize);
    end
end
figure;
newr=uint8(newr);
newg=uint8(newg);
newb=uint8(newb);
imshow(cat(3,newr,newg,newb));

end

