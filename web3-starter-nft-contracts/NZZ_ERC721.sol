// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 /* is ERC165 */ {
    mapping (address=>uint256) private _balance;
    mapping (uint256=>address) private _ownerOf;
    mapping (uint256=>address) private _tokenApproval;
    mapping (address=>mapping(address=>bool)) private _operateApproval;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor(){
        mint(msg.sender, 100);
    }

    function mint(address _to, uint256 _tokenId) public  {
        require(_ownerOf[_tokenId] == address(0), "token id already minted.");
        _balance[_to] = _balance[_to] + 1;
        _ownerOf[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);
    }

    function name() external  returns (string memory _name){
        _name = "myNFT";
    }

    function symbol() external view returns (string memory _symbol){
        _symbol = "demo";
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory){
        // just for test, meta data should be different in real.
        return "https://cyan-sheer-tarsier-951.mypinata.cloud/ipfs/QmWYcGTT3d12nuCZL3ZiCrSnz1vh6qs6V8Seg3LNgFVetf";
    }

    function balanceOf(address _owner) external view returns (uint256){
        return _balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address){
        return _ownerOf[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(_ownerOf[_tokenId] == _from, "invalid token");
        require(msg.sender == _from || msg.sender == _tokenApproval[_tokenId] || _operateApproval[_from][msg.sender] == true, "invalid sender");
        _balance[_from] = _balance[_from] - 1;
        _balance[_to] = _balance[_to] + 1;
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(msg.sender == _ownerOf[_tokenId], "invalid sender");
        _tokenApproval[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external{
        _operateApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address){
        return _tokenApproval[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
        return _operateApproval[_owner][_operator];
    }
}
