%% collections
clear all;
rcsource.owner          = 'flyTEM';
rcsource.project        = 'trautmane_test';
rcsource.stack          = 'montage_canvas_tier_0';
rcsource.service_host   = '10.40.3.162:8080';
rcsource.baseURL        = ['http://' rcsource.service_host '/render-ws/v1'];
rcsource.verbose        = 0;

rctarget.owner          = 'flyTEM';
rctarget.project        = 'trautmane_test';
rctarget.stack          = 'montage_canvas_tier_0_rigid';
rctarget.service_host   = '10.40.3.162:8080';
rctarget.baseURL        = ['http://' rctarget.service_host '/render-ws/v1'];
rctarget.verbose        = 0;

pm.server = 'http://10.40.3.162:8080/render-ws/v1';
pm.owner = 'flyTEM';
pm.match_collection = 'trautmane_test_montage_canvas_tier_0';
pm.verbose = 0;
%% solve options
opts.degree = 0;    % 1 = affine, 2 = second order polynomial, maximum is 3
    opts.solver = 'backslash';    
    opts.nbrs = 36;
    opts.nbrs_step = 1;
    opts.xs_weight = 1.0;
    opts.min_points = 3;
    opts.max_points = inf;
    opts.filter_point_matches = 1;
    
    opts.outlier_lambda = 1e2;  % large numbers result in fewer tiles excluded
    opts.min_tiles = 2; % minimum number of tiles that constitute a cluster to be solved. Below this, no modification happens
    opts.pastix.ncpus = 8;
    opts.pastix.parms_fn = '/nrs/flyTEM/khairy/FAFB00v13/matlab_production_scripts/params_file.txt';
    opts.pastix.split = 1; % set to either 0 (no split) or 1
    opts.matrix_only = 0;   % 0 = solve , 1 = only generate the matrix
    opts.distribute_A = 16;  % # shards of A
    opts.dir_scratch = '/scratch/ackermand';
    
    opts.distributed = 0;
    opts.disableValidation = 1;
    opts.use_peg = 0;
    
    % % configure point-match filter
    opts.pmopts.NumRandomSamplingsMethod = 'Desired confidence';
    opts.pmopts.MaximumRandomSamples = 5000;
    opts.pmopts.DesiredConfidence = 99.9;
    opts.pmopts.PixelDistanceThreshold = .1;
    opts.verbose = 1;
    opts.debug = 0;    
    
    opts.transfac = 1e-10;
 opts.lambda = 5E8;
        opts.edge_lambda = opts.lambda;    
        opts.constrain_by_z = 0;
    opts.sandwich = 0;
    opts.constraint_fac = 1e15;
    opts.filter_point_matches = 1;
    opts.save_matrix = 1;
    
    % configure solver
    opts.degree = 1;    % 1 = affine, 2 = second order polynomial, maximum is 3
    opts.solver = 'backslash';%'pastix';%'bicgstab';% %%'gmres';%'backslash';'pastix';
    % needed if iterative methods are used
    opts.use_ilu = 1;
    opts.ilu_droptol     = 1e-12;
    opts.ilu_type        = 'ilutp';%'crout'; %'nofill';%%;
    opts.ilu_udiag       = 1;
    opts.L2              = [];
    opts.U2              = [];
    opts.A               = [];
    opts.b               = [];
    opts.B               = [];
    opts.d               = [];
    opts.tB              = [];
    opts.td              = [];
    opts.W               = [];
    opts.dw              = [];
    opts.restart         = 10;
    opts.tol             = 1e-16;
    opts.maxit           = 20000;
    
    opts.outlier_lambda = 1e2;  % large numbers result in fewer tiles excluded
    opts.min_tiles = 2; % minimum number of tiles that constitute a cluster to be solved. Below this, no modification happens
    opts.pastix.ncpus = 8;
    opts.pastix.parms_fn = '/nrs/flyTEM/khairy/FAFB00v13/matlab_production_scripts/params_file.txt';
    opts.pastix.split = 1; % set to either 0 (no split) or 1
    opts.matrix_only = 0;   % 0 = solve , 1 = only generate the matrix
    opts.distribute_A = 16;  % # shards of A
    opts.dir_scratch = '/scratch/ackermand';
    
    opts.distributed = 0;
    opts.disableValidation = 1;
    opts.edge_lambda = opts.lambda;
    opts.use_peg = 0;
    
    % % configure point-match filter
    opts.pmopts.NumRandomSamplingsMethod = 'Desired confidence';
    opts.pmopts.MaximumRandomSamples = 5000;
    opts.pmopts.DesiredConfidence = 99.9;
    opts.pmopts.PixelDistanceThreshold = .1;
    opts.verbose = 1;
    opts.debug = 0;
    

nfirst = 1;
nlast = 3;

%%
sl.first_section = nfirst;
sl.last_section = nlast;
sl.solver_options = opts;
sl.source_collection = rcsource;
sl.target_collection = rctarget;
sl.source_point_match_collection = pm;
sl.verbose = 1;

fn = [pwd '/sample_system_solve_rigid_approximation_input.json'];
str = savejson('', sl);
fid = fopen(fn,'w');
fprintf(fid,str);
fclose(fid);
%% make sure we can read this file
options = loadjson(fileread(fn));


