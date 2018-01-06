classdef tToolboxSanbox < fx.maven.test.WithCleanWorkingDirectory
    
    properties( TestParameter )
        PrjAliasedProperty = {...
            'Name',...
            'Author',...
            'Email',...
            'Company',...
            'Summary',...
            'Description',...
            'Version',...
            }
        InitialExpectedValue = {...
            'myapp',...
            '',...
            '',...
            '',...
            '',...
            '',...
            '1.0.0',...
            }
        NewValue = {...
            'My New Name',...
            'me',...
            'me@gmail.com',...
            'mw',...
            'short text',...
            'much longer text',...
            '1.3.2',...
            }
    end
    
    properties( GetAccess = private, Constant )
        Name(1,:) char = 'testAddOn'
        ShortName(1,:) char = 'somewhere'
        TestFolder(1,:) char = 'C:\elsewhere'
        ParentPackage(1,:) char = 'fx'
    end
    
    properties( GetAccess = private, SetAccess = private )
        Sandbox(1,:) fx.maven.ToolboxSandbox
    end
    
    methods( Test )
        
        function testSandboxCreation( this )
            this.Sandbox = fx.maven.ToolboxSandbox.initialize( this.Root, 'ArtifactId', 'myaddon' );
            this.verifyEqual( exist( 'code', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', '+fx', '+myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'test', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon', '+test' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon', '+test', '+unittest' ), 'dir' ), 7 );
            this.verifyEqual( exist( sprintf( 'pom.xml' ), 'file' ), 2 );
            this.verifyEqual( exist( sprintf( 'myaddon.prj' ), 'file' ), 2 );
            this.verifyEqual( exist( sprintf( 'addsandbox.m' ), 'file' ), 2 );
            this.verifyEqual( exist( sprintf( 'rmsandbox.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', 'myaddonroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'test', 'myaddontestroot.m' ), 'file' ), 2 );
            rootContent = fileread( fullfile( 'code', 'myaddon', 'myaddonroot.m' ) );
            this.verifyEqual( rootContent, sprintf( 'function thisPath = myaddonroot()\r\n    thisPath = fileparts( mfilename( ''fullpath'' ) );\r\nend\r\n' ) );
            rootContent = fileread( fullfile( 'test', 'myaddontestroot.m' ) );
            this.verifyEqual( rootContent, sprintf( 'function thisPath = myaddontestroot()\r\n    thisPath = fileparts( mfilename( ''fullpath'' ) );\r\nend\r\n' ) );
        end
        
        function testCreateStubErrorsOnNonEmpty( this )
            mkdir( 'somedir' );
            this.verifyError( @() fx.maven.ToolboxSandbox.initialize( pwd ), 'Maven:DirNotEmpty' );
        end
        
        function testCreateStubDoesNotErrorsForGit( this )
            mkdir( '.git' );
            didNotThrow = true;
            try
                fx.maven.ToolboxSandbox.initialize( pwd );
            catch
                didNotThrow = false;
            end
            this.verifyTrue( didNotThrow );
        end
        
        function testCreateStubDoesNotErrorsForSvn( this )
            mkdir( '.svn' );
            didNotThrow = true;
            try
                fx.maven.ToolboxSandbox.initialize( pwd );
            catch
                didNotThrow = false;
            end
            this.verifyTrue( didNotThrow );
        end
        
        function testAddAndRemoveSandbox( this )
            this.copyDefaultSandbox();
            oldPath = strsplit( path, ';' );
            this.Sandbox.addToPath();
            newPath = strsplit( path, ';' );
            addedPath = setdiff( newPath, oldPath );
            expectedPathAdded = {...
                fullfile( this.Root, 'code', 'myapp' ),...
                fullfile( this.Root, 'test' ),...
                };
            this.verifyTrue( all( ismember( addedPath, expectedPathAdded ) ) );
            this.Sandbox.removeFromPath();
            newPath = strsplit( path, ';' );
            this.verifyEqual( oldPath, newPath );
        end
        
        function testSandboxCanDetectConfigAndPrjFile( this )
            this.copyDefaultSandbox();
            newSandbox = fx.maven.ToolboxSandbox( this.Root );
            this.verifyNotEmpty( newSandbox.Prj );
            this.verifyNotEmpty( newSandbox.Pom );
            this.verifyEqual( this.Sandbox.Guid, this.Sandbox.Prj.Guid );
        end
        
        function testPackage( this )
            this.copyDefaultSandbox();
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.Name ), 'file' ), 0 );
            this.Sandbox.Name = this.Name;
            this.Sandbox.package();
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.Name ), 'file' ), 2 );
        end
        
    end
    
    methods( Test, ParameterCombination = 'sequential' )
        
        function testChangingName( this, PrjAliasedProperty, InitialExpectedValue, NewValue )
            this.copyDefaultSandbox();
            this.verifyEqual( this.Sandbox.(PrjAliasedProperty), InitialExpectedValue );
            this.Sandbox.(PrjAliasedProperty) = NewValue;
            this.verifyEqual( this.Sandbox.(PrjAliasedProperty), NewValue );
            this.verifyEqual( this.Sandbox.Prj.(PrjAliasedProperty), NewValue );
        end
        
    end
    
    methods( Access = private )
        
        function copyDefaultSandbox( this )
            copyfile( ...
                fullfile( maventestroot, 'Sample', 'toolbox_sandbox' ), ...
                this.Root );
            this.Sandbox = fx.maven.ToolboxSandbox( this.Root );
        end
        
    end
    
end