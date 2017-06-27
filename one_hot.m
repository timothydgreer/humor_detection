function f = one_hot(labels)
    f = zeros(length(labels),1);
    for i = 1:length(labels)
        if strcmp(labels(i),'l')
            f(i) = 1;
        elseif strcmp(labels(i),'lb')
            f(i) = 2;
        elseif strcmp(labels(i),'ls')
            f(i) = 3;
        else
            f(i) = -1; 
        end
    end
    f
    %Ensure that we have all of our labels in correctly
    find(f ~= 1 & f ~= 2 & f ~= 3)
end
    