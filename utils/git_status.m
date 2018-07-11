function [ sha1, modified ] = git_status(repodir)
%[sha1, modified] = git_status(repodir)
% Jared Males

% UPDATED 6/1/2018 by Alexander Rodack
% Added else for support to non-unix machines to fix output not assigned
% error


if isunix()
    
    fn = tempname();

    cmd = sprintf('git --git-dir=%s/.git --work-tree=%s log -1 --format=%%H >> %s &', repodir, repodir, fn);

    system(cmd);

    cmd = sprintf('git --git-dir=%s/.git --work-tree=%s status >> %s &', repodir, repodir, fn);

    stat = system(cmd);

    pause(0.2); %have to wait for the last write to finish
    
    fid = fopen(fn);
    
    sha1 = fgetl(fid);
   
    tline = fgetl(fid);
    
    
    modified = 0;
    
    while ~feof(fid)
        if(length(strfind(tline, 'modified')))
            modified = 1;
            break;
        end
        tline = fgetl(fid);
    end
    
    fclose(fid);
elseif ispc
    % Assign a variable to the git directory
    git_dir = 'E:\cygwin64\home\Alex\Documents\ACESatSim\.git';
    
    % Path to CygWin installation in Windows
    cygwinPath = 'E:\cygwin64\bin'; % the value depends on the actual installation of Cygwin
    
    % Path to git executible in CygWin
    cw_git = fullfile(cygwinPath, 'git');
    
    % Test if CygWin with Git is reachable
    test = system(sprintf('%s --version',cw_git));
    if test ~= 0
        error('Could not run Git in CygWin!');
    end
    
    fn = tempname();
        
    cmd = sprintf('%s --git-dir=%s/.git --work-tree=%s log -1 --format=%%H >> %s', cw_git, repodir, repodir, fn);
    system(cmd);
    
    cmd = sprintf('%s --git-dir=%s status >> %s',cw_git,git_dir, fn);
    stat = system(cmd)
    
    pause(0.2); %have to wait for the last write to finish
    
    fid = fopen(fn);
    
    sha1 = fgetl(fid);
    
    tline = fgetl(fid);
    
    
    modified = 0;
    
    while ~feof(fid)
        if(length(strfind(tline, 'modified')))
            modified = 1;
            break;
        end
        tline = fgetl(fid);
    end
    
    fclose(fid);
    
end %isunix()

end

