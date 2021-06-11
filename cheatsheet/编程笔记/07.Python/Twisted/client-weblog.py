while 1:
    xml_data = sock.recv(8192)
    parser.feed(xml_data)
    sleep(5)          # Delay before requesting new records
    sock.send('NEW?') # Send signal to indicate readiness