> Every message is a unique song on it's own

chat hash melody will construct a merkle tree from every chat message.
Generating a unique hash head for every unique chat sequence.
Then based on that hahs, a melody is constructed.

in perl 6


# Running

```
nix-shell --run "zef install Audio::PortMIDI"
make run

docker run -d -v /home/jappie/projects/chat-hash-melody:/root  --device /dev/snd -it ubuntu-perl

```

