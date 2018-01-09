function decision = prjFileExist()
    thisPath = fileparts( mfilename( 'fullpath' ) );
    decision = exist( fullfile( thisPath, 'prjfile.prj' ), 'file' ) == 2;
end