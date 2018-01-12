classdef tgiveMeTwice < matlab.unittest.TestCase
    
    methods( Test )
        
        function testGiveMeTwice( this )
            this.verifyEqual( giveMeTwice( 2 ), 4 );
        end
        
    end
    
end