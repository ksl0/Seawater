BASEDIR = '/Users/katie/Desktop/ModelingSeawater/workspace';
mass_file = 'TestA.mass';
PROFILES = {'profile5.30.mat', 'profile5.21.mat'};
DISC= {'disc134_800', 'disc134_1600', 'disc268_800', 'disc268_1600', 'disc536_800'};
num_profiles = numel(PROFILES);
num_disc = numel(DISC); 
total_plots = numel(PROFILES)* numel(DISC); % find the total number of plots to create


%% Plot all the figures because fuck it why not

plotNum = 1; %set a counter for the subplot
fig = figure; %create new figure
pattern_disc =  '(disc|_)';
hold on;

for p = PROFILES
    for d = DISC
        disc = char(d); profile = char(p); %annoying conversion factor for cells
        scripts_dir = sprintf('%s/%s', BASEDIR, 'processing');
                input_dir = sprintf('%s/%s/%s', BASEDIR, disc, profile);

        cd(scripts_dir);

        foo = regexp(disc, pattern_disc, 'split');
        z_cells = str2double(foo{2}); y_cells = str2double(foo{3});
        
        [m, ~, ~,~] = loadFileData(input_dir);%get data from mass file
        total_mass_in_aquifer = m.data(:,7); %column 7 is the total mass in aquifer
        avg_mass = mean(total_mass_in_aquifer);
        mass_diff = (total_mass_in_aquifer-avg_mass)./avg_mass*100; %get percentage difference
        subplot(num_profiles, num_disc, plotNum);
        plot(m.data(:,1),mass_diff, '-ks', ...  
        'LineWidth',2,...
        'MarkerSize',1,...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor', 'b');
        xlabel('time (years)');
        ylabel('%Change for Mass in Aquifer');
        fig_title = sprintf('%d x %d, %s',z_cells, y_cells, profile);
        title(fig_title);
        
        cd(scripts_dir);
        filename = sprintf('%s_%sTotalMass.jpg', disc, profile);
        line(xlim,[0,0], 'Color', 'k'); %draw xaxis
     % saveas(fig, filename);
        axis tight;
        axis([-50, 50000, -.5, .5]); %set axis
        plotNum = plotNum+1;
    end
end


%hold off;