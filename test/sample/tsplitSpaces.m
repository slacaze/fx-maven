classdef tsplitSpaces < matlab.unittest.TestCase
    
    methods( Test )
        
        function testGiveMeTwice( this )
            this.verifyEqual( fx.submission.sample.splitSpaces( 'this that' ), {'this', 'that'} );
        end
        
    end
    
end