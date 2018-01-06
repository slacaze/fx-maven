function path = mavenroot()
    % Root of the Fx Maven Toolbox
    %
    %   path = mavenroot() return the root of the Fx Maven Toolbox in the
    %   "path" variable.
    
    path = fileparts( mfilename( 'fullpath' ) );
end
