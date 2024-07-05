// SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

/// @author liujingze
/// @dev small bank 

/*
1. Deposit money into the bank.
2. The bank owner can withdraw all funds.
3. Record each address's deposited funds.
4. Store the amounts of funds deposited by the top three addresses in an array.
*/


// Updated at 2024-07-05
/*
1. Delete the MAX_AMOUNT、MID_AMOUNT、MIN_AMOUNT 
2. Use mapping query the top three address‘s deposit amount
3. add _ to the function variable
*/


contract SmallBank {

    mapping(address=>uint) public AddressToAmount;
    address  payable public BANK_OWER;

    address[] public TopThreeAddress = new address[](3);

    constructor (){

        BANK_OWER=payable(msg.sender);

    }


    function withdraw () public {
        require(msg.sender==BANK_OWER);
        BANK_OWER.transfer(address(this).balance);
    }

    function deposited() public payable {

        AddressToAmount[msg.sender]+=msg.value;

        calTopUser(AddressToAmount[msg.sender],msg.sender);
        
        

    }

    function calTopUser(uint _amount ,address _user_address ) private { 

        if (_amount<AddressToAmount[TopThreeAddress[2]]){
            return;

        }

        if (AddressToAmount[TopThreeAddress[2]]<_amount && _amount<=AddressToAmount[TopThreeAddress[1]] ){

            TopThreeAddress[2]=_user_address;
            return;

        }

        if (AddressToAmount[TopThreeAddress[1]]<_amount && _amount<=AddressToAmount[TopThreeAddress[0]]){


            if(TopThreeAddress[1]!=_user_address){

       
            TopThreeAddress[2]=TopThreeAddress[1];
            }
            

            TopThreeAddress[1]=_user_address;
            return;
        }
        if (_amount>AddressToAmount[TopThreeAddress[0]]){

             if(TopThreeAddress[0]!=_user_address){
            
            
            TopThreeAddress[2]=TopThreeAddress[1];
            
            TopThreeAddress[1]=TopThreeAddress[0];
            }
     
            TopThreeAddress[0]=_user_address;
            return;

        }
        
       
    
    }
    receive() external payable{

    }

    fallback() external payable{

    }



        


    

    
}