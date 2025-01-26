function GUI_update_dec2()

    % Set up variables to hold commands
    res = 4; % 640, 800, 1280, 1920
    option = 1; % 1, 2
    pattern = 1; % 1, 2, 3
    updated = 0; % 0, 1
    reset_on = 0; % 0, 1;

    % Serial setup
    comPort = 'COM1'; % Serial Port
    baudRate = 115200; % Specified for UART
    %s = serial(comPort, 'BaudRate', baudRate);
    % Open the serial port
    %fopen(s);
    % Let me know if it worked
    disp('UART communication opened.');

    % Create a figure for the GUI
    f = figure('Position', [300, 50, 1000, 700], 'Resize', 'off');
    f.Color='#5b625a';

    % hEditControl = uicontrol('Style','edit');
    % set(hEditControl, 'BackgroundColor', [0 0 1]);

    % Set up source options
    source_panel = uipanel(f, "Position", [0.1, 0.7, 0.8, 0.35], ...
        'BackgroundColor', '#888c87');

    bg_source = uibuttongroup('Parent', source_panel, ...
                          'Position', [0, 0, 1, 1], ... 
                          'FontSize', 12, ...
                          'Units', 'normalized',...
                          'BackgroundColor', '#888c87');

    % Live
    uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [50, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Live Video', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @livevideo);
    
    % Test Pattern 1
    uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [300, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Test Pattern 1', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @testpattern1);
    
    % Test Pattern 2
    uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [550, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Test Pattern 2', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @testpattern2);

    status_text = uicontrol('Parent', source_panel, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0.075, 0.6, 0.1], ...  % Fill the entire panel
                        'FontSize', 12, ...
                        'String', 'Select an Image To be Downloaded',...
                        'BackgroundColor', '#888c87');

    % Reset button
    reset_panel = uipanel(f, "Position", [0.75, 0.05, 0.15, 0.05]);
    rst_button = uicontrol('Parent', reset_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  % Use normalized units for scaling
              'Position', [0, 0, 1, 1], ...  % Relative to the panel
              'FontSize', 10, ...
              'String', 'Reset', ...
              'BackgroundColor', "#f97c7f",...
              'Callback', @reset);


    uicontrol('Parent', source_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  % Use normalized units for scaling
              'Position', [0.6, 0.075, 0.2, 0.15], ...  % Relative to the panel
              'FontSize', 10, ...
              'String', 'Browse', ...
              'BackgroundColor', "#4DBEEE",...
              'Callback', @reset);


    drawnow;  % Ensure UI components are fully initialized
    bg_source.SelectedObject = [];  % Clear any selected button

    uicontrol(source_panel, 'Style', 'text', ...
          'Position', [300, 140, 200, 50], ...
          'String', 'Source', 'FontSize', 24, ...
           'BackgroundColor', '#888c87');
    


    % Add browse option to panel
    % select button
    
    % Set up resolution options
    res_panel = uipanel(f, "Position", [0.1, 0.25, 0.3, 0.4],...
                          'BackgroundColor', '#888c87');
    
    uicontrol(res_panel, 'Style', 'text', ...
          'Position', [50, 175, 200, 100], ...
          'String', 'Resolution', 'FontSize', 24,...
          'BackgroundColor', '#888c87');
    
    bg = uibuttongroup('Parent', res_panel, ...
               'Position', [0.1, 0.1, 0.8, 0.65], ...
               'Units', 'normalized',...
               'BackgroundColor', '#888c87');  

    % 640
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 140, 150, 30], ...
              'String', '640 x 480', ...
              'FontSize', 14, ...
              'Units', 'pixels', ...
              'BackgroundColor', '#888c87',...  % Ensures consistent positioning
              'Callback', @res640);

    % 800
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 100, 150, 30], ...
              'String', '800 x 600', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  % Ensures consistent positioning
              'Callback', @res800);

    % 1280
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 60, 150, 30], ...
              'String', '1280 x 720', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  % Ensures consistent positioning
              'Callback', @res1280);

    % 1920
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 20, 150, 30], ...
              'String', '1080 x 1920', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  % Ensures consistent positioning
              'Callback', @res1920);

    drawnow;  % Ensure UI components are fully initialized
    bg.SelectedObject = [];  % Clear any selected button

    % Set up processing options
    sink_panel = uipanel(f, "Position", [0.45, 0.25, 0.45, 0.4], ...
        'BackgroundColor', '#888c87');

    bg_process = uibuttongroup('Parent', sink_panel, ...
                           'Position', [0, 0, 1, 1], ... % Full width, slightly shorter height
                           'Units', 'normalized',...
                           'BackgroundColor', '#888c87');

    % Flip horizontal
    uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.02, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'Monitor 1', ...
              'BackgroundColor', "#f394ed",...
              'Callback', @option1);
    
    % Flip vertical
    uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.53, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'Monitor 2', ...
              'BackgroundColor', "#f394ed",...
              'Callback', @option2);
   
    uicontrol(sink_panel, 'Style', 'text', ...
          'Position', [80, 210, 300, 50], ...
          'String', 'Output Monitor', 'FontSize', 24,...
          'BackgroundColor', '#888c87');

    drawnow;  % Ensure UI components are fully initialized
    bg_process.SelectedObject = [];  % Clear any selected button

    % Set up sink options
    % sink_panel = uipanel(f, "Position", [0.1, 0.12, 0.6, 0.22]);
    % 
    % bg_sink = uibuttongroup('Parent', sink_panel, ...
    %                       'Position', [0, 0, 1, 0.8], ... 
    %                       'FontSize', 12, ...
    %                       'Units', 'normalized');
    % 
    % uicontrol(sink_panel, 'Style', 'text', ...
    %           'Position', [200, 110, 200, 30], ...
    %           'String', 'Sink', 'FontSize', 20);
    % 
    % % 1
    % uicontrol('Parent', bg_sink, 'Style', 'togglebutton', ...
    %           'Position', [50, 20, 150, 80], ...
    %           'FontSize', 12, ...
    %           'String', 'Option 1', ...
    %           'Callback', @option1);
    % 
    % % 2
    % uicontrol('Parent', bg_sink, 'Style', 'togglebutton', ...
    %           'Position', [250, 20, 150, 80], ...
    %           'FontSize', 12, ...
    %           'String', 'Option 2', ...
    %           'Callback', @option2);
    % 
    % drawnow;  % Ensure UI components are fully initialized
    % bg_sink.SelectedObject = [];  % Clear any selected button

    % Update button
    up_panel = uipanel(f, "Position", [0.35, 0.13, 0.3, 0.08],...
        'BackgroundColor', '#888c87');

    uicontrol('Parent', up_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  % Use normalized units for scaling
              'Position', [0, 0, 1, 1], ...  % Relative to the panel
              'FontSize', 14, ...
              'String', 'Update', ...
              'BackgroundColor', "#77AC30", ...
              'Callback', @update);

    % Textbox to update user on the changes
    textbox = uipanel(f, "Position", [0.1, 0.05, 0.6, 0.05],...
        'BackgroundColor', '#888c87');

    status_text1 = uicontrol('Parent', textbox, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0, 1, 1], ...  % Fill the entire panel
                        'FontSize', 12, ...
                        'BackgroundColor', "white",...
                        'String', 'Updated Test Pattern 1, 640x480, Monitor 1');

    % All the functions to send an ASCII code through UART

    function testpattern1(~, ~)
        % flushoutput(s);
        % flushinput(s);
        % % Send command to turn on LED0
        % fprintf(s, '%s', 'a'); % Sending '1' to turn on LED0
        % flushoutput(s);
        % flushinput(s);
        % fprintf(s, '%s', '1'); % Sending '1' to turn on LED0
        % disp('Command sent: Test Pattern 1');
        pattern = 1;
    end

    function testpattern2(~, ~)
        % Send command to turn on LED0
        % fprintf(s, '%s', 'a'); % Sending '1' to turn on LED0
        % flushoutput(s);
        % flushinput(s);
        % fprintf(s, '%s', '2'); % Sending '1' to turn on LED0
        % disp('Command sent: Test Pattern 2');
        pattern = 2;
    end

    function livevideo(~, ~)
        % fprintf(s, '%s', 'a'); % Sending '1' to turn on LED0
        % flushoutput(s);
        % flushinput(s);
        % fprintf(s, '%s', '0'); % Sending '1' to turn on LED0
        % disp('Command sent: Live Video');
        pattern = 3;
    end

    function res640(~, ~)
        % flushoutput(s);
        % flushinput(s);
        % % Send command to turn on LED0
        % fprintf(s, '%s', '0'); % Sending '0' to turn on LED0
        % disp('Command sent: Live Video');
        res = 4;
    end

    function res800(~, ~)
        % flushoutput(s);
        % flushinput(s);
        % % Send command to turn on LED0
        % fprintf(s, '%s', '0'); % Sending '0' to turn on LED0
        % disp('Command sent: Live Video');
        res = 5;
    end

    function res1280(~, ~)
        % flushoutput(s);
        % flushinput(s);
        % % Send command to turn on LED0
        % fprintf(s, '%s', '0'); % Sending '0' to turn on LED0
        % disp('Command sent: Live Video');
        res = 6;
    end

    function res1920(~, ~)
        % flushoutput(s);
        % flushinput(s);
        % % Send command to turn on LED0
        % fprintf(s, '%s', '0'); % Sending '0' to turn on LED0
        % disp('Command sent: Live Video');
        res = 7;
    end

    function fliph(~, ~)
           % flushoutput(s);
           % flushinput(s);
           % % Send command to turn on LED0
           % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
           % disp('Command sent: Live Video');
    end

    function flipv(~, ~)
           % flushoutput(s);
           % flushinput(s);
           % % Send command to turn on LED0
           % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
           % disp('Command sent: Live Video');
    end

    function pro_default(~, ~)
           % flushoutput(s);
           % flushinput(s);
           % % Send command to turn on LED0
           % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
           % disp('Command sent: Live Video');
    end

    function option1(~, ~)
           % flushoutput(s);
           % flushinput(s);
           % % Send command to turn on LED0
           % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
           % disp('Command sent: Live Video');
           option = 0;
    end

    function option2(~, ~)
           % flushoutput(s);
           % flushinput(s);
           % % Send command to turn on LED0
           % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
           % disp('Command sent: Live Video');
           option = 1;
    end

    function update(~, ~)
           if (pattern == 1 && res == 4 && option == 1)
               flushoutput(s);
               flushinput(s);
               fprintf(s, '%s', 'a'); % Sending '0' to turn on LED0
               flushoutput(s);
               flushinput(s);
               % fprintf(s, '%s', pattern); % Sending '0' to turn on LED0
               % flushoutput(s);
               % flushinput(s);
               % fprintf(s, '%s', 'b'); % Sending '0' to turn on LED0
               % flushoutput(s);
               % flushinput(s);
               % fprintf(s, '%s', res); % Sending '0' to turn on LED0
               % % Send command to turn on LED0
               % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
               % disp('Command sent: Live Video');
               disp(option);
               disp(pattern);
               disp(res);
           end

           if (pattern == 2 && res == 4 && option == 1)
               flushoutput(s);
               flushinput(s);
               fprintf(s, '%s', 'j'); % Sending '0' to turn on LED0
               flushoutput(s);
               flushinput(s);
               % fprintf(s, '%s', pattern); % Sending '0' to turn on LED0
               % flushoutput(s);
               % flushinput(s);
               % fprintf(s, '%s', 'b'); % Sending '0' to turn on LED0
               % flushoutput(s);
               % flushinput(s);
               % fprintf(s, '%s', res); % Sending '0' to turn on LED0
               % % Send command to turn on LED0
               % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
               % disp('Command sent: Live Video');
               disp(option);
               disp(pattern);
               disp(res);
           end

    end

    function reset(~,~)
        file = uigetfile('*.jpg');
        Name = file;
        file = double(imread(file));
        [r, g, b] = imsplit(file);
        xyz = [r(:), g(:), b(:)];
                %disp(xyz);
        %disp(length(xyz));
        % flushoutput(s);
        % flushinput(s);
        % disp(size(xyz));
        % for i=1:length(xyz)
        %     %disp(xyz(i, 1));
        %     R = xyz(i ,1);
        %     G = xyz(i, 2);
        %     B = xyz(i, 3); 
        %     fprintf(s, '%s', R); % Sending '0' to turn on LED0
        %     flushoutput(s);
        %     flushinput(s);
        %     fprintf(s, '%s', G); % Sending '0' to turn on LED0
        %     flushoutput(s);
        %     flushinput(s);
        %     fprintf(s, '%s', B); % Sending '0' to turn on LED0
        %     flushoutput(s);
        %     flushinput(s);
        % end 
        %    set(handles.edit1,'String', Name); % Displaying my string "Name" into my Edit Textbox.
        %    % flushoutput(s);
        %    % flushinput(s);
        %    % % Send command to turn on LED0
        %    % fprintf(s, '%s', '3'); % Sending '0' to turn on LED0
        %    % disp('Command sent: Live Video');
    end


    % Cleanup on close
    set(f, 'CloseRequestFcn', @(src, event) closeFigure(src));
end

function closeFigure(f)
    % Close the serial port
    %fclose(s);
    disp('UART communication closed.');
    %delete(s);
    delete(f);
end
