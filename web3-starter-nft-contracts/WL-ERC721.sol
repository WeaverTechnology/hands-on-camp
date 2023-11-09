//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
contract ERC721 /* is ERC165 */ {
    mapping (address=>uint256) private _balance;
    mapping (uint256=>address) private _ownerOf;
    mapping (uint256=>address) private _tokenApproval;
    mapping (address=>mapping(address=>bool)) private _operatoApproval;

    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor() {
        mint(msg.sender, 100);
    }
    function mint(address _to, uint256 _tokenId) public  {       
        require(_ownerOf[_tokenId] == address(0), "ERC721: tokenId already minted");
        _balance[_to] = _balance[_to] + 1;
        _ownerOf[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);
    }
     /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external pure returns (string memory _name){
        _name = "One-NFT";
    }

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external pure returns (string  memory _symbol){
        _symbol= "DEMO";
    }

    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId) external pure  returns (string memory){
        //return "https://cyan-sheer-tarsier-951.mypinata.cloud/ipfs/QmWYcGTT3d12nuCZL3ZiCrSnzLvh6qs6v8Seg3LNgFVetf/"+abi.encode(arg);
        return "https://cyan-sheer-tarsier-951.mypinata.cloud/ipfs/QmWYcGTT3d12nuCZL3ZiCrSnzLvh6qs6v8Seg3LNgFVetf/";
    }
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256){
        return _balance[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address){
        return _ownerOf[_tokenId];
    }

     
  

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(_ownerOf[_tokenId]==_from, "ERC721: invalid owner");
        require(msg.sender == _from || msg.sender == _tokenApproval[_tokenId] || _operatoApproval[_from][msg.sender] == true, "ERC721: invalid sender");

        unchecked{
            _balance[_from] = _balance[_from]-1;
            _balance[_to] = _balance[_to]+ 1;
        }
        _ownerOf[ _tokenId] = _to;

        _tokenApproval[_tokenId] = address(0);

        emit Transfer(_from, _to, _tokenId);

    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable{
        require(msg.sender == _ownerOf[_tokenId], "ERC721: invalid sender");
        _tokenApproval[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external{
        _operatoApproval[msg.sender] [_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address){
        return _tokenApproval[_tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
        return _operatoApproval[_owner][_operator];
    }
}
