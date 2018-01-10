function rmsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.maven.util.mustBeValidPath );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.maven.ToolboxSandbox( inputs.Path );
    sandbox.removeFromPath();
end