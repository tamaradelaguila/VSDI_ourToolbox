function cellListOut = rasterList_Create()
% Use a gui to generate a list of raster data files.  The generated file
% will be used as the input LISTFILE in stackRasters().

cellListOut = {}; % initialize empty cell array
cancelled=0; % condition for breaking out of while loop
currDataFileNum=1;

disp('Choose a raster data file (.mat) to add to the list.')
disp('When finished adding data files, press cancel.')
disp('You will then be prompted to save the file list.')
disp(' ')

while ~cancelled, % keep going unless the user clicked 'cancel'
    [filename, pathname] = uigetfile('*.mat', 'Select a raster data file'); % load file dialogue
    if isequal(filename,0),
        cancelled=1;
    else % if the user didn't click cancel
        cellListOut{currDataFileNum} = fullfile(pathname,filename);
        
        if currDataFileNum==1, disp('Current file list:'),end
        disp(cellListOut{currDataFileNum}) % display the current list contents
        currDataFileNum=currDataFileNum+1; % increment counter
    end
end


if ~isempty(cellListOut), % if the generated raster data file list isn't empty, prompt the user to save the list
    disp(' ')
    disp('Save the list file...')
    
    [fnameOut, pnameOut] = uiputfile('*.txt', 'Save raster listFile as');
    if ~isequal(fnameOut,0),

        fid = fopen(fullfile(pnameOut,fnameOut),'w');
        for i=1:length(cellListOut),
            fprintf(fid,'%s\r\n',cellListOut{i});
        end
        fclose(fid);
        disp(['File list written to ' fullfile(pnameOut,fnameOut)])
        
    else
        disp('User selected Cancel.  Nothing saved.')
    end
end