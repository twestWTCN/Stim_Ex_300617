%% STN STIMULATOR EXPERIMENTAL ANALYSIS
% clear all; 
close all
% COMMAND PROGRAM - SETS ANALYSIS PROCEDURES
% dbstop if error
% dbclear if error
% HELLO WORLD!!!
%% Build header to be used for analysis programs
R = buildheader_stimex;
% Select methods
section = [1];    % Sections
procs = {[2:3]...           % Analysis
    []...           % Statistics
    [1]}...     % Plotting
    ;
for o = 1:length(section)
    switch section(o)
        %% EXTRACTION, PREPROCESSING and ANALYSIS
        case 1
            for i = 1:length(procs{section(o)})
                switch procs{section(o)}(i)
                    %% Data Preparation
                    case 1 % Data Conversion and headmodel build - only need to do this once!
%                         R.clear(1) = 0;
                        extract_continuous_loop_210616(R)
                    case 2
                        % Now read and convert to FT format
                        convertFT_260716(R)
                    case 3
                        % Preprocess Data
                        R.clear.pp = 1;
                        preprocess_stimex_110717(R)
                        dataviewer_stimex_110717(R)
                    case 4 % Preprocesing Long Epoch
                        %                         R.clear.ppe = 0;
                        R.longE_length = 10;
                        preprocess_longE_stimex_040816(R)
                        %% Spectral Analyses 
                    case 5 % Spectral analysis including coherence and WPLI
                        R.spectanaly.cplot = [0 0 0]; % Plotting options
                        spectralanalysis_stimex_110717(R)
%                         spectalanalysis_stimex_040816(R)
                        % - - - - - - - -
                        % Qs:
                    case 6
                        R.dfaae.bwid = [2.5 2.5 2.5];
                        R.dfaae.BF_r = -5;
                        R.dfaae.method.cfreq = 'powcen';
                        PEB_DFAAE_stimex_011116(R)
                end
            end
            %% STATISTICS
        case 2
            for i = 1:length(procs{section(o)})
                switch procs{section(o)}(i)
                    case 1 % Power Stats
                        R.clearer.statpow = 1;
                        stats_dir_pow_140817(R)
                    case 2 % DFA Stats
                        R = includeCoding(R);
                        DFA_stats_stimex_011116(R)
                end
            end
            
        case 3
            %% PLOTTING
            % set plot defaults
            set(0,'DefaultAxesFontSize',16)
            set(0,'defaultlinelinewidth',3)
            set(0,'DefaultLineMarkerSize',9)
            set(0, 'DefaultFigurePosition', [12    57   605   550]);
            %figure_clear(R)
            for i = 1:length(procs{section(o)})
                switch procs{section(o)}(i)
                    case 1
                        dataviewer_stimex_110717(R)
                    case 2 % Plot generic connectivity spectra
                        plot_pow_spectra_stat(R)
%                         R.spectra.featspecs = {'coherence','wpli'};
%                         plot_gen_stimex_statspectra_060317(R)
%                         plot_gen_statspectra_060317(R)
%                         plot_gen_stimex_spectra_040816(R)
                    case 3
                        DFA_boxplot_150817_subjectboxes(R) % Subject specific Boxplots
%                         DFA_boxplot_150817_groupmean
                    case 4
                        scatRegCor_150817(R) % Correlations for subjects
                end                        

            end
            close all
            
    end
end
