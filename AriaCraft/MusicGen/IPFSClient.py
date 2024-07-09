import ipfshttpclient
import datetime

class IPFSClient:
    def __init__(self):
        self.info = Logger().info
        self.error = Logger().error
        self.debug = Logger().debug

        try:
            self._ipfsClient = ipfshttpclient.connect()
            self.info(f'IPFS Daemon connected successfully')
        except Exception as err:
            self.error(err)
            self.error(f'IPFS Daemon not configured properly')
            exit() 
    
    def add(self, file):
        ipfsFileHash = self._ipfsClient.add(file)
        return ipfsFileHash

    def close(self):
        self._ipfsClient.close()

class Logger:

    def info(self, logValue: str):
        print(f'[ IPFSClient : {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} : INFO ] : {logValue}')
    
    def error(self, logValue: str):
        print(f'[ IPFSClient : {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} : ERROR ] : {logValue}')
    
    def debug(self, logValue: str):
        print(f'[ IPFSClient : {datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")} : DEBUG ] : {logValue}')