function [Area,Perimeter,Velocity,Beta] = GetParameters(mat)
%GETPARAMETERS gets parameters for the crack
Area = zeros(size(mat,3),1);
Perimeter = zeros(size(mat,3),1);
Velocity = zeros(size(mat,3),1);
Beta = zeros(size(mat,3),1);

Size = size(mat,1)*size(mat,2);

for t=1:size(mat,3)
    currentMat = mat(:,:,t);
    Area(t) = (Size - sum(currentMat,'all'));
    Perimeter(t) = GetPerimeter(currentMat);
    Beta(t) = Perimeter(t)*Perimeter(t)/(4*Area(t));
    if t>1
        Velocity(t)=(sqrt(Area(t)) - sqrt(Area(t-1)));
    end
end


end

function Perimeter=GetPerimeter(mat)
Perimeter = 0;
perimeterPositions = bwboundaries(~mat);
for k = 1:length(perimeterPositions)
    Perimeter= Perimeter+size(perimeterPositions{k},1);
end

end