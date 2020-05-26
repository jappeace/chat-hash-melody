use Audio::PortMIDI;

print "hello world";

my $pm = Audio::PortMIDI.new;

my $dev = 2;

say $dev;


my $stream = $pm.open-output($dev, 32);

# Play 1/8th note middle C
my $note-on = Audio::PortMIDI::Event.new(event-type => NoteOn, channel => 1, data-one => 60, data-two => 227, timestamp => 2);
my $note-off = Audio::PortMIDI::Event.new(event-type => NoteOff, channel => 1, data-one => 60, data-two => 127, timestamp => 0);

$stream.write($note-on);
sleep 2.5;
$stream.write($note-off);

$stream.close;

$pm.terminate;

