pragma solidity ^0.5.8;

contract SimpleBank {
    uint8 private clientCount;
    mapping (address => uint) private balances;
    event Transfer(address indexed from, address indexed to, uint256 value);
    address public owner;

    event LogDepositMade(address indexed accountAddress, uint amount);

    
    constructor() public payable {
        require(msg.value == 30 ether, "30 ether initial funding required");
       
        owner = msg.sender;
        clientCount = 0;
    }

  
    function enroll() public returns (uint) {
        if (clientCount < 3) {
            clientCount++;
            balances[msg.sender] = 10 ether;
        }
        return balances[msg.sender];
    }

    
    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }


    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        
        if (withdrawAmount <= balances[msg.sender]) {
            balances[msg.sender] -= withdrawAmount;
            msg.sender.transfer(withdrawAmount);
        }
        return balances[msg.sender];
    }


    function transfer(address receiver, uint256 numTokens) public  returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

 
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }
}