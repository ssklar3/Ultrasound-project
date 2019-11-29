%% READ THE AVI and convert to matrix
path(path,'/Users/samuelsklar/Documents/Classwork/Ultrasound/Project/Videos');
v=VideoReader('Vid1.avi');
numFrames = ceil(v.FrameRate*v.Duration);
mat=zeros(345,354,numFrames);
for i=1:numFrames
    vidFrame = readFrame(v);
    imshow(vidFrame)
    I = rgb2gray(vidFrame);
    imshow( I );
    mat(:,:,i)=im2double(I);
end
%%
