function tryRmdir( path )
    validateattributes( path, ...
        {'char'}, {'scalartext'} );
    if exist( path, 'dir' ) == 7
        rmdir( path, 's' );
    end
end