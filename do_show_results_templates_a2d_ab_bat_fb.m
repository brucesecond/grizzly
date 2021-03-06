%% Analysis of template attacks for experiment E2 on different boards
% Experiment E2 consists measuring power consumption of several load
% instructions while varying the data values of one of the load
% instructions and keeping the others fixed.
%
% See the file grizzly/readme.txt for details of the datasets.
%
% In this script I compare the results of the template attacks as
% implemented on the same device vs implementing them on different devices.
%
% Author: Omar Choudary

%% Reset environment
close all;
clear;
set(0, 'DefaulttextInterpreter', 'latex'); % Use TeX interpretation
tic

%% Setup paths and parameters
data_path = '/anfs/bigdisc/osc22/data/grizzly/';
fdata = 'results/a2d_ab_bat_fb_templates_dlinear_n1000r_slr_g1000_r10.mat';
rpath = 'figures/';
font_size = 24;
options = 'g';
yrange = [0, 7];
nr_traces_vec = [1:10, 20:10:100, 200, 500, 1000];
len_na_vec = length(nr_traces_vec);

%% Load data for templates from Alpha used on Beta (using DOM)
data = load(fdata);
results = data.results;
np = size(results{1}.x_profile, 1);
rand_iter_ab = results{1}.rand_iter;
nr_exp = size(data.results, 1);
L_ab = cell(nr_exp, 1);
G_ab = zeros(nr_exp, len_na_vec);
slines_ab = cell(nr_exp, 1);
style = 'normal';
for k=1:nr_exp
    if strcmp(results{k}.cmethod, 'sample')
        L_ab{k} = sprintf('%s, %s', ...
            results{k}.cmethod, results{k}.cparams.sel);
    elseif strcmp(results{k}.cmethod, 'PCA')
        L_ab{k} = sprintf('%s, m=%d', ...
            results{k}.cmethod, results{k}.cparams.pca_dimensions);            
    elseif strcmp(results{k}.cmethod, 'LDA')
        L_ab{k} = sprintf('%s, m=%d', ...
            results{k}.cmethod, results{k}.cparams.lda_dimensions);
    end
    g = get_ge_from_success_info(results{k}.success_info, nr_traces_vec);
    G_ab(k,:) = g.joint;
    uid = get_uid_cmethod(results{k}.cmethod, results{k}.cparams);
    slines_ab{k} = get_line_properties_templates(uid, style);
end

%% Plot results
title_results = sprintf('AB BAT FB, np=%d', np);
rprefix = sprintf('a2d_ab_bat_fb_dlinear_n%dr_ls_r%d_', np, rand_iter_ab);
make_figures_ge(G_ab, nr_traces_vec, ...
                     rpath, rprefix, ...
                     title_results, L_ab, font_size, ...
                     slines_ab, options, yrange);

return; % Comment this line if you have also the results for the Beta Bis dataset                     
                 
%% Load data for templates from Beta used on Beta (dif. campaign)
fdata = 'results/a2d_bb_bat_fb_templates_dlinear_n1000r_slr_g1000_r10.mat';
data = load(fdata);
results = data.results;
np = size(results{1}.x_profile, 1);
rand_iter_bb = results{1}.rand_iter;
nr_exp = size(data.results, 1);
L_bb = cell(nr_exp, 1);
G_bb = zeros(nr_exp, len_na_vec);
slines_bb = cell(nr_exp, 1);
style = 'normal';
for k=1:nr_exp
    if strcmp(results{k}.cmethod, 'sample')
        L_bb{k} = sprintf('%s, %s', ...
            results{k}.cmethod, results{k}.cparams.sel);
    elseif strcmp(results{k}.cmethod, 'PCA')
        L_bb{k} = sprintf('%s, K=%d', ...
            results{k}.cmethod, results{k}.cparams.pca_dimensions);            
    elseif strcmp(results{k}.cmethod, 'LDA')
        L_bb{k} = sprintf('%s, K=%d', ...
            results{k}.cmethod, results{k}.cparams.lda_dimensions);
    end
    g = get_ge_from_success_info(results{k}.success_info, nr_traces_vec);
    G_bb(k,:) = g.joint;
    uid = get_uid_cmethod(results{k}.cmethod, results{k}.cparams);
    slines_bb{k} = get_line_properties_templates(uid, style);
end

%% Plot results
title_results = sprintf('BB BAT FB, np=%d', np);
rprefix = sprintf('a2d_bb_bat_fb_dlinear_n%dr_ls_r%d_', np, rand_iter_bb);
make_figures_ge(G_bb, nr_traces_vec, ...
                     rpath, rprefix, ...
                     title_results, L_bb, font_size, ...
                     slines_bb, options, yrange);                 
                 
%% Exit the matlab interpreter, needed when run in script mode
% exit

