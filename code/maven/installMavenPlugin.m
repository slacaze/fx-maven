function installMavenPlugin( varargin )
    % Installs the Maven elements.
    %
    % Install the MATLAB Maven Plugin, the Maven MATLAB Toolbox Archetype,
    % and the MATLAB Maven Toolbox.
    %
    %   installMavenPlugin() installs with default options.
    % 
    %   installMavenPlugin( name, value ) installs with specified options.
    %
    %   Example
    %      installMavenPlugin();
    % 
    %   Options
    %      - RunTests: Whether to run the tests on Maven install. Default
    %                  is true.
    %      - Verbose:  Whether to echo the system output. Default is true.
    
    assert( fx.maven.Maven.isInstalled(), ...
        'Maven:MavenNotInstalled', ...
        'Maven must be installed:\n%s', ...
        '<a href="matlab: web( ''https://maven.apache.org/download.cgi'', ''-browser'' );">https://maven.apache.org/download.cgi</a>' );
    assert( fx.maven.Git.isInstalled(), ...
        'Maven:GitNotInstalled', ...
        'GIT must be installed:\n%s', ...
        '<a href="matlab: web( ''https://git-scm.com/downloads'', ''-browser'' );">https://git-scm.com/downloads</a>' );
    % Parse inputs
    parser = inputParser();
    parser.addParameter( 'RunTests', true, ...
        @(x) validateattributes( x, {'logical'}, {'scalar'} ) );
    parser.addParameter( 'Verbose', true, ...
        @(x) validateattributes( x, {'logical'}, {'scalar'} ) );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    % We use git to grab stuff
    echoFlag = inputs.Verbose;
    pluginRepo = 'https://github.com/slacaze/matlab-maven-plugin.git';
    toolboxRepo = 'https://github.com/slacaze/fx-maven.git';
    archetypeRepo = 'https://github.com/slacaze/matlab-maven-archetype.git';
    % First, we must install the plugin, which hold everything
    pluginPath = tempname;
    removePluginPath = onCleanup( @() fx.maven.util.tryRmdir( pluginPath ) );
    dispBlock( 'Cloning MATLAB Maven Plugin' );
    fx.maven.Git.clone( pluginRepo, pluginPath, echoFlag );
    dispBlock( 'Installing MATLAB Maven Plugin' );
    fx.maven.Maven.install( pluginPath, echoFlag );
    % Then, we must install the matlab toolbox
    toolboxPath = tempname;
    removeToolboxPath = onCleanup( @() fx.maven.util.tryRmdir( toolboxPath ) );
    dispBlock( 'Cloning Fx Maven Toolbox' );
    fx.maven.Git.clone( toolboxRepo, toolboxPath, echoFlag );
    dispBlock( 'Installing Fx Maven Toolbox' );
    if inputs.RunTests
        fx.maven.Maven.install( toolboxPath, echoFlag );
    else
        fx.maven.Maven.install( toolboxPath, echoFlag, ...
            '-DrunSandboxTests=false', ...
            '-DrunAddOnTests=false' );
    end
    % Finally, we instlall the archetype
    archetypePath = tempname;
    removeArchetypePath = onCleanup( @() fx.maven.util.tryRmdir( archetypePath ) );
    dispBlock( 'Cloning Maven MATLAB Toolbox Archetype' );
    fx.maven.Git.clone( archetypeRepo, archetypePath, echoFlag );
    dispBlock( 'Installing Maven MATLAB Toolbox Archetype' );
    fx.maven.Maven.install( archetypePath, echoFlag );
    
    % Nested Functions
    function dispBlock( str )
        if ~inputs.Verbose
            return;
        end
        blockSize = 40;
        textSize = numel( str );
        blockSize = max( blockSize, textSize + 4 );
        line = repmat( '#', 1, blockSize );
        nSpace = ( blockSize - textSize - 2 ) / 2;
        leftPad = sprintf( '#%s', repmat( ' ', 1, floor( nSpace ) ) );
        rightPad = sprintf( '%s#', repmat( ' ', 1, ceil( nSpace ) ) );
        fprintf( 1, ...
            '\n%s\n%s%s%s\n%s\n\n', ...
            line, ...
            leftPad, str, rightPad, ...
            line );
    end
end