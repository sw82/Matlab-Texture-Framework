function [  ] = Intro(  )
%INTRO Summary of this function goes here
%   Detailed explanation goes here

    
%% Clear and clean everything first
 clc;        % Clear Command Window 
 close all   % Remove specified figure
 
 
 

%% Introduce the function
fprintf('This function will determine texture characteristics. \nIt requires the Image Processing Toolbox.\n \n');



%% Change the current folder to the folder of this m-file
if(~isdeployed)
	cd(fileparts(which(mfilename))); 
end


%% Show versions and user's toolboxes
fprintf('Checking for Image processing toolbox...\n \n');

v = ver;
for k=1:length(v)
   if strfind(v(k).Name, 'Image Processing')
      fprintf('%s, Version %s \n', ...
                    v(k).Name, v(k).Version)
   end
end

%% Check if user has the Image Processing Toolbox installed.
versionInfo = ver; % Capture their toolboxes in the variable.
hasIPT = false;
for k = 1:length(versionInfo)
	if strcmpi(versionInfo(k).Name, 'Image Processing Toolbox') > 0
		hasIPT = true;
	end
end
if ~hasIPT
	% No toolbox installed.
	message = sprintf('Sorry, but it looks like you do not have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User' decision to exit:
		return;
	end
end
 
end

