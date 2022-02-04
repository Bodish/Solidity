pragma solidity 0.8.3;



// SPDX-License-Identifier: GPL-3.0

contract Reward {

   // address public  owner;
   
    struct infoAddress {
        uint256 value;
        uint256 lastDraw;
        uint256 numOfDraw;
        uint start;
    }

     mapping(address => infoAddress) public ownersList;

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

     modifier isPay() {
        require(ownersList[msg.sender].value > 0, "You not pay");
        _;
    }

    function getReward () public payable isPay {
    
        uint numOfPay = ((block.timestamp - ownersList[msg.sender].start)  / 1 minutes);
        if (numOfPay>13) {
            numOfPay = 13;
        }
        if (numOfPay > 0 && ownersList[msg.sender].numOfDraw < 13) {
            payable(msg.sender).transfer(1 ether * (numOfPay - ownersList[msg.sender].numOfDraw));
            ownersList[msg.sender].numOfDraw += numOfPay - ownersList[msg.sender].numOfDraw;
            ownersList[msg.sender].start = block.timestamp;
        }

    }

    function payContract () public payable {
        payable(address(this)).transfer(msg.value);
        ownersList[msg.sender].value += msg.value;
        ownersList[msg.sender].start = block.timestamp;  
       
    }

}