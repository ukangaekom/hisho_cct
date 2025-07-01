// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.25;



// import {ERC721, ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";


// contract HishoNFT is ERC721, ERC721URIStorage{

//     error Id_Not_Mintable();

//     using Counters for Counters.Counter;

//     Counters.Counter public tokenIdCounter;
//     uint256[] private tokenIds;
//     mapping(uint256=> bool) public Exist;
//     mapping(uint256 tokenId => bool qualified) public upgradable;
//     mapping(uint256 => bool) private availableTokenId;
//     mapping(uint256 tokenId => uint16 agentLevel) public agentLevel;
//     mapping(address => bool) private authorize; //Checking if an address has admin priviledges


//     string[] ipfsUri = [
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_agent.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_astronaut.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_hiker.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_matrix.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_japanese_suamri.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_roman_soldier.json",
//     "https://peach-defeated-sawfish-855.mypinata.cloud/ipfs/bafybeidnbs5pzjdrwdw2wuocxe6c3yycfna6u5prlkxkbahm22ykmirufm/hisho_oracle.json"
//     ];

//     address private immutable owner;

//     constructor() ERC721("Hisho Agentic NFTs", "Hisho") {
//         owner = msg.sender;

//     }

//     // MODIFIERS
//     //  Modifier 
//         modifier onlyOwner{
//             require(msg.sender == owner,"You are not authorized to reset season");
//             _;
//         }

//         modifier authorized{
//             require(authorize[msg.sender],"You are not authorize to use this function");
//             _;
//     }


//     // Authorizing Functions
    
//         function giveAuthority (address _contract) public onlyOwner{
//             authorize[_contract] = true;
//     }

//         function revokeAuthority(address _contract) public onlyOwner{
//             authorize[_contract] = false;
//     }



//     // SafeMint Function 
//     function safeMint(address _to) public authorized{
//         uint256 tokenId = tokenIdCounter.current();
//         tokenIdCounter.increment();
//         availableTokenId[tokenId]=false;
//         Exist[tokenId] = true;
//         tokenIds.push(tokenId);
//         if (tokenId == 0){
//             agentLevel[tokenId] = 0;
//             _safeMint(_to, tokenId);
//             _setTokenURI(tokenId, ipfsUri[0]);

//         }else{
//             agentLevel[tokenId] = 1;

//             _safeMint(_to, tokenId);
//             _setTokenURI(tokenId, ipfsUri[1]);
            
//         }
        

//     }

//     function reMint(address _to, uint256 _tokenId) public authorized{
//         require(availableTokenId[_tokenId],"This NFT already exist");
//         if(tokenIdCounter.current() < _tokenId){
//             revert Id_Not_Mintable();
//         }
//         Exist[_tokenId] = true;

//         _safeMint(_to, _tokenId);
//         _setTokenURI(_tokenId, ipfsUri[agentLevel[_tokenId]]);

        
//     } 

//     function upgrade_agent(uint256 _tokenId) public authorized{
//         require(availableTokenId[_tokenId],"Invalid tokenId");
//         require(upgradable[_tokenId],"Not upgradable");
//         upgradable[_tokenId] = false;
//         agentLevel[_tokenId] += 1;
//         _setTokenURI(_tokenId, ipfsUri[agentLevel[_tokenId]]);

//     }


//      function tokenURI(uint256 _tokenId)
//             public view override(ERC721, ERC721URIStorage) returns (string memory)
//         {
//             return super.tokenURI(_tokenId);
//         }

//         // 
//         function burnNFT(uint256 _tokenId) public authorized{
//             Exist[_tokenId] = false;
//             _burn(_tokenId);
//             availableTokenId[_tokenId] = true;

            
//         }

//     // The following function is an override required by Solidity.
//         function _burn(uint256 _tokenId) internal  override(ERC721, ERC721URIStorage){
//             super._burn(_tokenId);
            
//         }


    


// }