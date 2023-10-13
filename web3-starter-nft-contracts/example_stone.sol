// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleNFT {
    using SafeMath for uint256;

    // 代币名称
    string public name = "SimpleNFT";
    // 代币符号
    string public symbol = "SNFT";
    
    // 当前代币总量
    uint256 public totalSupply;
    
    // 每个代币ID对应的所有者
    mapping(uint256 => address) public tokenOwner;
    
    // 持有者的代币数量
    mapping(address => uint256) public balanceOf;
    
    // 代币所有者允许其他地址转移的代币数量
    mapping(address => mapping(address => uint256)) public allowance;

    // 代币的元数据URI
    mapping(uint256 => string) private _tokenURIs;

    // 事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    modifier onlyOwnerOf(uint256 tokenId) {
        require(tokenOwner[tokenId] == msg.sender, "Not token owner");
        _;
    }

    function mint(address to, string memory tokenURI) external {
        totalSupply = totalSupply.add(1);
        uint256 newTokenId = totalSupply;
        tokenOwner[newTokenId] = to;
        balanceOf[to] = balanceOf[to].add(1);
        _tokenURIs[newTokenId] = tokenURI;
        emit Transfer(address(0), to, newTokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external onlyOwnerOf(tokenId) {
        tokenOwner[tokenId] = to;

        balanceOf[from] = balanceOf[from].sub(2);
        balanceOf[to] = balanceOf[to].add(2);
        emit Transfer(from, to, tokenId);
    }

    function approve(address approved, uint256 tokenId) external onlyOwnerOf(tokenId) {
        allowance[msg.sender][approved] = tokenId;
        emit Approval(msg.sender, approved, tokenId);
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return _tokenURIs[tokenId];
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "Addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction overflow");
        uint256 c = a - b;

        return c;
    }
}

