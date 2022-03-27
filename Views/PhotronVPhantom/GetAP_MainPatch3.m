function [Avec,Pvec,Bvec,BlobCell,LogMat]=GetAP_MainPatch3(Mat,thresh,smtLog,margin,MinPatchSize)

%--Get Logical Matrix
LogMat=Mat<thresh;
LogMat = medfilt2(LogMat, smtLog ,'symmetric');

%--find all boundaries and take #PatchNum biggest patches
B = bwboundaries(LogMat);
stats = regionprops(LogMat,'area','perimeter');
S=struct2cell(stats);
S=cell2mat(S);

PatchNum=0;
if ~isempty(S);    b=find(S(1,:)>MinPatchSize);    PatchNum=length(b); end

Avec=0;
Pvec=0;
Bvec=0;
BlobCell={[]};
for j=1:PatchNum
    MainPatch=B{b(j)};
    xx=MainPatch(:,2);
    yy=MainPatch(:,1);
    smtfactor= 2*floor(0.2*length(xx)/2)+1;
    new_yy = sgolayfilt(yy,2,smtfactor);
    new_xx = sgolayfilt(xx,2,smtfactor);

    ymin=margin;
    xmin=margin;
    ymax=size(Mat,1)-margin;
    f=find(new_yy<ymin | new_yy>ymax | new_xx<xmin);
    
    dx=diff(new_xx);
    dy=diff(new_yy);
    rr=sqrt(dx.^2+dy.^2);

    A=polyarea(new_xx,new_yy);
    P=sum(rr);
    boundarylength=sum(rr(f(1:end-1)));
    Blob=horzcat(new_yy,new_xx);
    
    Avec(j)=A;
    Pvec(j)=P;
    Bvec(j)=boundarylength;
    BlobCell{j}=Blob;

end

[Avec,ind]=sort(Avec,'descend');
Pvec=Pvec(ind);
Bvec=Bvec(ind);
BlobCell=BlobCell(ind);



