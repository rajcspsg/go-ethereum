geth --datadir /home/ubuntu/eth-dev init /usr/local/config/genesis.json 
geth --networkid 45634 --verbosity 4  --ipcdisable --rpc --port 30301 --rpcport 8545 --rpcaddr 0.0.0.0 console 2>> /home/ubuntu/eth-dev/eth.log
