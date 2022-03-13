//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract nftspace{

    constructor()  {
       address  owner = msg.sender;
    }
    
    uint counter;
      
    enum issale { forsale, notforsale, forbids }
       
    struct nft {
        string name;
        uint id;
        uint price;
        issale checkforsale;
        address account;
        uint starttime;
        uint endtime;
        address highestbidder;
        uint highestbid;
    }

    mapping(string =>nft) public nfts;

    modifier ownerofnfts(string memory _name){
        require (msg.sender == nfts[_name].account,"Not owner" );
        _;
    }  

    event minted(string  _name,address account);
    event burned(string  _name);
    event transfered(string  _name,address _from,address _to);
    event bidstarted(string  _name,uint _time);
    event bidendedat(string _name, uint _highestbid,address _from, address _to );
    event bought(string _name,address _from,address _to);

    function mint(string memory _name,uint _price,issale _checkforsale) public {
            require(nfts[_name].account == address(0) ,"Already minted" );
            require(uint8(_checkforsale) <= uint8(issale.forbids), "out of range");
            nfts[_name]=nft(_name,counter, _price,_checkforsale,msg.sender,0,0,address(0),0);
            counter=counter+1;
            emit minted(_name,msg.sender);
            if (nfts[_name].checkforsale == issale.forbids ){
                startbid(_name);
            }

    }

    function burn(string memory _name) public ownerofnfts(_name){
            delete nfts[_name];
            emit burned(_name);
    }

    function transferownership(string memory _name, address _account) public ownerofnfts(_name) {
            require(_account != address(0), "Restricted" );
            emit transfered(_name,nfts[_name].account,_account);
            nfts[_name].account = _account;
            
    }    

    function ownerofnft (string memory _name) public view returns (address){
           return nfts[_name].account;     
    }
    
    function buy (string memory _name) public payable {
        require ( nfts[_name].price == msg.value , "Send correct amount of ether" );
        require (nfts[_name].checkforsale == issale.forsale, "Not for sale");
        (bool sent,) = nfts[_name].account.call{value : msg.value}("");
        require(sent,"transcation failed");
        emit bought(_name,nfts[_name].account,msg.sender);
        nfts[_name].account = msg.sender;
    }

    function startbid(string memory _name) public ownerofnfts(_name) {
           nfts[_name].checkforsale = issale.forbids;
           nfts[_name].starttime = block.timestamp ;
           nfts[_name].endtime   = nfts[_name].starttime + 1000;// 172800;
           emit bidstarted(_name,nfts[_name].starttime);
    }

    function bid (string memory _name) public payable {
           require ( nfts[_name].checkforsale == issale.forbids,"Not for bids");
           require (nfts[_name].highestbid < msg.value,"");
              (bool sent,)= nfts[_name].highestbidder.call{value: nfts[_name].highestbid }("");
               require (sent,"transaction failed");
               nfts[_name].highestbidder = msg.sender;
               nfts[_name].highestbid = msg.value;
    }

    function endbidding(string memory _name) public ownerofnfts(_name) {
                require(nfts[_name].endtime >= block.timestamp,"Bidding not completed");
                (bool sent,)= nfts[_name].account.call{value: nfts[_name].highestbid}("");
                require(sent,"");
                emit bidendedat(_name,nfts[_name].highestbid,nfts[_name].account,nfts[_name].highestbidder);
                nfts[_name].account = nfts[_name].highestbidder;
                nfts[_name].starttime = nfts[_name].endtime =  nfts[_name].highestbid = 0;
                nfts[_name].account = address(0);
    }
      
    receive() external payable {}
    fallback() external payable {}

}
