classdef Transmitter
    properties
        Fc 
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
        header_redundancy
    end
    
    methods
        function Tx = Transmitter(Fc,N,N_pilot,BW,GI,constellation_type, header_redundancy) %Class constructor
           Tx.Fc = Fc %Carrier frequency
           Tx.N_subcarriers = N; %Number of subcarriers
           Tx.N_pilot_subcarriers = N_pilot; %Number of pilot subcarriers
           Tx.BW = BW; %Channel bandwidth
           Tx.Constellation = Constellation(constellation_type); %BPSK, QPSK, 8PSK, 16QAM, 64QAM etc.
           Tx.delta_F = BW/N;
           Tx.fft_period = 1/Tx.delta_F;
           Tx.guard_interval = GI*Tx.fft_period; %GI is in the range [0,1]
           Tx.t_signal = Tx.fft_period + Tx.guard_interval; %Total OFDM block duration
           Tx.N_CP = N*Tx.guard_interval/Tx.fft_period; %Number of symbols for cyclic prefix
           Tx.N_data_subcarriers = N-N_pilot;
           Tx.header_redundancy = header_redundancy; %Number of time the header is transmitted
                         
        end
        
       function OFDM_out = transmit(obj, bit_stream, file_type)
        OFDM_out = [];
        %Add header to bit-stream
        bit_stream_with_header = obj.generate_header(bit_stream, file_type, obj.header_redundancy); 
        %Group the bits into bit blocks
        grouped_bits = obj.bits2blocks(bit_stream_with_header, obj.Constellation.bits_per_symbol);
        
        %If there are less symbols than n*subcarriers we pad with zeros to
        %fit evenly with the number of subcarriers
        if mod(length(grouped_bits),obj.N_subcarriers) ~= 0 
            Tx_bin = [grouped_bits, zeros(1,obj.N_subcarriers-mod(length(grouped_bits),obj.N_subcarriers))];
        else
            Tx_bin = grouped_bits;
        end
            Tx_symbols = obj.symbol_encode(Tx_bin, obj.Constellation); %Encodes bit blocks to symbols
            
            %iFFTt of each of the ofdm symbols to convert to time domain
            for i =0:length(Tx_symbols)/obj.N_subcarriers-1
                %Create time signal
                x_time = sqrt(obj.N_subcarriers)*ifft(Tx_symbols(obj.N_subcarriers*i+1:obj.N_subcarriers*(i+1)));
                %Add cyclic prefix to generate OFDM signal
                OFDM_signal =[ x_time( obj.N_subcarriers-obj.N_CP + 1:obj.N_subcarriers) x_time];
                %Append OFDM symbol to output signal
                OFDM_out = [out, OFDM_signal];
            end
        end
    end  
    
    methods(Static)
        function bit_stream_with_header = generate_header(bit_stream, file_type, redundancy) %4 bit file type followed by 32 bit number with file length
            %Redundancy adds several copies of the header to the begining
            %of the message to avoid bit-errors screwing up the header
            bit_length = length(bit_stream);
            if floor(redundancy) >= 0 %Check correct redundancy is specified
                header = zeros(1,36);
                file_type_bin = dec2bin(file_type,4);
                bit_length_bin = dec2bin(bit_length,32);
                
                for i = 1:4
                    header(i) = str2num(file_type_bin(i));
                end
                
                for i = 1:32
                    header(i+4) = str2num(bit_length_bin(i));
                end
                header = repmat(header, 1, redundancy+1);
                bit_stream_with_header = [header, bit_stream];
                
            else
                disp('Error, redundancy must be an integer equal to, or larger than one')
            end
        end
                              
        function output = bits2blocks(x, bits_per_symbol) %Takes an array of bits and returns binary numbers
            
            if mod(length(x),bits_per_symbol) ~= 0 %pads x to make it an even number of symbols
            	x = [x, zeros(1,bits_per_symbol-mod(length(x),bits_per_symbol))];
            end
            
            output_length = (length(x)-mod(length(x),bits_per_symbol))/bits_per_symbol;
            output = (zeros(1,output_length));
            %Excess bits that do not fit into a symbol
     
            %Output is a 2D matrix where each row is a symbol of defined length
            symbol_vector = reshape(x(1:length(x)-mod(length(x),bits_per_symbol)),[bits_per_symbol, output_length]).';
            %Go through the matrix of binary number strings and convert
            %them to binary
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
