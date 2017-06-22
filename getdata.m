yep1 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('01 The One After _I Do_ (1080p HD).mp4.wav',[starter,ender]);
    yep1 = [yep1; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep1end(length(ep1end))*48000;
yeptemp =  audioread('01 The One After _I Do_ (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep1 = [yep1; sum(yeptemp,2)];
    
yep2 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('02 The One With the Red Sweater (1080p HD).mp4.wav',[starter,ender]);
    yep2 = [yep2; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep2end(length(ep2end))*48000;
yeptemp =  audioread('02 The One With the Red Sweater (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep2 = [yep2; sum(yeptemp,2)];

yep3 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('03 The One Where Rachel Tells Ross (1080p HD).mp4.wav',[starter,ender]);
    yep3 = [yep3; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep3end(length(ep3end))*48000;
yeptemp =  audioread('03 The One Where Rachel Tells Ross (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep3 = [yep3; sum(yeptemp,2)];

yep8 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('08 The One With the Stripper (1080p HD).mp4.wav',[starter,ender]);
    yep8 = [yep8; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep8end(length(ep8end))*48000;
yeptemp =  audioread('08 The One With the Stripper (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep8 = [yep8; sum(yeptemp,2)];

yep9 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('09 The One With the Rumor (1080p HD).mp4.wav',[starter,ender]);
    yep9 = [yep9; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep9end(length(ep9end))*48000;
yeptemp =  audioread('09 The One With the Rumor (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep9 = [yep9; sum(yeptemp,2)];

yep10 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('10 The One With Monicas Boots (1080p HD).mp4.wav',[starter,ender]);
    yep10 = [yep10; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep10end(length(ep10end))*48000;
yeptemp =  audioread('10 The One With Monicas Boots (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep10 = [yep10; sum(yeptemp,2)];

yep12 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('12 The One Where Joey Dates Rachel (1080p HD).mp4.wav',[starter,ender]);
    yep12 = [yep12; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep12end(length(ep12end))*48000;
yeptemp =  audioread('12 The One Where Joey Dates Rachel (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep12 = [yep12; sum(yeptemp,2)];

yep13 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('13 The One Where Chandler Takes a Bath (1080p HD).mp4.wav',[starter,ender]);
    yep13 = [yep13; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep13end(length(ep13end))*48000;
yeptemp =  audioread('13 The One Where Chandler Takes a Bath (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep13 = [yep13; sum(yeptemp,2)];

yep14 = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('14 The One With the Secret Closet (1080p HD).mp4.wav',[starter,ender]);
    yep14 = [yep14; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = ep14end(length(ep14end))*48000;
yeptemp =  audioread('14 The One With the Secret Closet (1080p HD).mp4.wav',[ender,ceil(lastsample)]);
yep14 = [yep14; sum(yeptemp,2)];

yhimym = [];
for i = 1:100
    starter = (i-1)*5e5+1;
    ender = i*5e5;
    yeptemp =  audioread('himyms4e2.wav',[starter,ender]);
    yhimym = [yhimym; sum(yeptemp,2)];
end
%Find the end of the last laugh
lastsample = himymend(length(himymend))*48000;
yeptemp =  audioread('himyms4e2.wav',[ender,ceil(lastsample)]);
yhimym = [yhimym; sum(yeptemp,2)];