function export_to_renderer_database(rc_target, rc, dir_scratch, Tout, tIds, z_val, v)
fn = [dir_scratch '/X_A_' num2str(randi(100000000)) '.txt'];
%disp('Exporting temporary MET file');

fid = fopen(fn,'w');
for tix = 1:size(Tout,1)
    fprintf(fid,'%d\t%s\t%d\t%.12f\t%.12f\t%.12f\t%.12f\t%.12f\t%.12f\t%d\t%d\t%d\t%s\t%d\n',...
        z_val(tix),...
        tIds{tix}, ...  %%L.tiles(tix).renderer_id, ... %
        1, ...
        Tout(tix,1), ...
        Tout(tix,2), ...
        Tout(tix,3), ...
        Tout(tix,4), ...
        Tout(tix,5), ...
        Tout(tix,6), ...
        999, ...
        999, ...
        999, ...
        'nan',...
        999);
end
fclose(fid);
%% append tiles to existing collection
%disp(' ..... appending data to collection....');
resp_append = append_renderer_stack(rc_target, rc, fn, v);
%% cleanup
%disp(' .... cleanup..');
try
    %%delete(fn);
catch err_delete,
    kk_disp_err(err_delete);
end