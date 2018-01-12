function decision = mustBeValidPackageName( string )
    if iscell( string )
        decision = all( cellfun( @fx.maven.util.mustBeValidPackageName, string ) );
    else
        validateattributes( string,...
            {'char'}, {'scalartext'} );
        decision = isempty( regexp( string, '[^a-zA-Z.]', 'once' ) );
    end
end