classdef ToolboxSandbox < handle
    
    properties( GetAccess = public, SetAccess = immutable )
        Root char = char.empty
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        Name(1,:) char
        Author(1,:) char
        Email(1,:) char
        Company(1,:) char
        Summary(1,:) char
        Description(1,:) char
        Version(1,:) char
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        Guid(1,:) char
    end
    
    properties( GetAccess = public, SetAccess = private, Hidden )
        Pom(1,:) fx.maven.PomFile {fx.maven.util.mustBeEmptyOrScalar}
        Prj(1,:) fx.maven.PrjFile {fx.maven.util.mustBeEmptyOrScalar}
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent, Hidden )
        PomFile(1,:) char
        PrjFile(1,:) char
        ContentsFile(1,:) char
        SourceCodeFolder(1,:) char
        TestFolder(1,:) char
    end
    
    methods
        
        function value = get.Name( this )
            value = this.Prj.Name;
        end
        
        function set.Name( this, value )
            this.Prj.Name = value;
        end
        
        function value = get.Author( this )
            value = this.Prj.Author;
        end
        
        function set.Author( this, value )
            this.Prj.Author = value;
        end
        
        function value = get.Email( this )
            value = this.Prj.Email;
        end
        
        function set.Email( this, value )
            this.Prj.Email = value;
        end
        
        function value = get.Company( this )
            value = this.Prj.Company;
        end
        
        function set.Company( this, value )
            this.Prj.Company = value;
        end
        
        function value = get.Summary( this )
            value = this.Prj.Summary;
        end
        
        function set.Summary( this, value )
            this.Prj.Summary = value;
        end
        
        function value = get.Description( this )
            value = this.Prj.Description;
        end
        
        function set.Description( this, value )
            this.Prj.Description = value;
        end
        
        function value = get.Version( this )
            value = this.Prj.Version;
        end
        
        function set.Version( this, value )
            this.Prj.Version = value;
        end
        
        function value = get.Guid( this )
            value = this.Prj.Guid;
        end
        
        function value = get.PomFile( this )
            value = fullfile(...
                this.Root,...
                'pom.xml' );
        end
        
        function value = get.PrjFile( this )
            value = fullfile(...
                this.Root,...
                sprintf( '%s.prj', this.Pom.ArtifactId ) );
        end
        
        function value = get.ContentsFile( this )
            value = fullfile(...
                this.SourceCodeFolder,...
                'Contents.m' );
        end
        
        function value = get.SourceCodeFolder( this )
            value = fullfile(...
                this.Root,...
                'code',...
                this.Pom.ArtifactId );
        end
        
        function value = get.TestFolder( this )
            value = fullfile(...
                this.Root,...
                'test' );
        end
        
    end
    
    methods( Access = public )
        
        function this = ToolboxSandbox( root )
            validateattributes( root,...
                {'char'}, {'scalartext'} );
            root = fx.maven.util.getFullPath( root );
            assert( exist( root, 'dir' ) == 7,...
                'Maven:InvalidRoot',...
                'The path "%s" does not exist.',...
                root );
            this.Root = root;
            this.Pom = fx.maven.PomFile( this.PomFile );
            this.Prj = fx.maven.PrjFile( this.PrjFile );
        end
        
    end
    
    methods( Static, Access = public )
        
        function sandbox = initialize( varargin )
            parser = inputParser();
            parser.addRequired( 'Path', ...
                @fx.maven.util.mustBeValidPath );
            parser.addParameter( 'GroupId', 'fx', ...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.addParameter( 'ArtifactId', 'myapp', ...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.parse( varargin{:} );
            inputs = parser.Results;
            if exist( inputs.Path, 'dir' ) ~= 7
                mkdir( inputs.Path );
            end
            fx.maven.util.mustBeEmptyDirectory( inputs.Path );
            generator = fx.maven.SandboxGenerator();
            sandboxPath = generator.createToolboxSandbox( ...
                inputs.GroupId, inputs.ArtifactId );
            copyfile( sandboxPath, inputs.Path );
            rmdir( sandboxPath, 's' );
            sandbox = fx.maven.ToolboxSandbox( inputs.Path );
            cd( inputs.Path );
        end
        
    end
    
    methods( Access = public )
        
%         function addToPath( this )
%             this.verifyConfigFileExist();
%             addpath( this.TestFolder, '-end' )
%             addpath( this.SourceCodeFolder, '-end' )
%         end
%         
%         function enableAddOn( this )
%             addOns = matlab.addons.installedAddons();
%             if any( strcmp( this.Guid, addOns.Identifier ) )
%                 matlab.addons.enableAddon( this.Guid );
%             end
%         end
%         
%         function disableAddOn( this )
%             addOns = matlab.addons.installedAddons();
%             if any( strcmp( this.Guid, addOns.Identifier ) )
%                 matlab.addons.disableAddon( this.Guid );
%             end
%         end
%         
%         function removeFromPath( this )
%             this.verifyConfigFileExist();
%             rmpath( this.TestFolder )
%             rmpath( this.SourceCodeFolder )
%         end
%         
%         function testResults = test( this, suiteName, varargin )
%             this.verifyConfigFileExist();
%             if nargin < 2
%                 suiteName = '';
%             end
%             if isempty( this.Configuration.TestPackages )
%                 testResults = matlab.unittest.TestResult.empty;
%                 return;
%             end
%             if isempty( suiteName )
%                 testIndex = 1;
%             else
%                 testIndex = find( strcmp( suiteName, this.Configuration.TestPackages(:,1) ), 1, 'first' );
%             end
%             if isempty( testIndex )
%                 testResults = matlab.unittest.TestResult.empty;
%                 return;
%             else
%                 testPackage = this.Configuration.TestPackages{testIndex,2};
%             end
%             parser = inputParser();
%             parser.addParameter( 'CodeCoverage', false, ...
%                 @(x) validateattributes( x, {'logical'}, {'scalar'} ) );
%             parser.addParameter( 'JUnitTestResults', false, ...
%                 @(x) validateattributes( x, {'logical'}, {'scalar'} ) );
%             parser.parse( varargin{:} );
%             inputs = parser.Results;
%             suite = matlab.unittest.TestSuite.fromPackage(...
%                 testPackage,...
%                 'IncludingSubpackages', true );
%             runner = matlab.unittest.TestRunner.withTextOutput();
%             if inputs.CodeCoverage
%                 coberturaReport = matlab.unittest.plugins.codecoverage.CoberturaFormat(...
%                     fullfile( this.TestFolder, 'codeCoverage.xml' ) );
%                 codeCoverageFolders = fx.fcam.util.getAllFolders( this.SourceCodeFolder );
%                 codeCoverageFolders = fx.fcam.util.filterCodeCoveragePaths( codeCoverageFolders );
%                 codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(...
%                     codeCoverageFolders,...
%                     'IncludingSubfolders', false,...
%                     'Producing', coberturaReport );
%                 runner.addPlugin( codeCoveragePlugin );
%             end
%             if inputs.JUnitTestResults
%                 jUnitPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(...
%                     fullfile( this.TestFolder, 'junitResults.xml' ) );
%                 runner.addPlugin( jUnitPlugin );
%             end
%             testResults = runner.run( suite );
%         end
%         
%         function package( this, outputFile )
%             this.verifyConfigFileExist();
%             this.verifyPrjFileExist();
%             if ~any( strcmp( this.SourceCodeFolder, strsplit( path, ';' ) ) )
%                 addpath( this.SourceCodeFolder, '-end' );
%                 removeSourceCodeFolderFromPath = onCleanup(...
%                     @() rmpath( this.SourceCodeFolder ) );
%             end
%             if any( strcmp( this.TestFolder, strsplit( path, ';' ) ) )
%                 rmpath( this.TestFolder );
%                 reAddTestFolderToPath = onCleanup(...
%                     @() addpath( this.TestFolder, '-end' ) );
%             end
%             this.prepareForPackaging();
%             if nargin < 2
%                 outputFile = fullfile(...
%                     this.Root,...
%                     sprintf( '%s v%s.mltbx',...
%                     this.Name,...
%                     this.Version ) );
%             end
%             fx.fcam.util.flushEventQueue();
%             matlab.addons.toolbox.packageToolbox( this.PrjFile, outputFile );
%             fx.fcam.util.flushEventQueue();
%         end
%         
%         function testResults = testPackagedAddon( this, suiteName, varargin )
%             this.verifyConfigFileExist();
%             this.verifyPrjFileExist();
%             if nargin < 2
%                 suiteName = '';
%             end
%             tempFile = sprintf( '%s.mltbx', tempname );
%             this.package( tempFile );
%             deleteFile = onCleanup( @() delete( tempFile ) );
%             fx.fcam.util.flushEventQueue();
%             tempToolbox = matlab.addons.toolbox.installToolbox( tempFile, true );
%             uninstallAddOn = onCleanup(...
%                 @() matlab.addons.toolbox.uninstallToolbox( tempToolbox ) );
%             fx.fcam.util.flushEventQueue();
%             if any( strcmp( this.SourceCodeFolder, strsplit( path, ';' ) ) )
%                 rmpath( this.SourceCodeFolder );
%                 reAddSourceCodeFolderToPath = onCleanup(...
%                     @() addpath( this.SourceCodeFolder, '-end' ) );
%                 reAddSourceCode = true;
%             else
%                 reAddSourceCode = false;
%             end
%             if ~any( strcmp( this.TestFolder, strsplit( path, ';' ) ) )
%                 addpath( this.TestFolder, '-end' );
%                 removeTestFolderFromPath = onCleanup(...
%                     @() rmpath( this.TestFolder ) );
%                 removeTest = true;
%             else
%                 removeTest = false;
%             end
%             fx.fcam.util.flushEventQueue();
%             testResults = this.test( suiteName, varargin{:} );
%             if reAddSourceCode
%                 delete( reAddSourceCodeFolderToPath );
%             end
%             if removeTest
%                 delete( removeTestFolderFromPath );
%             end
%             fx.fcam.util.flushEventQueue();
%             delete( uninstallAddOn );
%             fx.fcam.util.flushEventQueue();
%         end
        
    end
    
    methods( Access = private )
        
%         function verifyConfigFileExist( this )
%             assert( exist( this.ConfigFile, 'file' ) == 2,...
%                 'FCAM:MissingConfigFile',...
%                 'Missing "fcam.json" at localtion "%s".',...
%                 this.ConfigFile );
%         end
%         
%         function verifyPrjFileExist( this )
%             assert( exist( this.PrjFile, 'file' ) == 2,...
%                 'FCAM:MissingPrjFile',...
%                 'Missing "%s.prj" at localtion "%s".',...
%                 this.Configuration.ShortName,...
%                 this.PrjFile );
%         end
%         
%         function prepareForPackaging( this )
%             versionLine = sprintf( "%% Version %s (R%s) %s",...
%                 this.Version,...
%                 version( '-release' ),...
%                 datetime( 'now', 'Format', 'dd-MMM-yyyy' ) );
%             if exist( this.ContentsFile, 'file' ) ~= 2
%                 oldPath = pwd;
%                 cd( this.SourceCodeFolder );
%                 makecontentsfile( this.SourceCodeFolder );
%                 cd( oldPath );
%                 contents = splitlines( string( fileread( this.ContentsFile ) ) );
%                 contents = [...
%                     contents(1);...
%                     versionLine;
%                     contents(2:end);...
%                     ];
%             else
%                 oldPath = pwd;
%                 cd( this.SourceCodeFolder );
%                 fixcontents( this.ContentsFile, 'all' );
%                 cd( oldPath );
%                 contents = splitlines( string( fileread( this.ContentsFile ) ) );
%                 contents(2) = versionLine;
%             end
%             emptyLines = contents == "";
%             contents(emptyLines) = [];
%             file = fopen( this.ContentsFile, 'w' );
%             closeFile = onCleanup( @() fclose( file ) );
%             fprintf( file, '%s\n', contents );
%         end
        
    end
    
end