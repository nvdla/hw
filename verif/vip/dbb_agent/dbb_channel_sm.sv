
/// This class is an abstract implementation of the process which listens to VALID and drives READY
/// for a channel.  It must be extended to implement its interface functions.  The start
/// subroutine should be started by the implementing agent in a forked process.
virtual class dbb_channel_ready_driver_sm extends uvm_pkg::uvm_report_object;

    /// Enum to track channel state.
    typedef enum {
        READY_HIGH, 
        READY_LOW, 
        READY_BACKPRESSURE,
        READY_DELAY, 
        VALID_TO_READY_DELAY, 
        DRIVING_READY
    } state_delay_e;

    /// This variable sets the idle value of the ready signal.  This should be set by the agent upon
    /// initialization.
    bit default_ready_value;

    /// If this bit is set the beat_finished function is caled at the clock cycle after the ready
    /// delay expires.  If it is not set beat_finished is called in the same cycle.  Generally,
    /// channels which must respond to this channel on another channel will set this bit to delay
    /// the response to the next clock cycle to model the register delay.  
    bit delay_beat_finish;

    /// Object constructor.  Nothing special here.
    extern function new( string name = "dbb_channel_ready_driver_sm" );

    /// This function sets the report ID string.  Set this to the report ID which
    /// identifies the agent which instantiates this object.
    extern function void set_report_id( string rpid );

    /// This task runs the state machine.  It never returns so it must be forked into its own
    /// process by the caller.
    extern task start();

    /// This class's interface to the rest of the system.  These subroutines must be implemeted by
    /// the user.
    pure virtual task wait_clock();
    pure virtual function void drive_ready( logic value );
    pure virtual function logic sample_valid();
    pure virtual function int get_valid_ready_delay();
    pure virtual function int get_ready_delay();
    pure virtual task initiate_beat();
    pure virtual task beat_finished();


    /// These interface tasks are optional.  They have default implemntations which do nothing.
    extern virtual task pre_sm();
    extern virtual task post_sm();
    extern virtual function bit do_backpressure_callback();


    // ......................
    // Internal Stuff

    // One task for each state.
    extern local task state_ready_high();
    extern local task state_ready_low();
    extern local task state_ready_backpressure();
    extern local task state_ready_delay();
    extern local task state_valid_to_ready_delay();
    extern local task state_driving_ready();

    // VARIABLES REINITIALIZED EVERY TIME START TASK IS CALLED

    local state_delay_e state;
    local state_delay_e next_state;

    local bit do_beat_finished;

    // Delay Counters
    local int ready_delay;
    local int valid_ready_delay;
    local int next_ready_delay;

    local bit first_valid_during_ready_delay;

    // VARIABLES WHOSE VALUE THROUGH REINITIALIZATION
    local string report_id;
endclass

function dbb_channel_ready_driver_sm::new( string name = "dbb_channel_ready_driver_sm" );
    super.new( name );
endfunction : new

function void dbb_channel_ready_driver_sm::set_report_id( string rpid );
    this.report_id = rpid;
endfunction

task dbb_channel_ready_driver_sm::start();

    // Initialize starting state and ready signal value based on default
    next_state = (default_ready_value)?READY_HIGH:READY_LOW;
    drive_ready( default_ready_value ? 1'b1 : 1'b0 );

    // Initialize other variables set by this state machine.
    do_beat_finished                = 0;
    ready_delay                     = 0;
    valid_ready_delay               = 0;
    next_ready_delay                = 0;
    first_valid_during_ready_delay  = 0;

    forever begin: forever_loop
        wait_clock();

        pre_sm();

        if ( do_beat_finished ) begin
            `uvm_info( report_id, "Calling beat_finished() before executing new state.", UVM_DEBUG )
            do_beat_finished  = 0;
            beat_finished();
        end

        if ( state != next_state ) begin
            // This check makes us only print the state when it changes so we don't flood the log
            // file with identical prints on every clock cycle.
            `uvm_info( report_id, $psprintf( "state:%s", next_state.name() ), UVM_DEBUG )
        end
        state = next_state;
        case (state)
          READY_HIGH:               state_ready_high();
          READY_LOW:                state_ready_low();
          READY_BACKPRESSURE:       state_ready_backpressure();
          READY_DELAY:              state_ready_delay();
          VALID_TO_READY_DELAY:     state_valid_to_ready_delay();
          DRIVING_READY:            state_driving_ready();
        endcase

        post_sm();
    end: forever_loop
    
endtask : start

task dbb_channel_ready_driver_sm::state_ready_high();
    // In this state READY already is set to it's default value of high. All timeouts
    // have expired, we're simply monitoring the bus for the VALID signal
    if ( 1'b1 !== sample_valid() ) next_state = READY_HIGH;
    else begin
        // We've seen VALID go high, need to initiate a new
        // data beat. Since READY was already high, this
        // data beat is already done and passed to next phase. No
        // need to worry about valid-to-ready delays here.
        initiate_beat();
        // This beat is finished
        beat_finished();

        ready_delay = get_ready_delay();
        if (ready_delay > 0) begin
            // Ready delay will force ready low for a time
            first_valid_during_ready_delay = 0;
            drive_ready( 1'b0 );
            next_state = READY_DELAY;
        end
        else begin
            // No delay required, set default READY and go back to 
            // monitoring VALID signal
            next_state = (default_ready_value)?READY_HIGH:READY_LOW;
            drive_ready( default_ready_value ? 1'b1 : 1'b0 );
        end
    end
endtask : state_ready_high

task dbb_channel_ready_driver_sm::state_ready_low();
    // In this state READY is already set to it's default value of low. All timeouts
    // have expired, we're simply monitoring the bus for the VALID signal
    if ( 1'b1 !== sample_valid() ) next_state = READY_LOW;
    else begin
        // We've just seen valid go high, time to start a new read data beat
        initiate_beat();
        // Set valid-to-ready delay
        valid_ready_delay = get_valid_ready_delay();
        if ( do_backpressure_callback() ) begin
            next_state = READY_BACKPRESSURE;
        end
        // Check to see if we need to delay assertion of ready
        else if (valid_ready_delay > 0) begin
            next_state = VALID_TO_READY_DELAY;
        end
        else begin
            // No delay of ready required, time to drive ready high
            next_ready_delay = get_ready_delay();
            // This beat is finished
            if ( delay_beat_finish )    do_beat_finished = 1;
            else                        beat_finished();
            drive_ready( 1'b1 );
            next_state = DRIVING_READY;
        end
    end
endtask : state_ready_low

task dbb_channel_ready_driver_sm::state_ready_backpressure();
    // In this state we block as long as the user supplied callback returns true.  Function
    // do_backpressure_callback calls the callback.  Keep track of the valid_ready_delay and go to
    // that state if the delay hasn't expired when the backpressure has ended.
    next_state = READY_BACKPRESSURE;
    if ( valid_ready_delay > 0 ) begin
        --valid_ready_delay;
    end
    if ( ! do_backpressure_callback() ) begin
        if ( valid_ready_delay > 0 ) begin
            next_state = VALID_TO_READY_DELAY;
        end
        else begin
            // Valid to Ready delay count has expired, time to drive ready high
            next_ready_delay = get_ready_delay();
            // This beat is finished
            if ( delay_beat_finish )    do_beat_finished = 1;
            else                        beat_finished();
            drive_ready( 1'b1 );
            next_state = DRIVING_READY;
        end
    end
endtask

task dbb_channel_ready_driver_sm::state_ready_delay();
    // In this state READY is begin held low on account of a ready_delay
    // timer set from the previous data beat. If VALID goes high
    // during this period, then the valid_to_ready delay timer must
    // also be managed.

    ready_delay--;         // Decrement ready_delay counter
    if ( 1'b1 !== sample_valid() ) begin: valid_false
        // VALID is still low, no new txns yet
        if (ready_delay > 0) next_state = READY_DELAY;
        else begin
            // Delay has expired so set default READY value and go back to 
            // monitoring VALID signal
            next_state        = (default_ready_value)?READY_HIGH:READY_LOW;
            drive_ready( default_ready_value ? 1'b1 : 1'b0 );
        end
    end: valid_false
    else begin: valid_true
        // If a new data beat has arrived while doing ready_delay, observe it.
        // If VALID is true from previous cycle, decrement avalid-to-ready delay
        // counter.
        if (!first_valid_during_ready_delay) begin
            first_valid_during_ready_delay = 1;
            initiate_beat();
            valid_ready_delay = get_valid_ready_delay();
        end
        else valid_ready_delay--;
        // Check to see if ready_delay is over
        if (ready_delay > 0) next_state = READY_DELAY;
        else begin
            // ready delay has expired, now check valid-to-ready delay
            if (valid_ready_delay > 0) next_state = VALID_TO_READY_DELAY;
            else begin
                // No additional delay of ready required, time to drive ready high
                next_ready_delay = get_ready_delay();
                // This beat is finished
                if ( delay_beat_finish )    do_beat_finished = 1;
                else                        beat_finished();
                drive_ready( 1'b1 );
                next_state = DRIVING_READY;
            end
        end
    end: valid_true
endtask : state_ready_delay

task dbb_channel_ready_driver_sm::state_valid_to_ready_delay();
    // In this state READY is already low. We've already seen
    // VALID go high, but there is no active ready_delay, and
    // we're simply waiting for valid_ready_delay to expire
    // before driving READY.
    valid_ready_delay--;
    if (valid_ready_delay > 0) next_state = VALID_TO_READY_DELAY;
    else begin
        // Valid to Ready delay count has expired, time to drive ready high
        next_ready_delay = get_ready_delay();
        // This beat is finished
        if ( delay_beat_finish )    do_beat_finished = 1;
        else                        beat_finished();
        drive_ready( 1'b1 );
        next_state = DRIVING_READY;
    end
endtask : state_valid_to_ready_delay

task dbb_channel_ready_driver_sm::state_driving_ready();
    // In this state VALID is high, and we've been driving
    // READY high for a cycle. Now it's time to set up any
    // ready_delay timer, or else drive READY to default value.
    ready_delay = next_ready_delay;
    if (ready_delay > 0) begin
        // Ready delay will force ready low for a time
        drive_ready( 1'b0 );
        first_valid_during_ready_delay = 0;
        next_state = READY_DELAY;
    end
    else begin
        // No delay required, set default READY and go back to 
        // monitoring VALID signal
        next_state = (default_ready_value)?READY_HIGH:READY_LOW;
        drive_ready( default_ready_value ? 1'b1 : 1'b0 );
    end
endtask : state_driving_ready

task dbb_channel_ready_driver_sm::pre_sm();
    // Nothing to do here.
endtask

task dbb_channel_ready_driver_sm::post_sm();
    // Nothing to do here.
endtask

function bit dbb_channel_ready_driver_sm::do_backpressure_callback();
    // Nothing to do here.
endfunction
