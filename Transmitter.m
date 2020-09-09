classdef Transmitter
    properties
        N_subcarriers
        N_data_subcarriers
        N_pilot_subcarriers
        BW
        delta_F
        fft_period
        guard_interval
        t_signal
        N_CP
        Constellation
    end
    
    methods
        function Tx = Transmitter(N,N_pilot,BW,GI,constellation_type) %Class constructor
           Tx.N_subcarriers = N; %Number of subcarriers
           Tx.N_pilot_subcarriers = N_pilot; %Number of pilot subcarriers
           Tx.BW = BW; %Channel bandwidth
           Tx.Constellation = Constellation(constellation_type); %BPSK, QPSK, 8PSK, 16QAM, 64QAM etc.
           Tx.delta_F = BW/N;
           Tx.fft_period = 1/TX.delta_F;
           Tx.guard_interval = GI*Tx.fft_period; %GI is in the range [0,1]
           Tx.t_signal = Tx.fft_period + Tx.guard_interval; %Total OFDM block duration
           Tx.N_CP = N*Tx.guard_interval/fft_period; %Number of symbols for cyclic prefix
           Tx.N_data_subcarriers = N-N_pilot;
                         
        end
    end
        
    methods(Static)
        function generate_header(file_type, bit_length) %4 bit file type followed by 32 bit number with file length
            
        end
        
        function passband_signal = transmit(obj, bit_stream)
            [grouped_bits, stripped_bits] = bits2binary(bit_stream, obj.Constellation.bits_per_symbol);
            
        end
        function [output, stripped_bits] = bits2binary(x, bits_per_symbol) %Takes an array of bits and returns binary numbers
            %Number of symbols in the input
            output_length = (length(x)-mod(length(x),bits_per_symbol))/bits_per_symbol;
            output = (zeros(1,output_length));
            %Excess bits that do not fit into a symbol
            stripped_bits = x(length(x)-mod(length(x),bits_per_symbol)+1:length(x));
            %Output is a 2D matrix where each row is a symbol of defined length
            symbol_vector = reshape(x(1:length(x)-mod(length(x),bits_per_symbol)),[bits_per_symbol, output_length]).';
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
