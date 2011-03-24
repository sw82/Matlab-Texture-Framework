function Graphs(textures,legenda, feature)
% Changelog:
%               - [07.03.11] one feature, one plot
%               - [28.02.11] made variables global

%close Figure 1
screen_size = get(0, 'ScreenSize');
f1 = figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );

load(textures);

%the first, and the fifth - so every first
plot(1:4:length(values(:,feature)), values(1:4:end,feature), '*b');
hold on
plot(2:4:length(values(:,feature)), values(2:4:end,feature) ,  'or' );
hold on
plot(3:4:length(values(:,feature)), values(3:4:end,feature), '+g');
hold on
plot(4:4:length(values(:,feature)), values(4:4:end,feature), 'dk');
hold off


set(gca,'xTick',1:length(values(:,feature)));
set(gca,'xTickLabel', classes);


if(strcmp(legenda, 'Rotation'))
    legend('180','270','90','0');
    xl = 'Verschiedene Testobjekte in verschiedenen Rotationen (180, 270, 90 und 0 Grad)';
    tl = 'Originale in verschiedenen Zoomstufen ';
else
    if(strcmp(legenda,'Zoom'))
        legend('100 %','66 %','50 %','25 %');
        xl = 'Verschiedene Testobjekte in verschiedenen Zoomstufen (100%, 66%, 50%, 25%)';
        tl = 'Originale in verschiedenen Zoomstufen ';
    else
        if(strcmp(legenda,'Ausschnitt'))
            legend('100 %','66 %','50 %','25 %');
            xl = 'Verschiedene Testobjekte in verschiedenen Ausschnitten vom Original (100%, 66%, 50%, 25%)';
            tl = 'Verschiedenen Ausschnitte der Originale';
        end
    end
end

%label
xlabel(xl);
ylabel(char(header(feature)));
title(tl);
xticklabel_rotate;
