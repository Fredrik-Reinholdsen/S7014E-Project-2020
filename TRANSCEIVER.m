classdef TRANSCEIVER
    methods(Static)
        function [output, stripped_bits] = bits2binary(x, symbol_length)
            %Number of symbols in the input
            output_length = (length(x)-mod(length(x),symbol_length))/symbol_length;
            output = (zeros(1,output_length));
            %Excess bits that do not fit into a symbol
            stripped_bits = x(length(x)-mod(length(x),symbol_length)+1:length(x));
            %Output is a 2D matrix where each row is a symbol of defined length
            symbol_vector = reshape(x(1:length(x)-mod(length(x),symbol_length)),[symbol_length, output_length]).';
            for i = 1:output_length
                str_symbol =  num2str(symbol_vector(i,:));
                str_symbol(isspace(str_symbol)) = '';
                output(i) = bin2dec(str_symbol);
            end
        end

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
        
        function out = symbol_encode(x, symbols, symbol_map) %Function to encode vector x of binary to symbols
            out = zeros(1,length(x));
            
            for i = 1:length(x)
                out(i) = symbols(find(symbol_map == x(i)));
            end
        end
        
    end
end
