function GUI_update_feb17()

    % Set up variables to hold commands
    res = 4; % 640, 800, 1280, 1920
    option = 1; % 1, 2
    pattern = 1; % 1, 2, 3
    updated = 0; % 0, 1 Use in the updated textbox, set the text to different things
    reset_on = 0; % 0, 1;

    % Serial setup
    comPort = 'COM1'; % Serial Port
    baudRate = 115200; % Specified for UART
    %s = serial(comPort, 'BaudRate', baudRate);
    % Open the serial port
    %fopen(s);
    disp('UART communication opened.');

    % Create a figure for the GUI
    f = figure('Position', [300, 50, 1000, 700], 'Resize', 'off');
    f.Color='#5b625a';

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

    % Image download textbox
    status_text = uicontrol('Parent', source_panel, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0.075, 0.6, 0.1], ... 
                        'FontSize', 12, ...
                        'String', 'Select an Image To be Downloaded',...
                        'BackgroundColor', '#888c87');

    % Reset button
    reset_panel = uipanel(f, "Position", [0.75, 0.05, 0.15, 0.05]);
    rst_button = uicontrol('Parent', reset_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0, 0, 1, 1], ...  
              'FontSize', 10, ...
              'String', 'Reset', ...
              'BackgroundColor', "#f97c7f",...
              'Callback', @reset);


    % browse button
    uicontrol('Parent', source_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0.6, 0.075, 0.2, 0.15], ...  
              'FontSize', 10, ...
              'String', 'Browse', ...
              'BackgroundColor', "#4DBEEE",...
              'Callback', @image_download);


    drawnow;  % Ensure UI components are fully initialized
    bg_source.SelectedObject = [];  % Clear any selected button

    % Name it "Source"
    uicontrol(source_panel, 'Style', 'text', ...
          'Position', [300, 140, 200, 50], ...
          'String', 'Source', 'FontSize', 24, ...
           'BackgroundColor', '#888c87');
    
    % Set up resolution options
    res_panel = uipanel(f, "Position", [0.1, 0.25, 0.3, 0.4],...
                          'BackgroundColor', '#888c87');
    
    % Name "Resolution"
    uicontrol(res_panel, 'Style', 'text', ...
          'Position', [50, 175, 200, 100], ...
          'String', 'Resolution', 'FontSize', 24,...
          'BackgroundColor', '#888c87');
    
    % Buttongroup, only ome radiobutton is selected
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
              'BackgroundColor', '#888c87',...  
              'Callback', @res640);

    % 800
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 100, 150, 30], ...
              'String', '800 x 600', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  
              'Callback', @res800);

    % 1280
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 60, 150, 30], ...
              'String', '1280 x 720', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  
              'Callback', @res1280);

    % 1920
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 20, 150, 30], ...
              'String', '1080 x 1920', ...
              'FontSize', 14, ...
              'BackgroundColor', '#888c87',... 
              'Units', 'pixels', ...  
              'Callback', @res1920);

    drawnow;  % Ensure UI components are fully initialized
    bg.SelectedObject = [];  % Clear any selected button

    % Set up processing options
    sink_panel = uipanel(f, "Position", [0.45, 0.25, 0.45, 0.4], ...
        'BackgroundColor', '#888c87');

    bg_process = uibuttongroup('Parent', sink_panel, ...
                           'Position', [0, 0, 1, 1], ... 
                           'Units', 'normalized',...
                           'BackgroundColor', '#888c87');

    % Monitor 1
    uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.02, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'Monitor 1', ...
              'BackgroundColor', "#f394ed",...
              'Callback', @option1);
    
    % Monitor 2
    uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.53, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'Monitor 2', ...
              'BackgroundColor', "#f394ed",...
              'Callback', @option2);
   
    % Name "Output Monitor"
    uicontrol(sink_panel, 'Style', 'text', ...
          'Position', [80, 210, 300, 50], ...
          'String', 'Output Monitor', 'FontSize', 24,...
          'BackgroundColor', '#888c87');

    drawnow;  % Ensure UI components are fully initialized
    bg_process.SelectedObject = [];  % Clear any selected button

    % Update button
    up_panel = uipanel(f, "Position", [0.35, 0.13, 0.3, 0.08],...
        'BackgroundColor', '#888c87');

    uicontrol('Parent', up_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0, 0, 1, 1], ... 
              'FontSize', 14, ...
              'String', 'Update', ...
              'BackgroundColor', "#77AC30", ...
              'Callback', @update); % Main Callback

    % Textbox to update user on the changes
    textbox = uipanel(f, "Position", [0.1, 0.05, 0.6, 0.05],...
        'BackgroundColor', '#888c87');

    status_text1 = uicontrol('Parent', textbox, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0, 1, 1], ...
                        'FontSize', 12, ...
                        'BackgroundColor', "white",...
                        'String', 'Updated Test Pattern 1, 640x480, Monitor 1');

    % All the functions to send an ASCII code through UART

    function testpattern1(~, ~)
        % Update global variable
        pattern = 1;
    end

    function testpattern2(~, ~)
        % Update global variable
        pattern = 2;
    end

    function livevideo(~, ~)
        % Update global variable
        pattern = 3;
    end

    function res640(~, ~)
       % Update global variable
        res = 4;
    end

    function res800(~, ~)
        % Update global variable
        res = 5;
    end

    function res1280(~, ~)
       % Update global variable
        res = 6;
    end

    function res1920(~, ~)
       % Update global variable
        res = 7;
    end

    function option1(~, ~)
       % Update global variable
       option = 0;
    end

    function option2(~, ~)
       % Update global variable
       option = 1;
    end

    function update(~, ~)
        % All UART Functions
       if (pattern == 1 && res == 4 && option == 0 && reset_on == 0)
           % Test Pattern 1, 640, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'a'); % a
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 5 && option == 0 && reset_on == 0)
           % Test Pattern 1, 800, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'b'); % b
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 6 && option == 0 && reset_on == 0)
           % Test Pattern 1, 1280, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'c'); % c
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 7 && option == 0 && reset_on == 0)
           % Test Pattern 1, 1920, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'd'); % d
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 4 && option == 1 && reset_on == 0)
           % Test Pattern 1, 640, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'e'); % e
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 5 && option == 1 && reset_on == 0)
           % Test Pattern 1, 800, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'f'); % f
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 6 && option == 1 && reset_on == 0)
           % Test Pattern 1, 1280, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'g'); % g
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 1 && res == 7 && option == 1 && reset_on == 0)
           % Test Pattern 1, 1920, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'h'); % h
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 4 && option == 0 && reset_on == 0)
           % Test Pattern 2, 640, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'i'); % i
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 5 && option == 0 && reset_on == 0)
           % Test Pattern 2, 800, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'j'); % j
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 6 && option == 0 && reset_on == 0)
           % Test Pattern 2, 1280, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'k'); % k
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 7 && option == 0 && reset_on == 0)
           % Test Pattern 2, 1920, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'l'); % l
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 4 && option == 1 && reset_on == 0)
           % Test Pattern 2, 640, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'm'); % m
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 5 && option == 1 && reset_on == 0)
           % Test Pattern 2, 800, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'n'); % n
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 6 && option == 1 && reset_on == 0)
           % Test Pattern 2, 1280, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'o'); % o
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 2 && res == 7 && option == 1 && reset_on == 0)
           % Test Pattern 2, 1920, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'p'); % p
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 4 && option == 0 && reset_on == 0)
           % Live, 640, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'q'); % q
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 5 && option == 0 && reset_on == 0)
           % Live, 800, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'r'); % r
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 6 && option == 0 && reset_on == 0)
           % Live, 1280, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 's'); % s
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 7 && option == 0 && reset_on == 0)
           % Live, 1920, monitor 1
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 't'); % t
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 4 && option == 1 && reset_on == 0)
           % Live, 640, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'u'); % u
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 5 && option == 1 && reset_on == 0)
           % Live, 800, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'v'); % v
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 6 && option == 1 && reset_on == 0)
           % Live, 1280, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'w'); % w
           flushoutput(s);
           flushinput(s);
       end
       if (pattern == 3 && res == 7 && option == 1 && reset_on == 0)
           % Live, 1920, monitor 2
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'x'); % x
           flushoutput(s);
           flushinput(s);
       end
       if (reset_on == 1)
           % reset
           flushoutput(s);
           flushinput(s);
           fprintf(s, '%s', 'y'); % y
           flushoutput(s);
           flushinput(s);
           reset_on = 0; % Put the reset back to 0
       end

    end

    function image_download(~,~)
        file = uigetfile('*.jpg'); % Get image file
        Name = file; % set Name in textbox
        file = double(imread(file)); % Convert to RGBs
        [r, g, b] = imsplit(file);
        xyz = [r(:), g(:), b(:)];

        % Send pixel enable
        flushoutput(s);
        flushinput(s);
        fprintf(s, '%s', 0);
        flushoutput(s);
        flushinput(s);
       
        for i=1:length(xyz)
            R = xyz(i ,1);
            G = xyz(i, 2);
            B = xyz(i, 3); 
            % Convert the 24 bit RGB to 8 bit RGB
            color = int8(bitsll((R * 7 / 255), 5) + bitsll((G * 7 / 255), 2)  + (B * 3 / 255));
            flushoutput(s);
            flushinput(s);
            fprintf(s, '%s', color); % Send pixel
            flushoutput(s);
            flushinput(s);
        end

        % Send pixel disable
        flushoutput(s);
        flushinput(s);
        fprintf(s, '%s', 0);
        flushoutput(s);
        flushinput(s);
    end

    function reset(~,~)
        reset_on = 1;
        update(); % Call the update to send the reset through UART
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
