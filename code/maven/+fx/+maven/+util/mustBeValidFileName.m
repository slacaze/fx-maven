function decision = mustBeValidFileName( string )
    validateattributes( string,...
        {'char'}, {'scalartext'} );
    decision = isempty( regexp( string, '[ \\/<>]', 'once' ) );
end