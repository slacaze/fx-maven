function decision = mustBeEmptyOrScalar( object )
    decision = isempty( object ) || isscalar( object );
end