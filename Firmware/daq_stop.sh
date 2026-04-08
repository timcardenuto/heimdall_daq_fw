#/bin/sh!
echo "Shut down DAQ chain .."
#kill -64 $(ps aux | grep 'rtl' | awk '{print $2}')
#killall -s 9 rtl*

pkill -64 rtl_daq.out
kill -64 $(ps ax | grep "[p]ython3 _testing/test_data_synthesizer.py" | awk '{print $1}') 2> /dev/null
pkill -64 sync.out
pkill -64 decimate.out
pkill -64 rebuffer.out
kill -64 $(ps ax | grep "[p]ython3 _daq_core/delay_sync.py" | awk '{print $1}') 2> /dev/null
kill -64 $(ps ax | grep "[p]ython3 _daq_core/hw_controller.py" | awk '{print $1}') 2> /dev/null
kill -64 $(ps ax | grep "[p]ython3 _daq_core/iq_eth_sink.py" | awk '{print $1}') 2> /dev/null
pkill -64 iq_server.out
