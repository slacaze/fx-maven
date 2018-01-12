function path = getFullPath( path )
    file = java.io.File( path );
    if ~file.isAbsolute()
        path = fullfile( pwd, path );
    end
end