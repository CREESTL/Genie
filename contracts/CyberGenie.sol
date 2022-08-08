// SPDX-License-Identifier: MIT

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                ___ _  _ ____    ____ _   _ ___  ____ ____    ____ ____ _  _ _ ____                      ////
////                 |  |__| |___    |     \_/  |__] |___ |__/    | __ |___ |\ | | |___                      ////
////                 |  |  | |___    |___   |   |__] |___ |  \    |__] |___ | \| | |___                      ////
////                                                                                                         ////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import "erc721a/contracts/ERC721A.sol";

contract CyberGenie is Ownable, ERC721A, ReentrancyGuard {

    // Max allowed minting per address
    uint public constant MAX_PER_ADDRESS = 3;
    // Max token supply
    uint public constant MAX_SUPPLY = 5000;
    // Province hash
    string public constant PROVENANCE = '123';
    // Minted reserved token count
    uint public constant MINTED_RESERVE = 0;
    // Max reserved tokens
    uint public constant MAX_RESERVE = 150;
    // Public mint price
    uint256 public mintPrice = 0.1 ether;
    //
    mapping(address => bool) private whitelistClaimed;

    bytes32 public merkleRoot;
    uint32 public publicMintStart;
    bool public isPublicSaleActive;
    bool public isWhitelistMintEnabled;
    string private baseTokenURI;

    constructor()
        ERC721A("The Cyber Genie", "CG") {
    }
        
    modifier validateCount(uint256 _count) {
      require(_count > 0 && _count + _numberMinted(_msgSender()) - _getAux(_msgSender()) <= MAX_PER_ADDRESS, 'CyberGenie: Exceeded max token per address');
      require(totalSupply() + _count <= MAX_SUPPLY, "CyberGenie: Exceeded max supply");
      _;
    }

    modifier validatePrice(uint256 _count) {
      require(msg.value >= _count * mintPrice, 'CyberGenie: Insufficient funds');
      _;
    }

    /**
     * @dev See {ERC721A-_baseURI}.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    /**
     * @dev sets the base uri for {_baseURI}
     */
    function setBaseURI(string calldata baseURI) external onlyOwner {
        baseTokenURI = baseURI;
    }

    /**
     * @dev sets the mint price in wei for {price}
     */
    function setMintPrice(uint256 _newMintPrice) external onlyOwner {
        mintPrice = _newMintPrice;
    }

    /**
     * @dev sets the state of public sale for {isPublicSaleActive}
     */
    function setPublicSaleState(bool _newState) public onlyOwner {
        isPublicSaleActive = _newState;
    }

    /**
     * @dev sets the state of whitelist public sale for {isWhitelistMintEnabled}
     */
    function setIsWhitelistMintEnabled(bool _newState) public onlyOwner {
        isWhitelistMintEnabled = _newState;
    }

    // Set the Merkleroot for the collection
    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /**
     * @dev Owner minting
     *
     * Requirements:
     *
     * - `MINTED_RESERVE` must be less than `MAX_RESERVE`.
     *
     */
    function airdropOwner(address[] calldata _addrs, uint256[] calldata _counts) external onlyOwner {
        require(MINTED_RESERVE <= MAX_RESERVE, "CyberGenie: Exceeded max reserve");
        for (uint256 i = 0; i < _addrs.length; i++) {
            _mint(_addrs[i], _counts[i]);
            _setAux(_addrs[i], uint64(_getAux(_addrs[i]) + _counts[i]));
        }
    }


    /**
     * @dev Public minting for whitelist
     *
     * Requirements:
     *
     * - `isWhitelistMintEnabled` must be true.
     * - `_count` must be greater than 0.
     *
     */
    function whitelistMint(uint32 _count, bytes32[] calldata _merkleProof) public payable validateCount(_count) validatePrice(_count) {
        require(isWhitelistMintEnabled, 'CyberGenie: Whitelist sale is not active');
        require(!whitelistClaimed[_msgSender()], 'CyberGenie: Address already claimed');
        bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'CyberGenie: Invalid Merkle Proof');

        whitelistClaimed[_msgSender()] = true;
        _safeMint(_msgSender(), _count);
    }

    /**
     * @dev Public minting during public sale
     *
     * Requirements:
     *
     * - `isPublicSaleActive` must be true.
     * - `_count` must be greater than 0.
     *
     */
    function mint(uint32 _count) public payable validateCount(_count) validatePrice(_count) {
        require(isPublicSaleActive, "CyberGenie: Public Sale must be active to mint");
        _mint(_msgSender(), _count);
    }

    /**
     * @dev Withdraw contract balance
     *
     * Requirements:
     *
     * - `msg.sender` must be 0xd0aa42a16C3330145E2aD39294B32652CccA4DdE.
     * - `success` must be true.
     *
     */
    function withdraw() external nonReentrant {
        require(msg.sender == 0xd0aa42a16C3330145E2aD39294B32652CccA4DdE);
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }
}