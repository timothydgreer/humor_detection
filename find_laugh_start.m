function [laugh_start] = find_laugh_start(Y,thresh)
    laugh_start = zeros(1,length(Y));
    i = 1;
    while i < (length(Y))
        if(Y(i) == 1)
            starti = i;
            count = 1;
            while (i+1 < length(Y) && Y(i+1) == 1)
                i = i + 1;
                count = count +1;
                if(count == thresh)
                    laugh_start(starti) = 1;
                end
            end
            i = i+1;
        else
            i = i+1;
        end
    end
    laugh_start = laugh_start';
end
