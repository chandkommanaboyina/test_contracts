//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract erc20 {

   struct erc {
       uint totalsupply;
       uint currentsupply;
       string name;
       string symbol;
   }


   mapping(string=>erc) public  erctokens;

   event createdtoken (string _name,uint currentsupply,string _symbol);
   event minted (string _name,uint currentsupply);

   modifier alreadyminted(string memory _name) {
               require(erctokens[_name].currentsupply == uint(0)  , "Already created"   );
               _;

   }

   function createtoken(uint _totalsupply, string memory _name, string memory _symbol) public alreadyminted(_name)
    {
       erctokens[_name] = erc(_totalsupply,1,_name,_symbol);
       emit createdtoken(_name,erctokens[_name].currentsupply,_symbol);
    
   }
    
   function _mint(string memory _name) public {
       require(erctokens[_name].currentsupply + 1000 <= erctokens[_name].totalsupply,"Total supply exceeded" );
       erctokens[_name].currentsupply = erctokens[_name].currentsupply + 1000;// 3001
       emit minted(_name,erctokens[_name].currentsupply);
   }




}
