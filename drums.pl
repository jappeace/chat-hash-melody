use Audio::PortMIDI;

my $notation = q:to/END/;
C |----------------|----------------|----------------|----------X-----|
R |x-x-x-x-x-x-x-x-|x-x-x-x-x-x-x-x-|x-x-x-x-x-X-x-x-|x-x-x-x-x---x-x-|
S |----o--o-o--o--o|----o--o-o--o--o|----o--o-o----o-|-o--o--o-o----o-|
B |o-o-------oo----|o-o-------oo----|o-o-------o-----|--oo------o-----|
END

# Not going to bother with the "velocity"
grammar DrumTab {
    token bar-separator { '|' }
    token rest          { '-' }
    token hit           { <[oxX]> }
    token instrument    { <[A .. Z]> }
    token position      { [ <hit> | <rest> ] }
    regex  bar          { [ <position> ** 16 ] <bar-separator> }
    regex  prefix       { <instrument> ' ' <bar-separator> }
    rule  part          {  <prefix> <bar> ** 4   }
    regex  TOP          { <part>+ }
}

class DrumTab::Actions {
    method rest($/) {
        $/.make: False;
    }
    method hit($/) {
        $/.make: True;
    }
    method position($/) {
        $/.make: ($/<hit>.made || False);
    }
    method bar($/) {
        $/.make: $/<position>>>.made;
    }
    method part($/) {
        my @notes;
        for $/<bar> -> $bar {
            @notes.append: $bar.made;
        }
        $/.make: $/<prefix><instrument> => @notes;
    }

    method TOP($/) {
        my %parts;
        for $/<part> -> $part {
            %parts.push: $part.made;
        }
        $/.make: %parts;
    }
}

sub MAIN(Int :$bpm = 120, Int :$channel = 9, Int :$device = 3) {

    my $event-type = NoteOn;

    my %map =   C => Audio::PortMIDI::Event.new(:$event-type, :$channel, data-one => 49, data-two => 127, timestamp => 0),
                R => Audio::PortMIDI::Event.new(:$event-type, :$channel, data-one => 42, data-two => 127, timestamp => 0),
                S => Audio::PortMIDI::Event.new(:$event-type, :$channel, data-one => 38, data-two => 127, timestamp => 0),
                B => Audio::PortMIDI::Event.new(:$event-type, :$channel, data-one => 35, data-two => 127, timestamp => 0);
          
    my %tab = DrumTab.parse($notation, actions => DrumTab::Actions.new).made;

    my $pm = Audio::PortMIDI.new;

    my $stream = $pm.open-output($device, 32);

    my $note = 0;

    react {
        whenever Supply.interval(60/($bpm * 4)) {
            my Audio::PortMIDI::Event @notes;
            for %tab.keys -> $instrument {
                if %tab{$instrument}[$note] {
                    @notes.push: %map{$instrument};
                }
            }

            $stream.write(@notes);

            if $note == 63 {
                $note = 0;
            }
            else {
                $note++;
            }
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
