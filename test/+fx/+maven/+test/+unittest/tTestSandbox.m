classdef tTestSandbox < fx.maven.test.WithFailingTest
    
    methods( Test )
        
        function testPath( this )
            sandbox = fx.maven.ToolboxSandbox( this.Root );
            sandbox.addToPath();
            [~, results] = evalc( 'sandbox.test();' );
            this.verifyNumElements( results, 3,...
                'There should be 3 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'sandbox.test( ''unittest'' );' );
            sandbox.removeFromPath();
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testAlias( this )
            addsandbox();
            [~, results] = evalc( 'testsandbox();' );
            this.verifyNumElements( results, 3,...
                'There should be 3 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'testsandbox( ''unittest'' );' );
            rmsandbox();
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testPackagedAddon( this )
            sandbox = fx.maven.ToolboxSandbox( this.Root ); %#ok<NASGU>
            [~, results] = evalc( 'sandbox.testPackagedAddon();' );
            this.verifyNumElements( results, 3,...
                'There should be 3 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'sandbox.testPackagedAddon( ''unittest'' );' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testPacakgedAddonAlias( this )
            [~, results] = evalc( 'testaddon();' );
            this.verifyNumElements( results, 3,...
                'There should be 3 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'testaddon( ''unittest'' );' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testTestPacakgedAddonFlagsPackagingProblems( this )
            sandbox = fx.maven.ToolboxSandbox( this.Root );
            sandbox.addToPath();
            [~, results] = evalc( 'sandbox.test( ''failing'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass in sandbox mode.' );
            [~, results] = evalc( 'sandbox.testPackagedAddon( ''failing'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( all( [results.Failed] ),...
                'All tests should be failing in packaged mode.' );
            sandbox.removeFromPath();
        end
        
        function testTestFailuresDoesNotCauseFallback( this )
            addsandbox();
            this.verifyWarning( @() testsandbox( this.Root, 'bad' ), 'MATLAB:unittest:TestSuite:FileExcluded' );
            rmsandbox();
        end
        
        function testTestFailuresDoesNotCauseFallbackOnAddOn( this )
            addsandbox();
            this.verifyWarning( @() testaddon( this.Root, 'bad' ), 'MATLAB:unittest:TestSuite:FileExcluded' );
            rmsandbox();
        end
        
    end
    
end