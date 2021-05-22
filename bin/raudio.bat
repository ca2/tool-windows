taskkill /im ffplay
ffplay -nodisp -ac 2 -acodec pcm_s16le -ar 48000 -analyzeduration 0 -probesize 32 -f s16le -i udp://0.0.0.0:21235?listen=1