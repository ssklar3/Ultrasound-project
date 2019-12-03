%% READ THE AVI and convert to matrix
path(path,'/Users/samuelsklar/Documents/Classwork/Ultrasound/Project/Videos');
v=VideoReader('Vid3.avi');
numFrames = ceil(v.FrameRate*v.Duration);
length=345;
width=354;
mid=ceil([length,width]./2);
mat=zeros(length,width,numFrames);
vidfile = VideoWriter('newfile2.avi','Motion JPEG AVI');
vidfile.FrameRate = 2;
open(vidfile);
for i=1:numFrames
    vidFrame = readFrame(v);
    I = rgb2gray(vidFrame);
    mat(:,:,i)=im2double(I);
end
mask=zeros(size(mat(:,:,1)));
for i=1:length
    for k=1:width
        check=((i-mid(1)+30).^2)+((k-mid(2)+30).^2);
        if check<1.2e4
            mask(i,k)=1;
        end
    end
end
for i=1:length
    for k=1:width
        check=((i-mid(1)+30).^2)+((k-mid(2)+30).^2);
        if check<.2e4
            mask(i,k)=0;
        end
    end
end
% figure
% imshow((mat(:,:,1).*mask))
% mat=mat-.1;
% %mat=(mat-mean(mat,3));
% mat( mat <= 0 ) = 0;

border=35;
ore=[1,1];

checksize=25;
for f=1:numFrames-1
ydiff=zeros(length-2*border,width-2*border);
xdiff=zeros(length-2*border,width-2*border);
    f
    for i=1+border:1:length-border
        posi=[i-checksize,i+ore(2)*checksize];
        if posi(2)<posi(1)
            posi=[posi(2),posi(1)];
        end
        for k=1+border:1:width-border
            posk=[k-checksize,k+ore(1)*checksize];
            if mask (i,k) == 1
                if posk(2)<posk(1)
                    posk=[posk(2),posk(1)];
                end
                ref=mat(posi(1):posi(2),posk(1):posk(2),f);
                mSAD=inf;
                    for j=[0,-5:-1,1:5]
                        cposi=posi+j;
                        for m=[0,-5:-1,1:5]
                            cposk=posk+m;
                            SAD=sum(sum(abs(ref-...
                                mat(cposi(1):cposi(2),cposk(1):cposk(2),f+1))));
                            if SAD<mSAD
                                mSAD=SAD;
                                ydiff(i,k)=j;
                                xdiff(i,k)=m;
                            end
                        end
                    end
            end
            ore(1)=1;
        end
        ore(2)=1;
    end
%     PSF  = fspecial('gaussian',6,2);
%     xdiff=conv2(xdiff,PSF,'same');
%     ydiff=conv2(ydiff,PSF,'same');
    %%
    figure;
    imshow((mat(:,:,f)))
    hold on
    spacing=20;
    quiver(1:spacing:size(xdiff,2),1:spacing:size(xdiff,1),xdiff(1:spacing:end,1:spacing:end),ydiff(1:spacing:end,1:spacing:end),1,'color',[0 .8 0])
    set(gca, 'YDir','reverse')
    hold off
    F = getframe(gcf);
    writeVideo(vidfile, F.cdata(36:36+length,108:108+width,:));
    close
end
close(vidfile)