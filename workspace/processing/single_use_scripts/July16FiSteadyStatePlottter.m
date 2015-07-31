BASEDIR = '/Users/katie/Desktop/ModelingSeawater/workspace';
mass_file = 'TestA.mass';
PROFILES = {'profile5.30.mat', 'profile5.21.mat'};
DISC= {'disc134_800', 'disc134_1600', 'disc268_800', 'disc268_1600'};
num_profiles = numel(PROFILES);
num_disc = numel(DISC); 
total_plots = numel(PROFILES)* numel(DISC); % find the total number of plots to create


%% Plot all the figures 

plotNum = 1; %set a counter for the subplot
fig = figure; %create new figure
pattern_disc =  '(disc|_)';
hold on;
RECORDS = 101;

for p = PROFILES
    for d = DISC

        disc = char(d); profile = char(p); %annoying conversion factor for cells
        scripts_dir = sprintf('%s/%s', BASEDIR, 'processing');
        input_dir = sprintf('%s/%s/%s/', BASEDIR, disc, profile);

        cd(scripts_dir);

        foo = regexp(disc, pattern_disc, 'split');
        z_cells = str2double(foo{2}); y_cells = str2double(foo{3});
         
        massfile = sprintf('%s%s',input_dir, mass_file);
        m = importdata(massfile);
        total_mass_in_aquifer = m.data(:,7); %column 7 is the total mass in aquifer
        first_mass = total_mass_in_aquifer(1);
        mass_diff = (total_mass_in_aquifer-first_mass)./first_mass*100; %get percentage difference
        time = m.data(:,1)/(60*60*24*365);
        
        subplot(num_profiles, num_disc, plotNum);
        
        
        plot(time,mass_diff, '-ks', ...  
        'LineWidth',2,...
        'MarkerSize',1,...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor', 'b');
     
        ylabel('Total % Mass Change')
        fig_title = sprintf('%d x %d',z_cells, y_cells);
        
        cd(scripts_dir);
        filename = sprintf('%s_%sTotalMass.jpg', disc, profile);
        line(xlim,[0,0], 'Color', 'k'); %draw xaxis
     % saveas(fig, filename);
     
        if strcmp('profile5.30.mat', profile)
          title(fig_title);
          axis([-10,  max(time)+10, -.12, 0 ]); %set axis
        else
          xlabel('Time, years');
          axis([-10, max(time)+10, -.1, .6]); %set axis
        end
        
        results(plotNum).mass = total_mass_in_aquifer;
        results(plotNum).profile = profile;
        results(plotNum).disc = disc;
        plotNum = plotNum+1;
    end
end


%hold off;