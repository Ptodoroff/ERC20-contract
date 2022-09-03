pragma solidity 0.8.15;

interface ERC20Interface {
    function transfer(address to, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function approve(address spender, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function totalSupply() external view returns (uint);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ERC20Token is ERC20Interface {
    string public name;
    string public symbol;
    uint8  decimals;
    uint public totalSupply;

    mapping (address=>uint) public balances;
    mapping (address=> mapping(address=>uint)) allowed;

    constructor (string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) {
        name=_name;
        symbol=_symbol;
        decimals=_decimals;
        totalSupply=_totalSupply;
        balances[msg.sender]=_totalSupply;
    } 


    function transfer (address to, uint amount) external returns (bool) {
        require (balances[msg.sender]>=amount, "Insuficient ammount");
        balances[msg.sender]-=amount;
        balances[to]+=amount;

        emit Transfer (msg.sender, to, amount);
        return true;
    }

    function transferFrom (address from, address to, uint amount) external returns (bool) {
        uint allowance = allowed[from][msg.sender];
        require (balances[from]>=amount && allowance >=amount,   "Insuficient ammount");
        allowed[from][msg.sender]-= amount;
        balances[msg.sender]-=amount;
        balances[to]+=amount;
        emit Transfer (msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint amount) external  returns(bool) {
        require (spender !=msg.sender);
        allowed[msg.sender][spender]= amount;
        emit Approval(msg.sender,spender,amount);
        return true;

    }

    function allowance(address owner, address spender) external view returns (uint){
        return allowed[owner][spender];
    }

    function balanceOf (address owner) external view returns (uint){
        return  balances[owner];
    }

}