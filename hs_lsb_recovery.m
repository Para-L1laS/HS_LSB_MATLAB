% 信息恢复函数
% 输入：嵌入秘密信息的图像，嵌入范围的阈值，保存秘密信息的问津
% 输出：无
function hs_lsb_recovery(input,delta,goalfile)
image_embeded=imread(input);
[rows,cols]=size(image_embeded);
frr=fopen(goalfile,'a');
%p作为消息嵌入位数计数器,将消息序列写回文本文件
p=1;
for i=1:rows
    for j=1:cols
        if image_embeded(i,j)==delta
           result(p,1)=0;
           p=p+1;
        end
        if image_embeded(i,j)==delta+1
           result(p,1)=1;
           p=p+1;
        end    
     end    
end
fwrite(frr,result,'ubit1')
fclose(frr);
disp('秘密信息提取完毕！保存路径为/message_extracted.txt')
end