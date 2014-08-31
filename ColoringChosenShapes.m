function[ImGray]=ColoringChosenShapes(LMatrix,ImGray, Image,i)
[n,m]=size(LMatrix);

for k=1:n
    for j=1:m
        if LMatrix(k,j)==i;
            ImGray(k,j,:)=Image(k,j,:);
        end
    end
end

