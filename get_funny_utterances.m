A = importdata('subtitles/Friends_8/csv09_The_One_With_the_Rumor_(HD).txt');
%Delimit
utterance = cell(length(A),1);
for i = 1:length(A)
    first = strsplit(A{i},'|');
    utterance{i} = first{1};
    time_unsplit = first{2};
    time_split = strsplit(time_unsplit,'^');
    ep9utstart(i) = str2num(time_split{1});
    ep9utend(i) = str2num(time_split{2});
end
ep9utstart = ep9utstart'; 
ep9utend = ep9utend'; 


window = 100;
%RENAME FUNCTION!
%[Xep9,Ytruthep8,NANs9,MFCCs_to_Look_At9] = get_data_single_episode_with_laugh_tags(ep1start, ep1end, yep1, 48000, window);
%temp_svm = svmfriends.Trained{5};
%Ypredict9 = predict(temp_svm,Xep9);

Ysmooth9 = post_smooth(Ypredict9,1);

LaughterEp9 = find_laugh_start(Ysmooth9,2);


%Finds the indices of the NANs that are not zero. These correspond to
%When there is a number in MFCCs, and this is where there is Y = 0 or 1
NAN_zeros9 = find(NANs9 == 0); 

%THERES NOTHING WRONG WITH THESE THREE CALLS
%This finds the indices of the numbers where laughter is starting
%Then, it is finding the start time in ms by dividing by 10
laugh_start_times9 = NAN_zeros9(find(LaughterEp9 == 1))/10;

%Look for the part of the script that has a starting time right before the laughter.
%Take this to be the utterance that is funny.
utpred9 = cell(length(laugh_start_times9),1);
for i = 1:length(laugh_start_times9)
    for j = 1:length(ep9utstart)
        if (ep9utstart(j) > laugh_start_times9(i))% && abs(ep9utend(j-1) - laugh_start_times9(i)) < 3)
            utpred9{j-1} = utterance{j-1};
            break
        else
            continue
        end
    end
end

%This has the truth data of the laughter for comparison
laugh_start_times_truth9 = round(ep9start,1);

%smooth the ep1start to account for l --> ls and vv
%This ensures that we will not get utterances that are
%'between' the laughter. All contiguous laughter should be
%treated as such.
laugh_end_times_truth9 = round(ep9end,1);
ep9real_start = ep9start(1);
for i = 2:length(laugh_end_times_truth9)
    if laugh_start_times_truth9(i) == laugh_end_times_truth9(i-1);
        ;
    else
        ep9real_start = [ep9real_start, laugh_start_times_truth9(i)];
    end
end

%work on this to find endtimes
% ep9real_end = ep9end(end);
% flipl
% for i = 2:length(laugh_end_times_truth9)
%     if laugh_start_times_truth9(i) == laugh_end_times_truth9(i-1);
%         ;
%     else
%         ep9real_start = [ep9real_start, laugh_start_times_truth9(i)];
%     end
% end
% 
% ep9real_end = flip(ep9real_end);

%This will remove the utterances that say, 'Oh' and 'Okay' and 'Ah'
utact9 = cell(length(ep9real_start),1);
for i = 1:length(ep9real_start)
    for j = 1:length(ep9utstart)
        if (ep9utstart(j) > ep9real_start(i))% && abs(ep9utstart(j) - ep9real_start(i)) < 4)
            temp_str = utterance{j-1}
            %DATA SPECIFIC :(
            if ~isempty(regexp(temp_str, '[OA](kay|h)(\W+)?$', 'match'))
                h = 1
                utact9{j-1} = utterance{j-2};
            else
                utact9{j-1} = utterance{j-1};
            end
            break
        else
            continue
        end
    end
end

%Compare predicted with actual
%ALEX, PLEASE FILL IN
countpred = 0;
countact = 0;
for i = 1:length(utpred9)
    if ~isempty(utpred9{i})
        countpred = countpred+1;
    end
end

for i = 1:length(utact9)
    if ~isempty(utact9{i})
        countact = countact+1;
    end
end

utpreddist9 = cell(length(countpred),1);
utactdist9 = cell(length(countact),1);
countpred = 1;
countact = 1;
for i = 1:length(utpred9)
    if ~isempty(utpred9{i})
        utpreddist9{countpred} = utpred9{i};
        countpred = countpred+1;
    end
end

for i = 1:length(utact9)
    if ~isempty(utact9{i})
        utactdist9{countact} = utact9{i};
        countact = countact+1;
    end
end
