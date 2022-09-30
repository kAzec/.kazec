#!/usr/bin/env fish

set base_dir (dirname (status filename))
set sync_files (find $base_dir -name .syncdest)
set sync_dirs (dirname $sync_files)
set sync_dst_dirs (cat $sync_files)

for i in (seq (count $sync_files))
    set -l f $sync_files[$i]
    set -l src_dir (dirname $f)
    set -l dst_dir (string replace -r '^~' $HOME (cat $f))
    printf 'Syncing contents of %s to %s:\n' $src_dir $dst_dir

    for src_file in $src_dir/*
        set -l dst_file $dst_dir"/"(basename $src_file)
        ln -sv $src_file $dst_file
    end

    echo 'Done...'
end