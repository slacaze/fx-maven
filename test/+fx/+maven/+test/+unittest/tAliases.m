classdef tAliases < fx.maven.test.WithSampleSandbox
    
    methods( Test )
        
        function testMkSandbox( this )
            this.verifyEqual( exist( 'code', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'sample' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', '+fx', '+submission' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', '+fx', '+submission', '+sample' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'tests', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission', '+sample' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission', '+sample', '+test' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission', '+sample', '+test', '+unittest' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'pom.xml', 'file' ), 2 );
            this.verifyEqual( exist( 'sample.prj', 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', 'sampleroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', 'giveMeTwice.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', '+fx', '+submission', '+sample', 'splitSpaces.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'sample', 'sampleroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'test', 'sampletestroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission', '+sample', '+test', 'tgiveMeTwice.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+submission', '+sample', '+test', '+unittest', 'tsplitSpaces.m' ), 'file' ), 2 );
        end
        
        function testAddAndRemoveSandbox( this )
            oldPath = strsplit( path, ';' );
            addsandbox( this.Root );
            newPath = strsplit( path, ';' );
            addedPath = setdiff( newPath, oldPath );
            expectedPathAdded = {...
                fullfile( this.Root, 'code', 'sample' ),...
                fullfile( this.Root, 'test' ),...
                };
            this.verifyTrue( all( ismember( addedPath, expectedPathAdded ) ) );
            rmsandbox( this.Root )
            newPath = strsplit( path, ';' );
            this.verifyEqual( oldPath, newPath );
        end
        
        function testPackageSandbox( this )
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.ArtifactId ), 'file' ), 0 );
            packagesandbox();
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.ArtifactId ), 'file' ), 2 );
        end
        
    end
    
end