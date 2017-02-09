% setenv('PATH',sprintf('/home/%s/.matlab/bin:%s',getenv('USER'),getenv('PATH')));
path(path,genpath(sprintf('%s%s',getenv('CODE_PATH'),'/matlab')))
cd(sprintf('%s%s',getenv('CODE_PATH'),'/matlab'))

% path(path,genpath('/mnt/storage/goofy/codes/matlab'))
% cd /mnt/storage/goofy/codes/matlab/
