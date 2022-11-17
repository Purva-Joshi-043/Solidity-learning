// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC721.sol";
import "./ERC20.sol";

contract VaultWallet {
    ERC20 public token;
    ERC721 public nft;
    uint public nftId;

    constructor (
        address _nft,
        address _token
    ){
        nft = ERC721(_nft);
        token = ERC20(_token);
    }
    
    function depositTo(
        uint amount,
        uint _nftId
    )  external payable{
        nftId = _nftId;
        require(msg.sender == nft.ownerOf(_nftId), "from != owner");
        nft.transferFrom(msg.sender,address(this),_nftId);
        token.mint(amount);
    }

    function buyTokens() external payable{
        require(msg.value!=0,"You have to provide some amount");
        token.transfer(msg.sender,msg.value);
    }

}
