import nmap
import sys

# assign the target ip to be scanned
host = sys.argv[1]

# take the range of ports to be scanned
portstrs = sys.argv[2].split('-')
start_port = int(portstrs[0])
end_port = int(portstrs[1])

# instantiate a PortScanner object
nm = nmap.PortScanner()


for i in range(start_port, end_port+1):
    # scan the target port
    result = nm.scan(host,str(i))
    # the result is a dictionary containing
    # several information we only need to
    # check if the port is opened or closed
    # so we will access only that information
    # in the dictionary
    result = result['scan'][host]['tcp'][i]['state']
    if result == "open":
        print(f"Opened port: {i}")
    else:
        pass

'# Author: Ivan Reyes'