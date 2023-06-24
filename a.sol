// SPDX-License-Identifier: GPL-3.0
/*
1.make the struct and enum 
2.global variables 

3.learn the QR code here (about the how the QR code hold the information and when anybody scan this code )
4.


*/

pragma solidity ^0.7.0;
// enum 
// struct  

contract Fake_Product_Recognition{ 

}

contract HelloWorld_Contract{  
    // string memory a="Hello world ";
   function HelloWorl(string memory a) public pure returns(string memory)   {
    return a;
   }
}


contract multi_Send{ 
    // first declare the owner
    address private owner;
    // to amount the ether that i want to send or will be send to other addresses 
    uint total_value;


    // event for the EVM logging
    event Ownerset(address indexed oldOwner, address indexed newOwner);


    // modifier is used to check if the caller is owner 
    modifier isOwner(){

// If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.

        require(msg.sender==owner,"this is not the owner");
        _;
    }

    // set the deployment as a owner
    constructor() payable{
        owner=msg.sender; // msg.sender is the first call , contract deployer for a constructor 

        emit Ownerset(address(0),owner); // this means we set old owner is 0 new owner is owner already 

        total_value=msg.value; // msg.value is the ethers of the transaction 
    }

    // he/she can change the owner
    function changeOwner(address newOwner) public isOwner{
        emit Ownerset(owner,newOwner);// old Owner is owner  
        owner=newOwner; // this statement will change the current (newOwner) to Owner
    }
    

    // this function will return  the owner address

    function getOwner()external view returns(address){
        return owner;
    }


    // the charge function will enable the 'Owner' to store the ethers in the smart contract 
    function charge() payable public isOwner {
        // adding the message value(means ethers of the transaction) to the smart contract 
        total_value+=msg.value;
    }

    // this sum function will add the different elements of array and return it's sum
    function sum(uint[] memory amounts) public pure returns(uint retVal){
        // the value of the message should be exact of the total amount (means: msg.value= total_Amount) 

        uint total_Amount=0;
        for(uint i=0;i<amounts.length;i++){
                total_Amount+=amounts[i];
        }

        return total_Amount;
    }
    

    // withdraw perform the transferring the ethers 
    function withdraw(address payable recieverAddr,uint recieverAmount)private{
       recieverAddr.transfer(recieverAmount);  //it will transfer the amount of ether to this reciever account
    }

    // this actual withdrawl function will be defined for trasferrring the amount to multiple address

    function withdraws(address payable[] memory addrs, uint[] memory amount)payable public isOwner{ 
        // add the value of transaction to the  total_value in the smart contract 
        total_value+=msg.value;

        // first the length of address and length of amount should be same 
        require(addrs.length==amount.length,"the length is not same as we think");


        uint Totalamount=sum(amount);

        // the value of message in addition to stored value should be more than total amounts
        require(total_value>=Totalamount,"the total_value is less than the Totalamount");

        for(uint i=0;i<addrs.length;i++){
            // first subtract the transferring amount from the total_value and then send to the reciever address
           total_value-=amount[i];

        //  and now its time to the send the amount to the reciver adddress with the help of the withdraw function 

        withdraw(addrs[i],amount[i]);

        }

    }

}       


