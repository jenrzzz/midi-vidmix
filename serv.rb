require 'sinatra'
require 'micromidi'

$o = UniMIDI::Output.use :first

get '/' do
    erb :index
end

get '/:pitch' do
    $pitch = params[:pitch]
    MIDI.using $o do
        play $pitch, 0.1
    end
    redirect '/'
end
