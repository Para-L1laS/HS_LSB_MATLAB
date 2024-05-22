delta=hs_lsb_hide('Lena.bmp','bitstream.txt','Lena_embeded.bmp');
hs_lsb_recovery('Lena_embeded.bmp',delta,'message_extracted.txt');
f_id=fopen('bitstream.txt','r');
[bitstream_origin,len_total_0]=fread(f_id,'ubit1'); 
fclose(f_id);
f_id=fopen('message_extracted.txt','r');
[bitstream_extracted,len_total_1]=fread(f_id,'ubit1'); 
fclose(f_id);
flag=1;
while flag==1
if len_total_0==len_total_1
    for i=1:len_total_1
        if bitstream_origin(i)~=bitstream_extracted(i)
            disp('秘密信息提取有误！')
            flag=0;
            break;
        end
    end
    flag=-1
end
if len_total_0~=len_total_1
    disp('提取长度与恢复长度不同，提取失败！')
    flag=0;
end
end
if flag==-1
    disp('秘密信息提取成功！')
end
