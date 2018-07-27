clc; close all; clear;
addpath('utils/');

dt_name = 'TOSCA_Isometric';
% dt_name = 'TOSCA_nonIsometric';
% dt_name = 'FAUST';
iPair = 1;
%%
switch dt_name
    case 'FAUST'
        plotOptions = {'IfShowCoverage',false, 'OverlayAxis','y', 'cameraPos',[0,90]};
    otherwise
        plotOptions = {'IfShowCoverage',false};
end
%%
mesh_dir = ['Dataset/',dt_name,'/vtx_5k/'];
corres_dir = [mesh_dir,'corres/'];
maps_dir = [mesh_dir,'maps/'];
seg_dir = [mesh_dir,'segmentation/'];
%% read the list of all the tested pairs
fid = fopen(['Dataset/',dt_name,'/test_pairs.txt']);
test_pairs = textscan(fid,'%s\t%s');
fclose(fid);
test_pairs = horzcat(test_pairs{:});
%% load the meshes
s1_name = test_pairs{iPair,1};
s2_name = test_pairs{iPair,2};
fprintf('Test pair: %s v.s. %s \n',s1_name, s2_name);
S1 = MESH.MESH_IO.read_shape([mesh_dir, s1_name]);
S2 = MESH.MESH_IO.read_shape([mesh_dir, s2_name]);
%% load the segmentation
% .seg: is segmentation without breaking the symmetry
% .seg.nonsym: breaks the symmetry of .seg
[seg1, seg2] = FILE_IO.read_segmentation(seg_dir, s1_name, s2_name, 'nonsym');
figure(1);
subplot(1,2,1); MESH.PLOT.plot_mesh_patches(S1,seg1); title(S1.name,'Interpreter','none')
subplot(1,2,2); MESH.PLOT.plot_mesh_patches(S2,seg2); title(S2.name,'Interpreter','none')
%% load the ground-truth correspondence
lmk1 = FILE_IO.read_landmarks([corres_dir,S1.name]);
lmk2 = FILE_IO.read_landmarks([corres_dir,S2.name]);

lmk1_sym = FILE_IO.read_landmarks([corres_dir,S1.name,'.sym.vts']);
lmk2_sym = FILE_IO.read_landmarks([corres_dir,S2.name,'.sym.vts']);
T12gt = nan(S1.nv,1); T12gt(lmk1) = lmk2;
T12gt_sym = nan(S1.nv,1); T12gt_sym(lmk1) = lmk2_sym;

figure(2);
subplot(1,2,1); MESH.PLOT.visualize_map_colors(S1,S2,T12gt,plotOptions{:}); title('direct ground-truth map')
subplot(1,2,2); MESH.PLOT.visualize_map_colors(S1,S2,T12gt_sym, plotOptions{:}); title('symmetric ground-truth map')

%% load the maps
T12_bim = FILE_IO.read_map([maps_dir,'BIM/',s1_name,'_',s2_name],'base',0);
T21_bim = FILE_IO.read_map([maps_dir,'BIM/',s2_name,'_',s1_name],'base',0);

mtd_names = {'BIM', 'WKSini_direct','WKSini_direct_BCICP', ...
    'WKSini_symm', 'WKSini_symm_BCICP','SEGini_direct_BCICP'};
all_T12 = cell(length(mtd_names),1);
all_T21 = cell(length(mtd_names),1);
for i = 1:length(mtd_names)
    m_name = mtd_names{i};
    if strcmp(m_name,'BIM'), map_base = 0; else, map_base = 1; end;
    
    all_T12{i} = FILE_IO.read_map([maps_dir,m_name,'/',s1_name,'_',s2_name],'base',map_base);
    all_T21{i} = FILE_IO.read_map([maps_dir,m_name,'/',s2_name,'_',s1_name],'base',map_base);
end


figure(3);
for i = 1:length(mtd_names)
    subplot(2,length(mtd_names),i);
    cov = MESH.PLOT.visualize_map_colors(S1,S2,all_T12{i},plotOptions{:});
    title({mtd_names{i}, ['coverage = ',num2str(cov,'%.2f'),'%']},'Interpreter','none');
    
    subplot(2, length(mtd_names),i + length(mtd_names));
    cov = MESH.PLOT.visualize_map_colors(S2,S1,all_T21{i},plotOptions{:});
    title({mtd_names{i}, ['coverage = ',num2str(cov,'%.2f'),'%']},'Interpreter','none');
  
end
return
%% measure the maps
% pre-compute the geodesic distance matrix
mesh_options = {'IfComputeGeoDist',true,...
    'IfComputeLB',true,'numEigs',10,'IfFindNeigh',false, 'IfFindEdge',false};
S1 = MESH.preprocess(S1,mesh_options{:});
S2 = MESH.preprocess(S2,mesh_options{:});

get_err12 = @(T12) min([fMAP.eval_pMap(S1, S2, T12, [lmk1,lmk2]),...
    fMAP.eval_pMap(S1, S2, T12, [lmk1,lmk2_sym])],[],2);
get_err21 = @(T21) min([fMAP.eval_pMap(S2, S1, T21, [lmk2,lmk1]),...
    fMAP.eval_pMap(S2, S1, T21, [lmk2,lmk1_sym])],[],2);

err12 = cellfun(@(T12) mean(get_err12(T12)), all_T12);
err21 = cellfun(@(T21) mean(get_err21(T21)), all_T21);

mtd_names = pad(mtd_names);
fprintf('Average (per vertex) error: \n%s -> %s:\n', s1_name, s2_name);
for i = 1:length(mtd_names)
fprintf('%s: %.6f\n', mtd_names{i}, err12(i))
end

fprintf('\n%s -> %s:\n', s2_name, s1_name);
for i = 1:length(mtd_names)
fprintf('%s: %.6f\n', mtd_names{i}, err21(i))
end




