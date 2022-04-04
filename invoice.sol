//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract invoice{

    uint counts = 0;

    enum paymentstatus {intiated,success,failed} 

    struct  Invoice{

        uint invoicenumber;
        address useraddress;
        string SellerPAN;
        string productname;
        uint productunits;
        uint productprice;
        uint invoiceamount;
        uint invoicedate;
        paymentstatus status;



    }

    mapping(string=>Invoice[]) public Invoices;

    function createInvoice(string memory _buyerpan,string memory _sellerpan,string memory _productname,uint _productunits,uint _productprice,paymentstatus _status) public {

        uint total = _productprice * _productunits;
        uint time = block.timestamp;
        Invoices[_buyerpan].push(Invoice(counts,msg.sender,_sellerpan,_productname,_productunits,_productprice,total,time,_status));
        counts = counts +1 ;

    }
 
    function knowpaymentstat(string memory _buyerpan, uint _invoicenumber) public view returns(paymentstatus){
        for(uint i=0; i < Invoices[_buyerpan].length;i++ ){
            if (Invoices[_buyerpan][i].invoicenumber == _invoicenumber){
                 return Invoices[_buyerpan][i].status;
            }
        }
    }
    
    function updatepaymentstat(string memory _buyerpan, uint _invoicenumber,paymentstatus _status) public{
        for(uint i=0; i < Invoices[_buyerpan].length;i++ ){
            if (Invoices[_buyerpan][i].invoicenumber == _invoicenumber){
                require(Invoices[_buyerpan][i].useraddress == msg.sender,"Not owner of invoice" );
                Invoices[_buyerpan][i].status = _status;
            }
        }
    }

    function showinvoices(string memory _buyerpan) public view returns(Invoice[] memory){
          return Invoices[_buyerpan];
    }

    




}
