#/bin/sh
echo "Shut down DAQ chain .."

# Kill only the data source and let the TERMINATE control signal cascade through
# the chain: rtl_daq -> rebuffer -> decimate -> delay_sync -> hw_controller/iq_server.
# When the source dies its stdout pipe closes, rebuffer detects EOF, sends TERMINATE
# downstream via FIFO, and each process runs its own destory_sm_buffer cleanup before
# exiting. This avoids orphaned /dev/shm objects.
pkill -SIGRTMAX rtl_daq.out 2>/dev/null
kill -SIGRTMAX $(ps ax | grep "[p]ython3 _testing/test_data_synthesizer.py" | awk '{print $1}') 2>/dev/null

# Give the cascade time to propagate and each process to clean up
sleep 4

# Fall back: terminate any processes that did not exit via the cascade
pkill -TERM sync.out 2>/dev/null
pkill -TERM rebuffer.out 2>/dev/null
pkill -TERM decimate.out 2>/dev/null
kill -TERM $(ps ax | grep "[p]ython3 _daq_core/delay_sync.py" | awk '{print $1}') 2>/dev/null
kill -TERM $(ps ax | grep "[p]ython3 _daq_core/hw_controller.py" | awk '{print $1}') 2>/dev/null
kill -TERM $(ps ax | grep "[p]ython3 _daq_core/iq_eth_sink.py" | awk '{print $1}') 2>/dev/null
pkill -TERM iq_server.out 2>/dev/null
