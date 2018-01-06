classdef tprjFileExist < matlab.unittest.TestCase
    
    methods( Test )
        
        function testPrjFileExist( this )
            this.verifyTrue( prjFileExist );
        end
        
    end
    
end