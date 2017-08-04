function [laugh_start] = find_laugh_start(Y,thresh)
    %grabs the first window of every section of laughter that is long
    %enough to meet the threshold
    laugh_start = zeros(1,length(Y));
    i = 1;
    %scans through all windows of laughter
    while i < (length(Y))
        %finds a new section of laughter
        if(Y(i) == 1)
            starti = i;
            count = 1;
            %counts every subsequent window of laughter in a section of laughter
            while (i+1 < length(Y) && Y(i+1) == 1)
                i = i + 1;
                count = count +1;
                %if the number of windows of consecutive laughter in a section
                %meets the threshold then the first window of the section is
                %recorded
                if(count == thresh)
                    laugh_start(starti) = 1;
                end
            end
            i = i+1;
        else
            i = i+1;
        end
    end
    %lazy transpose
    laugh_start = laugh_start';
end
