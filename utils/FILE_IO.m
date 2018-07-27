% 2018-01-04
classdef FILE_IO
    properties
    end
    methods (Static)
        
        function [L] = read_landmarks(filename,varargin)
            
            tmp = strsplit(filename,'.');
            if length(tmp) == 1
                filename = [filename,'.vts'];
            end
            if exist(filename,'file')
                fid = fopen(filename);
                L = fscanf(fid,'%d\n');
                fclose(fid);
            else
                error('File not found.')
            end
            
            if nargin > 1
                if varargin{1} == 'base'
                    if varargin{2} == 0
                        L = L+1;
                    elseif varargin{2} ~= 1
                        error('Invalid base.')
                    end
                else
                    error('Invalid input.')
                end
            end
        end
        
        %--------------------------- Read pMap -----------------------------------
        function [T] = read_map(filename,varargin)
            
            tmp = strsplit(filename,'.');
            if length(tmp) == 1
                filename = [filename,'.map'];
            end
            if exist(filename,'file')
                fid = fopen(filename);
                T = fscanf(fid,'%d\n');
                fclose(fid);
            else
                error('File not found.')
            end
            
            if nargin > 1
                if varargin{1} == 'base'
                    if varargin{2} == 0
                        T = T+1;
                    elseif varargin{2} ~= 1
                        error('Invalid base.')
                    end
                else
                    error('Invalid input.')
                end
            end
        end
        %--------------------------- Read Segmentation -----------------------------------
        function [seg1, seg2] = read_segmentation(seg_dir, s1_name, s2_name, type)
            if nargin < 4, type = 'nonsym'; end
            type = lower(type);
            switch type
                case 'nonsym'
                    fprintf('Loading non-symmetric segmentation...');
                case 'sym'
                    fprintf('Loading symmetric segmentation...');
                otherwise
                    error(['Invalid segmentation type: ', type]);
            end
            if exist([seg_dir,s1_name,'_',s2_name,'.',s1_name,'.seg.',type],'file')
                fid = fopen([seg_dir,s1_name,'_',s2_name,'.',s1_name,'.seg.',type]);
                seg1 = fscanf(fid,'%d\n');
                fclose(fid);
                
                fid = fopen([seg_dir,s1_name,'_',s2_name,'.',s2_name,'.seg.',type]);
                seg2 = fscanf(fid,'%d\n');
                fclose(fid);
            elseif exist([seg_dir,s2_name,'_',s1_name,'.',s1_name,'.seg.',type],'file')
                fid = fopen([seg_dir,s2_name,'_',s1_name,'.',s1_name,'.seg.',type]);
                seg1 = fscanf(fid,'%d\n');
                fclose(fid);
                
                fid = fopen([seg_dir,s2_name,'_',s1_name,'.',s2_name,'.seg.',type]);
                seg2 = fscanf(fid,'%d\n');
                fclose(fid);
            else
                error(['Segmentation does not exist: ',seg_dir,s1_name,'_',s2_name,'.',s1_name,'.seg.',type])
            end
            fprintf('done.\n');
        end
        %------------------------------------------------------------------
        function T = read_map_with_NaN(filename)
            tmp = strsplit(filename,'.');
            if length(tmp) == 1
                filename = [filename,'.map'];
            end
            if exist(filename,'file')
                fid = fopen(filename);
                T = cell2mat(textscan(fid,'%d\n'));
                fclose(fid);
                T = double(T);
                T(T == 0) = nan;
            else
                error('File not found.')
            end
        end
        
        
        function [] = write_pMap(save_dir,src_name,tar_name,T)
            fid = fopen([save_dir,src_name,'_',tar_name,'.map'],'w');
            fprintf(fid,'%d\n',T);
            fclose(fid);
        end
        function [] = write_error(save_dir,src_name,tar_name,err)
            fid = fopen([save_dir,src_name,'_',tar_name,'.error'],'w');
            fprintf(fid,'%f\n',err);
            fclose(fid);
        end
    end
end
