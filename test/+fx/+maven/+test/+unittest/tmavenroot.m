classdef tmavenroot < matlab.unittest.TestCase
    
    methods( Test )
        
        function this = testEnhance( this )
            expectedRoot = fileparts( which( 'mavenroot' ) );
            this.verifyEqual( mavenroot, expectedRoot );
        end
        
    end
    
end