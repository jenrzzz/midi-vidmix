require 'sinatra'
require 'unimidi'

class MIDIPlay
    attr_accessor :route
    
    def initialize(midiroute)
        @route = midiroute
    end

    def play(channel, note, velocity, duration)
        raise ArgumentError if (not channel.to_i.between?(0, 15) \
                                or not note.to_i.between?(0, 127) \
                                or not velocity.to_i.between?(0, 127))
        @route.puts (0x90 | channel), note, velocity
        sleep(duration * 0.1)
        @route.puts (0x80 | channel), note, velocity
    end

    def self.getFirst()
        return self.new UniMIDI::Output.open(:first)
    end
end

    
get '/' do
    erb :index
end

get '/:channel/:note' do
    @midi = MIDIPlay.getFirst
    @midi.play params[:channel].to_i, params[:note].to_i, 64, 0.1
    puts "played a #{params[:note]} on channel #{params[:channel]} with " + @midi.to_s
end
