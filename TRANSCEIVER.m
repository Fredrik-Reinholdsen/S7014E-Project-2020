classdef Transceiver
    methods(Static)
        function [output, stripped_bits] = bits2binary(x, symbol_length) %Takes an array of bits and returns binary numbers
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
        
        function out = symbol_encode(x, Constellation) %Function to encode vector x of binary to symbols
            out = zeros(1,length(x));
            
            for i = 1:length(x)
                out(i) = Constellation.symbols(find(Constellation.symbol_map == x(i)));
            end
        end
        
    end
end
