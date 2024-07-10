/*
题目#2
编写一个简单的 NFT市场合约，使用自己的发行的 Token 来买卖 NFT， 函数的方法有：

list() : 实现上架功能，NFT 持有者可以设定一个价格（需要多少个 Token 购买该 NFT）并上架 NFT 到 NFT 市场。
buyNFT() : 实现购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT。
请在回答贴出你的代码或者 github 链接。
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//@Author liujingze
//@dev withdraw and deposit ERC20 token

import "./IERC721.sol";
import "./IERC20.sol";

contract nftmarket {
    mapping(address => mapping(uint256 => uint256)) public nftList;

    function listItem(
        address token_address,
        uint256 tokenId,
        uint sale_price
    ) public {
        require(IERC721(token_address).getApproved(tokenId)==address(this), "Not approved");
        nftList[token_address][tokenId] = sale_price;
    }

    function buynft(
        address token_address,
        uint256 tokenId,
        address buy_token_address,
        uint buy_token_amount
    ) public {
        require(
            nftList[token_address][tokenId] > 0,
            "The NFT is not listed on the market"
        );
        require(
            buy_token_amount >= nftList[token_address][tokenId],
            "Insufficient funds"
        );
        IERC20(buy_token_address).transferFrom(
            msg.sender,
            address(this),
            nftList[token_address][tokenId]
        );
        IERC721(token_address).safeTransferFrom(
            IERC721(token_address).ownerOf(tokenId),
            msg.sender,
            tokenId
        );

    }

     function tokensReceived(address from,  uint amount, bytes memory data) public returns(bool){

        (uint256 tokenId, address token_address) = abi.decode(data,(uint256,address));

        require(
            nftList[token_address][tokenId] > 0,
            "The NFT is not listed on the market"
        );
        require(
            amount == nftList[token_address][tokenId],
            "Insufficient funds"
        );

        IERC721(token_address).safeTransferFrom(
            IERC721(token_address).ownerOf(tokenId),
            from,
            tokenId
        );

        return true;


    }
}

