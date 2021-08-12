// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract MyContract {
    string public myString = 'hello world';
}

contract IntegerExample {
    uint public myUint;

    function setMyUint(uint _myUint) public {
    myUint = _myUint;
}
}

contract BooleanExample {
    bool public myBool;
    
    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }
}

// rollover is unchecked
contract RolloverExample {
    uint8 public myUint8;
    
    function decrement() public {
        unchecked {
            myUint8--;
        }
    }
    
    function increment() public {
        myUint8++;
    }
}

contract AddressExample {
    address public myAddress;
    
    function setAddress(address _address) public {
        myAddress = _address;
    }
    
    function getBalanceOfAccount() public view returns(uint) {
        return myAddress.balance;
    }
}

contract StringExample {
    string public myString = 'Benson ';
    
    function setMyString(string memory _myString) public {
        myString = _myString;
    }
}

// Address
contract SendMoneyExample {
    uint public balanceReceived;
    uint public lockedUntil;
    
    function receiveMoney() public payable {
        balanceReceived += msg.value;
        // locking up its balance in a timely manner
        lockedUntil = block.timestamp + 1 minutes;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function withdrawMoney() public {
        if(lockedUntil < block.timestamp){
            address payable to = payable(msg.sender);
            to.transfer(getBalance());
        }
    }
    
    function withdrawMoneyTo(address payable _to) public {
        if(lockedUntil < block.timestamp){
            _to.transfer(getBalance());
        }
    }
}

// Stopping, Pausing contracts
contract StartStopUpdateExample {
    address public owner;
    bool public paused;
    
    constructor(){
        owner = msg.sender;
    }
    
    function sendMoney() public payable {
        
    }
    
    function setPaused(bool _paused) public {
        require(msg.sender == owner, 'You are not the owner.');
        paused = _paused;
    } 
    
    function withdrawAllMoney(address payable _to) public {
        require(owner == msg.sender, 'Withdraw is not allowed because you are not the owner.');
        require(paused == false, 'Contract Paused.');
        _to.transfer(address(this).balance);
    }
    
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, 'You are not the owner.');
        selfdestruct(_to);
    }
}

// mapping example 
contract SimpleMappingExamples {
    mapping (uint => bool) public myMapping;
    mapping (address => bool) public myAddressMapping;
    
    function setValue(uint _index) public {
        myMapping[_index] = true;
    }

    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }
}

contract MappingPractice {
    mapping (uint => mapping(uint => bool)) uintUintBoolMapping;
    
    function setUintUintBoolMapping(uint _index1, uint _index2, bool _value) public {
        uintUintBoolMapping[_index1][_index2] = _value;
    }
    
    function getUintUintBoolMapping(uint _index1, uint _index2) public view returns (bool) {
        return uintUintBoolMapping[_index1][_index2];
    }
    
}

// struct example
contract MappingsStructExample {
    
    
    // https://blog.naver.com/blokorea/221311000461
    struct Payment {
        uint amount;
        uint timestamp;
    }
    
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }
    
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function sendMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Payment memory payment = Payment(msg.value, block.timestamp);
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
    }
    
    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender].totalBalance, 'Not enough fund.');
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
    
    function withdrawAllmoney(address payable _to) public {
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
}

// execption and revert example
contract ExceptionExample {
    mapping(address => uint64) public balanceReceived;

    function receivieMoney() public payable {
        assert(msg.value == uint64(msg.value));
        balanceReceived[msg.sender] += uint64(msg.value);
        assert(balanceReceived[msg.sender] >= uint64(msg.value));
    }
    
    // function withdrawMoney(address payable _to, uint _amount) public {
        // if(_amount <= balanceReceived[msg.sender]) {
            // balanceReceived[msg.sender] -= _amount;
            // _to.transfer(_amount);
        // }
    // }
    
    function withdrawMoney(address payable _to, uint64 _amount) public {
        require(balanceReceived[msg.sender] >= _amount, 'Not enough funds');
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
    
}


// try/catch
contract WillThrow {
    function aFunction() public {
        require(false, "Error message");
    }
}

contract Errorhandling {
    event ErrorLogging(string reason);
    function catchError() public{
        WillThrow will = new WillThrow();
        try will.aFunction() {
        }   catch Error(string memory reason) {
            emit ErrorLogging(reason);   
            }
    }
}