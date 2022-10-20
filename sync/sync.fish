#!/usr/bin/env fish

set base_dir (dirname (status filename))
set sync_files $base_dir/**/.syncdest
set sync_dirs (dirname $sync_files)
set sync_dst_dirs (cat $sync_files)

for sf in $sync_files
    set -l src_dir (realpath (dirname $sf))
    set -l dst_dir (string replace -r '^~' $HOME (cat $sf))
    printf 'Syncing contents of %s to %s:\n' $src_dir $dst_dir

    for src_file in $src_dir/*
        set -l dst_file $dst_dir"/"(basename $src_file)
        if [ -e $dst_file ]
            echo "$dst_file already exists. Skipping..."
        else
            ln -sv $src_file $dst_file
        end
    end

    echo 'Done.'
end
