function GUI_update_feb26()

    % Set up variables to hold commands
    res = 4; % 640, 800, 1280, 1920
    option = 1; % 1, 2
    pattern = 1; % 1, 2, 3
    updated = 0; % 0, 1 Use in the updated textbox, set the text to different things
    reset_on = 0; % 0, 1;

    % Serial setup
    comPort = 'COM9'; % Serial Port
    baudRate = 115200; % Specified for UART
    %s = serial(comPort, 'BaudRate', baudRate);
    % Open the serial port
    %fopen(s);
    disp('UART communication opened.');

    % Create a figure for the GUI
    f = figure('Position', [300, 50, 1000, 700], 'Resize', 'off');
    f.Color='#9c9c9c';

    % Set up source options
    source_panel = uipanel(f, "Position", [0.1, 0.7, 0.8, 0.35], ...
        'BackgroundColor', '#dedede');

    bg_source = uibuttongroup('Parent', source_panel, ...
                          'Position', [0, 0, 1, 1], ... 
                          'FontSize', 12, ...
                          'Units', 'normalized',...
                          'BackgroundColor', '#dedede');

    % Live
    live = uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [50, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Live Video', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @livevideo);
    
    % Test Pattern 1
    tp1 = uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [300, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Geometric Pattern', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @testpattern1);
    
    % Test Pattern 2
    tp2 = uicontrol('Parent', bg_source, 'Style', 'togglebutton', ...
              'Position', [550, 60, 200, 70], ...
              'FontSize', 12, ...
              'String', 'Racing Cars Pattern', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @testpattern2);

    % Image download textbox
    status_text = uicontrol('Parent', source_panel, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0.075, 0.6, 0.1], ... 
                        'FontSize', 12, ...
                        'String', 'Select an Image To be Downloaded',...
                        'BackgroundColor', '#dedede');

    % Reset button
    reset_panel = uipanel(f, "Position", [0.75, 0.05, 0.15, 0.05]);
    rst_button = uicontrol('Parent', reset_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0, 0, 1, 1], ...  
              'FontSize', 10, ...
              'String', 'Reset', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @reset);


    % browse button
    uicontrol('Parent', source_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0.6, 0.075, 0.2, 0.15], ...  
              'FontSize', 10, ...
              'String', 'Browse', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @image_download);


    drawnow;  % Ensure UI components are fully initialized
    bg_source.SelectedObject = [];  % Clear any selected button

    % Name it "Source"
    uicontrol(source_panel, 'Style', 'text', ...
          'Position', [140, 140, 500, 50], ...
          'String', '1. Select a Source', 'FontSize', 24, ...
           'BackgroundColor', '#dedede');
    
    % Set up resolution options
    res_panel = uipanel(f, "Position", [0.1, 0.25, 0.3, 0.4],...
                          'BackgroundColor', '#dedede');
    
    % Name "Resolution"
    uicontrol(res_panel, 'Style', 'text', ...
          'Position', [50, 175, 200, 100], ...
          'String', '2. Resolution', 'FontSize', 24,...
          'BackgroundColor', '#dedede');
    
    % Buttongroup, only ome radiobutton is selected
    bg = uibuttongroup('Parent', res_panel, ...
               'Position', [0.1, 0.1, 0.8, 0.65], ...
               'Units', 'normalized',...
               'BackgroundColor', '#dedede');  

    % 640
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 140, 150, 30], ...
              'String', '640 x 480', ...
              'FontSize', 14, ...
              'Units', 'pixels', ...
              'BackgroundColor', '#dedede',...  
              'Callback', @res640);

    % 800
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 100, 150, 30], ...
              'String', '800 x 600', ...
              'FontSize', 14, ...
              'BackgroundColor', '#dedede',... 
              'Units', 'pixels', ...  
              'Callback', @res800);

    % 1280
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 60, 150, 30], ...
              'String', '1280 x 720', ...
              'FontSize', 14, ...
              'BackgroundColor', '#dedede',... 
              'Units', 'pixels', ...  
              'Callback', @res1280);

    % 1920
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
              'Position', [10, 20, 150, 30], ...
              'String', '1080 x 1920', ...
              'FontSize', 14, ...
              'BackgroundColor', '#dedede',... 
              'Units', 'pixels', ...  
              'Callback', @res1920);

    drawnow;  % Ensure UI components are fully initialized
    bg.SelectedObject = [];  % Clear any selected button

    % Set up processing options
    sink_panel = uipanel(f, "Position", [0.45, 0.25, 0.45, 0.4], ...
        'BackgroundColor', '#dedede');

    bg_process = uibuttongroup('Parent', sink_panel, ...
                           'Position', [0, 0, 1, 1], ... 
                           'Units', 'normalized',...
                           'BackgroundColor', '#dedede');

    % Monitor 1
    mon1 = uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.02, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'HDMI Monitor', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @option1);
    
    % Monitor 2
    mon2 = uicontrol('Parent', bg_process, 'Style', 'togglebutton', ...
              'Units', 'normalized', ...
              'Position', [0.53, 0.2, 0.45, 0.5], ...
              'FontSize', 12, ...
              'String', 'VGA Monitor', ...
              'BackgroundColor', "#abdbe3",...
              'Callback', @option2);
   
    % Name "Output Monitor"
    uicontrol(sink_panel, 'Style', 'text', ...
          'Position', [80, 210, 300, 50], ...
          'String', '3. Select an Output', 'FontSize', 24,...
          'BackgroundColor', '#dedede');

    drawnow;  % Ensure UI components are fully initialized
    bg_process.SelectedObject = [];  % Clear any selected button

    % Update button
    up_panel = uipanel(f, "Position", [0.35, 0.13, 0.3, 0.08],...
        'BackgroundColor', '#dedede');

    % Textbox to update user on the changes
    textbox = uipanel(f, "Position", [0.1, 0.05, 0.6, 0.05],...
        'BackgroundColor', '#dedede');

    status_text1 = uicontrol('Parent', textbox, 'Style', 'text', ...
                        'Units', 'normalized', ...
                        'Position', [0, 0, 1, 1], ...
                        'FontSize', 12, ...
                        'BackgroundColor', "white",...
                        'String', 'Make a Selection');

    up = uicontrol('Parent', up_panel, 'Style', 'pushbutton', ...
              'Units', 'normalized', ...  
              'Position', [0, 0, 1, 1], ... 
              'FontSize', 14, ...
              'String', 'Update', ...
              'BackgroundColor', "#78c278", ...
              'Callback', @(src, event) update(status_text1)); % Main Callback

    % All the functions to send an ASCII code through UART

    function testpattern1(~, ~)
        % Update global variable
        pattern = 1;
        live.BackgroundColor = "#abdbe3";
        tp1.BackgroundColor = "#439dd9";
        tp2.BackgroundColor = "#abdbe3";
        up.BackgroundColor = "#78c278";
    end

    function testpattern2(~, ~)
        % Update global variable
        pattern = 2;
        live.BackgroundColor = "#abdbe3";
        tp1.BackgroundColor = "#abdbe3";
        tp2.BackgroundColor = "#439dd9";
        up.BackgroundColor = "#78c278";
    end

    function livevideo(~, ~)
        % Update global variable
        pattern = 3;
        live.BackgroundColor = "#439dd9";
        tp1.BackgroundColor = "#abdbe3";
        tp2.BackgroundColor = "#abdbe3";
        up.BackgroundColor = "#78c278";
    end

    function res640(~, ~)
       % Update global variable
        res = 4;
        up.BackgroundColor = "#78c278";
    end

    function res800(~, ~)
        % Update global variable
        res = 5;
        up.BackgroundColor = "#78c278";
    end

    function res1280(~, ~)
       % Update global variable
        res = 6;
        up.BackgroundColor = "#78c278";
    end

    function res1920(~, ~)
       % Update global variable
        res = 7;
        up.BackgroundColor = "#78c278";
    end

    function option1(~, ~)
       % Update global variable
       option = 0;
       mon1.BackgroundColor = "#439dd9";
       mon2.BackgroundColor = "#abdbe3";
       up.BackgroundColor = "#78c278";
    end

    function option2(~, ~)
       % Update global variable
       option = 1;
       mon1.BackgroundColor = "#abdbe3";
       mon2.BackgroundColor = "#439dd9";
       up.BackgroundColor = "#78c278";
    end

    function update(status)
       mon1.BackgroundColor = "#abdbe3";
       mon2.BackgroundColor = "#abdbe3";
       up.BackgroundColor = "#219c60";
       live.BackgroundColor = "#abdbe3";
       tp1.BackgroundColor = "#abdbe3";
       tp2.BackgroundColor = "#abdbe3";
       % All UART Functions
       if (pattern == 1 && res == 4 && option == 0 && reset_on == 0)
           status.String = "Geometric Pattern, 640x480p, HDMI Monitor";
       %     % Test Pattern 1, 640, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'a'); % a
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 5 && option == 0 && reset_on == 0)
           status.String = "Geometric Pattern, 800x600p, HDMI Monitor";
       %     % Test Pattern 1, 800, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'b'); % b
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 6 && option == 0 && reset_on == 0)
           status.String = "Geometric Pattern, 1280x720p, HDMI Monitor";
       %     % Test Pattern 1, 1280, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'c'); % c
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 7 && option == 0 && reset_on == 0)
           status.String = "Geometric Pattern, 1920x1080p, HDMI Monitor";
       %     % Test Pattern 1, 1920, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'd'); % d
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 4 && option == 1 && reset_on == 0)
           status.String = "Geometric Pattern, 640x480p, VGA Monitor";
       %     % Test Pattern 1, 640, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'e'); % e
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 5 && option == 1 && reset_on == 0)
           status.String = "Geometric Pattern,800x600p, VGA Monitor";
       %     % Test Pattern 1, 800, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'f'); % f
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 6 && option == 1 && reset_on == 0)
           status.String = "Geometric Pattern, 1280x720p, VGA Monitor";
       %     % Test Pattern 1, 1280, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'g'); % g
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 1 && res == 7 && option == 1 && reset_on == 0)
           status.String = "Geometric Pattern, 1920x1080p, VGA Monitor";
       %     % Test Pattern 1, 1920, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'h'); % h
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 4 && option == 0 && reset_on == 0)
           status.String = "Racing Cars Pattern, 640x480p, HDMI Monitor";
       %     % Test Pattern 2, 640, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'i'); % i
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 5 && option == 0 && reset_on == 0)
           status.String = "Racing Cars Pattern, 800x600p, HDMI Monitor";
       %     % Test Pattern 2, 800, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'j'); % j
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 6 && option == 0 && reset_on == 0)
           status.String = "Racing Cars Pattern, 1280x720p, HDMI Monitor";
       %     % Test Pattern 2, 1280, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'k'); % k
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 7 && option == 0 && reset_on == 0)
           status.String = "Racing Cars Pattern, 1920x1080p, HDMI Monitor";
       %     % Test Pattern 2, 1920, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'l'); % l
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 4 && option == 1 && reset_on == 0)
           status.String = "Racing Cars Pattern, 640x480p, VGA Monitor";
       %     % Test Pattern 2, 640, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'm'); % m
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 5 && option == 1 && reset_on == 0)
           status.String = "Racing Cars Pattern, 800x600p, VGA Monitor";
       %     % Test Pattern 2, 800, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'n'); % n
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 6 && option == 1 && reset_on == 0)
           status.String = "Racing Cars Pattern, 1280x720p, VGA Monitor";
       %     % Test Pattern 2, 1280, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'o'); % o
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 2 && res == 7 && option == 1 && reset_on == 0)
           status.String = "Racing Cars Pattern, 1920x1080p, VGA Monitor";
       %     % Test Pattern 2, 1920, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'p'); % p
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 4 && option == 0 && reset_on == 0)
           status.String = "Live Video, HDMI monitor";
       %     % Live, 640, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'q'); % q
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 5 && option == 0 && reset_on == 0)
           status.String = "Live Video, HDMI monitor";
       %     % Live, 800, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'r'); % r
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 6 && option == 0 && reset_on == 0)
           status.String = "Live Video, HDMI monitor";
       %     % Live, 1280, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 's'); % s
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 7 && option == 0 && reset_on == 0)
           status.String = "Live Video, HDMI monitor";
       %     % Live, 1920, monitor 1
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 't'); % t
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 4 && option == 1 && reset_on == 0)
           status.String = "Live Video, VGA monitor";
       %     % Live, 640, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'u'); % u
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 5 && option == 1 && reset_on == 0)
           status.String = "Live Video, VGA monitor";
       %     % Live, 800, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'v'); % v
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 6 && option == 1 && reset_on == 0)
           status.String = "Live Video, VGA monitor";
       %     % Live, 1280, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'w'); % w
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (pattern == 3 && res == 7 && option == 1 && reset_on == 0)
           status.String = "Live Video, VGA monitor";
       %     % Live, 1920, monitor 2
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'x'); % x
       %     flushoutput(s);
       %     flushinput(s);
       end
       if (reset_on == 1)
           status.String = "Reset";
       %     % reset
       %     flushoutput(s);
       %     flushinput(s);
       %     fprintf(s, '%s', 'y'); % y
       %     flushoutput(s);
       %     flushinput(s);
            reset_on = 0; % Put the reset back to 0
       end

    end

    function image_download(~,~)
        file = uigetfile({'*.jpg';'*.png';'*.bmp'}, 'File Selector'); % Get image file
        % run for jpg, not png?, works for bmp
        %file = uigetfile('*.jpg'); % Get image file
        Name = file; % set Name in textbox
        disp(file);
        file = double(imread(file)); % Convert to RGBs
        [r, g, b] = imsplit(file);
        xyz = [r(:), g(:), b(:)];

        % Send pixel enable
        %flushoutput(s);
        %flushinput(s);
        %fprintf(s, '%s', 0);
        %flushoutput(s);
        %flushinput(s);
       
        % Send HRes
        info = imfinfo(Name);
        hres = info.Width;
        vres = info.Height;
        %disp(class(hres)); % double
        %disp(class(vres));
        %flushoutput(s);
        %flushinput(s);
        %fprintf(s, '%s', hres);
        %flushoutput(s);
        %flushinput(s);

        %Send vres
        %flushoutput(s);
        %flushinput(s);
        %fprintf(s, '%s', vres);
        %flushoutput(s);
        %flushinput(s);

        for i=1:length(xyz)
            R = xyz(i ,1);
            G = xyz(i, 2);
            B = xyz(i, 3); 
            % Convert the 24 bit RGB to 8 bit RGB
            color = int8(bitsll((R * 7 / 255), 5) + bitsll((G * 7 / 255), 2)  + (B * 3 / 255));
            color = double(color);
            if color == 0
                color = 1;
            end
           % disp(color);
            % flushoutput(s);
            % flushinput(s);
            %fprintf(s, '%s', color); % Send pixel
        %     flushoutput(s);
        %     flushinput(s);
         end
        % 
        % % Send pixel disable
        % flushoutput(s);
        % flushinput(s);
        %fprintf(s, '%s', 0);

        % flushoutput(s);
        % flushinput(s);

    end

    function reset(~,~)
        reset_on = 1;
        update(status_text1); % Call the update to send the reset through UART
    end

    % Cleanup on close
    %set(f, 'CloseRequestFcn', @(src, event) closeFigure(src, s));
    set(f, 'CloseRequestFcn', @(src, event) closeFigure(src));
end

function closeFigure(f)
    % Close the serial port
    %fclose(s);
    disp('UART communication closed.');
    %delete(s);
    delete(f);
end
