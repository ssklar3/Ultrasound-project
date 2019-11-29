%% READ THE AVI and convert to matrix
path(path,'/Users/samuelsklar/Documents/Classwork/Ultrasound/Project/Videos');
v=VideoReader('Vid3.avi');
numFrames = ceil(v.FrameRate*v.Duration);
length=345;
width=354;
mid=ceil([length,width]./2);
mat=zeros(length,width,numFrames);
for i=1:numFrames
    vidFrame = readFrame(v);
    I = rgb2gray(vidFrame);
%     imshow( I );
    mat(:,:,i)=im2double(I);
end
border=50;
ore=[1,1];
ydiff=zeros(length-2*border,width-2*border);
xdiff=zeros(length-2*border,width-2*border);
checksize=27;

for i=1+border:length-border
    i
%     if i>mid(2)
%         ore(2)=-1;
%     end
    posi=[i,i+ore(2)*checksize];
    if posi(2)<posi(1)
        posi=[posi(2),posi(1)];
    end
    for k=1+border:width-border
%         if k>mid(1)
%             ore(1)=-1;
%         end
        posk=[k,k+ore(1)*checksize];
        if posk(2)<posk(1)
            posk=[posk(2),posk(1)];
        end
        ref=mat(posi(1):posi(2),posk(1):posk(2),1);
        mSAD=inf;
            for j=-5:5
                cposi=posi+j;
                for m=-5:5
                    cposk=posk+m;
                    SAD=sum(sum(abs(ref-...
                        mat(cposi(1):cposi(2),cposk(1):cposk(2),4))));
                    if SAD<mSAD
                        mSAD=SAD;
                        ydiff(i,k)=j;
                        xdiff(i,k)=m;
                    end
                end
            end
        ore(1)=1;
    end
    ore(2)=1;
end
%%
figure;
quiver(1:size(xdiff,2),1:size(xdiff,1),xdiff,ydiff)
set(gca, 'YDir','reverse')
