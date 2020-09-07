classdef Constellation
    properties (SetAccess = private)
        symbols
        symbol_map
    end
    methods
        function C = Constellation(type)
            switch type %Switch statements are long but they are fast :)
                case 'BPSK'
                    [C.symbols, C.symbol_map] = C.BPSK();
                case 'QPSK'
                    [C.symbols, C.symbol_map] = C.QPSK();
                case '8PSK'
                    [C.symbols, C.symbol_map] = C.PSK_8();
                case '16QAM'
                    [C.symbols, C.symbol_map] = C.QAM_16();
                case '64QAM'
                    [C.symbols, C.symbol_map] = C.QAM_64();
                case '8GRQAM'
                    [C.symbols, C.symbol_map] = C.GRQAM_k(8);
                case '16GRQAM'
                    [C.symbols, C.symbol_map] = C.GRQAM_k(16);
                case '64GRQAM'
                    [C.symbols, C.symbol_map] = C.GRQAM_k(64);
                
                otherwise
                    disp('Incorrect constellation type!')
                    return
            end
        end
        
    end
        methods(Static)
            function [symbols, symbol_map] = BPSK()
                symbols = [-1, 1];
                symbol_map = [0, 1];

            end

            function [symbols, symbol_map] = QPSK()
                %Gray Coded QPSK
                symbol_map = [3, 1, 0, 2];
                symbols = [exp(1i*pi/4), exp(3i*pi/4), exp(-3i*pi/4), exp(-1i*pi/4)];
            end

            function [symbols, symbol_map] = PSK_8()
                %Gray Coded 8PSK
                symbol_map = [7, 6, 2, 3, 1, 0, 4, 5];
                symbols = [1, exp(1i*pi/4), 1i, exp(3i*pi/4), -1, exp(-3i*pi/4), -1i, exp(-1i*pi/4)];
            end

            function [symbols, symbol_map] = QAM_16()
                %Gray Coded 16QAM
                symbol_map = [11, 9, 1, 3,
                              10, 8, 0, 2,
                              14, 12, 4, 6,
                              15, 13, 5, 7];

                symbols = [-3+3i, -1+3i, 1+3i, 3+3i,
                           -3+1i, -1+1i, 1+1i, 3+1i,
                           -3-1i, -1-1i, 1-1i, 3-1i,
                           -3-3i, -1-3i, 1-3i, 3-3i];
            end

            function [symbols, symbol_map] = QAM_64()
                %Gray Coded 64QAM
                symbol_map = [4,12,28,20,52,60,44,36,
                              5,13,29,21,53,61,45,37,
                              7,15,31,23,55,63,47,39,
                              6,14,30,22,54,62,46,38,
                              2,10,26,18,50,58,42,34,
                              3,11,27,19,51,59,43,35,
                              1,9,25,17,49,57,41,33,
                              0,8,24,16,48,56,40,32];

                symbol_map = [-7+7i,-5+7i,-3+7i,-1+7i,1+7i,3+7i,5+7i,7+7i,
                              -7+5i,-5+5i,-3+5i,-1+5i,1+5i,3+5i,5+5i,7+5i,
                              -7+3i,-5+3i,-3+3i,-1+3i,1+3i,3+3i,5+3i,7+3i,
                              -7+1i,-5+1i,-3+1i,-1+1i,1+1i,3+1i,5+1i,7+1i,
                              -7-1i,-5-1i,-3-1i,-1-1i,1-1i,3-1i,5-1i,7-1i,
                              -7-3i,-5-3i,-3-3i,-1-3i,1-3i,3-3i,5-3i,7-3i,
                              -7-5i,-5-5i,-3-5i,-1-5i,1-5i,3-5i,5-5i,7-5i,
                              -7-7i,-5-7i,-3-7i,-1-7i,1-7i,3-7i,5-7i,7-7i];           
            end

            function [symbols, symbol_map] = GRQAM_k(k)
                %Golden ratio spiral symbol scheme
                if k == 8
                   symbols = load('GRQAM_8.mat'); 
                elseif k == 16
                    symbols = load('GRQAM_16.mat');
                elseif k == 64
                    symbols = load('GRQAM_64.mat');
                else
                    disp('Incorrect argument! k must be either 8, 16 or 64')
                    return
                end
                symbol_map = 1:k;               
            end
        end
        
end
