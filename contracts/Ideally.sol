// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

contract Ideally {
    address public _owner;

    string constant CONTRACT_NAME = "IDEALLY_STORE";

    constructor() {
        _owner = msg.sender;
    }

    event NewIdeaAdded(uint256 id, address from);

    struct Collabrator {
        uint256 collabId;
        address from;
        bool isApproved;
    }

    struct Idea {
        uint256 Id;
        address payable ProposerName;
        string Title;
        string IdeaDescription;
        uint256 TotalUpvotes;
        string[] Tags;
        string pitchUri;
        uint256 timestamp;
    }

    mapping(uint256 => Collabrator[]) _ideaToCollabrationRequests;

    mapping(uint256 => address[]) _ideaToUpvotesList;

    mapping(uint256 => uint256) _totalFunding;

    mapping(uint256 => address[]) _projectIdToInvestors;

    Idea[] private allIdeas;

    function addIdea(
        string calldata title,
        string calldata description,
        string[] calldata tags,
        string calldata uri
    ) external {
        allIdeas.push(
            Idea(
                allIdeas.length,
                payable(msg.sender),
                title,
                description,
                0,
                tags,
                uri,
                block.timestamp
            )
        );
        emit NewIdeaAdded(allIdeas.length, msg.sender);
    }

    function addUpvote(uint256 IdeaId) external {
        for (uint i = 0; i < allIdeas.length; ) {
            if (allIdeas[i].Id == IdeaId) {
                allIdeas[i].TotalUpvotes++;
                _ideaToUpvotesList[IdeaId].push(msg.sender);
            }
            unchecked {
                i++;
            }
        }
    }

    function getPendingCollabReqests(uint256 projectId)
        external
        view
        returns (Collabrator[] memory)
    {
        return _ideaToCollabrationRequests[projectId];
    }

    function proposeCollabRequest(uint256 projectId) external {
        _ideaToCollabrationRequests[projectId].push(
            Collabrator(
                _ideaToCollabrationRequests[projectId].length,
                msg.sender,
                false
            )
        );
    }

    function approveCollabrationRequest(uint256 projectId, uint256 collabId)
        external
    {
        Collabrator[] memory temp = _ideaToCollabrationRequests[projectId];
        for (uint i = 0; i < temp.length; ) {
            if (temp[i].collabId == collabId) {
                _ideaToCollabrationRequests[projectId][i].isApproved = true;
            }
            unchecked {
                i++;
            }
        }
    }

    function fundProject(address payable owner, uint256 ideaId) public payable {
        owner.transfer(msg.value);
        _totalFunding[ideaId] = _totalFunding[ideaId] + msg.value;
        _projectIdToInvestors[ideaId].push(msg.sender);
    }

    function getFundingOfProject(uint256 projectId)
        public
        view
        returns (uint256)
    {
        return _totalFunding[projectId];
    }

    function getUpvotesList(uint256 projectId)
        public
        view
        returns (address[] memory)
    {
        return _ideaToUpvotesList[projectId];
    }

    function getAllIdeas() public view returns (Idea[] memory) {
        return allIdeas;
    }

    function getProjectFunders(uint256 projectId)
        public
        view
        returns (address[] memory)
    {
        return _projectIdToInvestors[projectId];
    }
}
