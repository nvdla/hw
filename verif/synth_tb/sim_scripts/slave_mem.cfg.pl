#!/usr/bin/env perl

%configHash = (
'max_rd_outstanding_per_channel0' => [ '180', 'Slave 0 Max Reads (384)', 0 ],
'max_wr_outstanding_per_channel0' => [ '40', 'Slave 0 Max Writes (64)', 1 ],
'max_txn_outstanding_per_channel0' => [ '1c0', 'Slave 0 Max Total (448)', 2 ],
'mem_read_latency0' => [ 'b4', 'Slave 0 Read Latency (180)', 3 ],
'mem_write_latency0' => [ '1e', 'Slave 0 Write Latency (30)', 4 ],
'max_rd_outstanding_per_channel1' => [ '180', 'Slave 1 Max Reads (384)', 5 ],
'max_wr_outstanding_per_channel1' => [ '40', 'Slave 1 Max Writes (64)', 6 ],
'max_txn_outstanding_per_channel1' => [ '1c0', 'Slave 1 Max Total (448)', 7 ],
'mem_read_latency1' => [ 'b4', 'Slave 1 Read Latency (180)', 8 ],
'mem_write_latency1' => [ '1e', 'Slave 1 Write Latency (30)', 9 ],
'read_reg_poll_interval_clocks' => [ '37', 'Master Sequencer Read Poll Interval (55)', 10 ],
'read_reg_timeout_clocks' => [ '2710', 'Master Sequencer Read Timeout (10,000)', 11 ],
'write_reg_timeout_clocks' => [ '186a0', 'Master Sequencer Write Timeout (100,000)', 12 ],
'wait_interrupt_timeout_clocks' => [ '1f5240', 'Master Sequencer Interrupt Timeout (2,000,000)', 13 ],
'continue_on_fail' => [ '0', 'Master Sequencer Continue on Fail: 0 = Stop on fail (0)', 14 ],
'read_reg_poll_retries' => [ '64', 'Master Sequencer Read Polls (100)', 15 ],
'write_perc_channel_0' => [ '64', 'Write perc channel 0 (100)', 16 ],
'read_perc_channel_0' => [ '64', 'Read perc channel 1 (100)', 17 ],
'write_perc_channel_1' => [ '64', 'Write perc channel 0 (100)', 18 ],
'read_perc_channel_1' => [ '64', 'Read perc channel 1 (100)', 19 ],
'perc_all_channels' => [ '64', 'Perc all channels (100)', 20 ]
);



my $VAL_BIT_WIDTH = 16;
my $VAL_BIT_WIDTH_MASK = (1 << $VAL_BIT_WIDTH) - 1;

my $outputFileName = "./slave_mem.cfg";
my $channels = 2;
my $argVal;
my $argValNew;
my $argValNewHi;
my $argValNewLo;
my $argComment;
my $argIdx;
my @argArray;
my %argUsedHash;

printf ("Running %s\n", $0);

# Extract arguments.
while ($_ = $ARGV[0], /^[-|\+]/) {
    shift;
    last if (/^--$/);

	if (/\+(\S+)=(\d+)/) {
		$_ = $1;
		# Conver to hex.
		$argValNew = $2;
		$argValNewHi = sprintf ("%0x", ($argValNew >> $VAL_BIT_WIDTH) & $VAL_BIT_WIDTH_MASK);
		$argValNewLo = sprintf ("%0x", ($argValNew >> 0) & $VAL_BIT_WIDTH_MASK);

#		printf ("new=%s hi=%s lo=%s mask=%s\n", $argValNew, $argValNewHi, $argValNewLo, $VAL_BIT_WIDTH_MASK);
	
	} elsif (/^-outFile$/i) {
		$outputFileName = shift @ARGV;
	}
	else {
		next;
	}

#	printf ("arg=%s\n", $_);
	my $argHi = $_."Hi";
	my $argLo = $_."Lo";

	# Check base name
	if (exists $configHash {$_} && (!exists $argUsedHash {$_})) {
		@argArray = @{$configHash {$_}};
		$argArray[0] = $argValNewLo;
		@{$configHash {$_}} =  @argArray;

		printf ("\tUpdated %s\n", "$_");

		$argUsedHash {$_} = 1;

		break;
	}
	# Check if arg hi/lo value exists.
	elsif ((exists $configHash {$argHi} && (! exists $argUsedHash {$argHi})) 
 		|| (exists $configHash {$argLo} && (! exists $argUsedHash {$argLo}))) {
		@argArray = @{$configHash {$argHi}};
		$argArray[0] = $argValNewHi;
		@{$configHash {$argHi}} =  @argArray;

		printf ("\tUpdated %s\n", $argHi);

		$argUsedHash {$argHi} = 1;



		@argArray = @{$configHash {$argLo}};
		$argArray[0] = $argValNewLo;
		@{$configHash {$argLo}} =  @argArray;

		printf ("\tUpdated %s\n", $argLo);

		$argUsedHash {$argLo} = 1;

		break;
	}
	# Update channel args
	else {
		for (my $i = 0; $i < $channels; $i++) {
			my $argChan = $_.$i;

			# Check base name + channel
			if (exists $configHash {$argChan} && (! exists $argUsedHash {$argChan})) {
				@argArray = @{$configHash {$argChan}};
				$argArray[0] = $argValNewLo;
				@{$configHash {$argChan}} =  @argArray;

				printf ("\tUpdated %s\n", $argChan);

				$argUsedHash {$argChan} = 1;
			}
			else {
#				printf ("%s does not exist\n", "$arg");
			}
		} # for
	}
}


#Print out the db.
open (OUTFILE, '>', $outputFileName) || die ("Can't open $outputFileName!\n");
foreach my $k (sort { @{$configHash{$a}}[2] <=> @{$configHash{$b}}[2] }  keys %configHash) {
	printf (OUTFILE "%-9s// %s\n", @{$configHash{$k}}[0], @{$configHash{$k}}[1]);
#	printf ("%s\n", $k);
}



