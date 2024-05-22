% 直方图移位和lsb相结合的图像信息隐藏方案

% 信息嵌入函数
% 输入：原始图像文件，要嵌入的二值秘密信息文件
% 输出：嵌入秘密信息后的图像，嵌入范围的阈值
%function [image_embeded,delta]=hs_lsb(input,file,output)
function delta=hs_lsb_hide(input,file,output)
image_origin=imread(input);
[rows,cols]=size(image_origin);
image_embeded=image_origin;
% 选择嵌入的像素点的值
f_id=fopen(file,'r');
[bitstream,len_total]=fread(f_id,'ubit1'); 
fclose(f_id);
bits_num=zeros(1,257);
% 统计每个像素点的数量，选择和嵌入秘密信息长度最相近的，尽量不让直方图变得很奇怪
for i = 1:rows
    for j=1:cols
        % matlab数组下标从1开始，所以把所有的像素点都加上2，最后再减去2即可
        bits_num(image_origin(i,j)+2)=bits_num(image_origin(i,j)+2)+1;
    end
end
% 找出差值最小的像素开始点，注意，下标只选择偶数，并统计该数和下一个数字两位的总数
% 但是由于嵌入信息是不可控的，所以只能尽量减少对直方图分布的影响
least_diff=99999;
least_index=-1;
% 遍历所有偶数，寻找最接近的像素值总数
for i = 2:2:256
    if len_total-bits_num(i)<least_diff && len_total<bits_num(i) 
        least_diff=abs(len_total-bits_num(i));
        least_index=i;
    end
end
least_index=least_index-2;

% 直方图移位
for i=1:rows
    for j=1:cols
        if image_embeded(i,j)>=least_index
            image_embeded(i,j)=image_embeded(i,j)+2;
        end
    end
end
%{
[n, bins] = imhist(image_embeded, 256);
bar(bins, n, 'histc');
%}
% 秘密信息顺序嵌入，并代替移位后图像的对应位置
bits_sub=1;
for i=1:rows
    for j=1:cols
        if bits_sub<=len_total
            if image_origin(i,j)==least_index
            % 直接代替最后一位，由于选择的像素点都是偶数，直接加上就行
            image_embeded(i,j)=image_origin(i,j)+bitstream(bits_sub);
            bits_sub=bits_sub+1;
            end
        end
    end
end
% 把直方图移回1位，因否则直方图中会出现一列和旁边差距很大的bin
for i=1:rows
    for j=1:cols
        if image_embeded(i,j)>least_index+2
            image_embeded(i,j)=image_embeded(i,j)-1;
        end
    end
end
[n, bins] = imhist(image_embeded, 256);
% 绘制直方图
bar(bins, n, 'histc');
delta=least_index;
imwrite(image_embeded,output);
disp('秘密信息嵌入完毕！图片保存路径为/Lena_embeded.bmp')

subplot(1,2,1);imshow(image_origin); title('  原始图像  ');
subplot(1,2,2);imshow(output);title('隐藏信息的图像');

end
