// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC20{
    function totalSupply() external view returns(uint);

    function balanceOf(address amount) external view returns(uint);

    function transfer(address recipient, uint amount) external returns(bool);

    function allowance(address owner, address spender)
    external 
    view 
    returns (uint);

    function approve(address spender, uint amount) external returns(bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount)
        external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender,uint amount);    
}

contract ERC20 is IERC20 {
    uint public totalSupply;
    mapping(address => uint) private _balanceOf;
    mapping(address => bool) public blacklistedAddress;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18;


    function balanceOf(address account) external view returns(uint){
        if(!blacklistedAddress[account]){
            return _balanceOf[account];
        }
        else{
            return 0;
        }
    }

    function transfer(address recipient, uint amount) external returns(bool){
        require(!blacklistedAddress[recipient],"This account is blacklisted" );
         _balanceOf[msg.sender] -= amount;
         _balanceOf[recipient] += amount;
         emit Transfer(msg.sender, recipient, amount);
         return true;
    }

     function approve(address spender, uint amount) external returns(bool){
         allowance[msg.sender][spender] = amount;
         emit Approval(msg.sender,spender,amount);
         return true;
     }

      function transferFrom(
        address sender,
        address recipient,
        uint amount)
        external returns (bool){
           allowance[sender][msg.sender] -= amount;
           _balanceOf[sender] -= amount;
           _balanceOf[recipient] += amount;
           emit Transfer(sender, recipient, amount);
           return true; 
        }

        function mint(uint amount) external {
            _balanceOf[msg.sender] += amount;
            totalSupply += amount;
            emit Transfer(address(0),msg.sender,amount);
        }

         function burn(uint amount) external {
            _balanceOf[msg.sender] -= amount;
            totalSupply -= amount;
            emit Transfer(msg.sender,address(0),amount);
        }

        function blacklist(address account) external returns(bool){
            blacklistedAddress[account] = true;
            _balanceOf[account] = 0;
            return true;
     }

}