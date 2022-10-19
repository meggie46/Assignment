
pragma solidity >=0.7.0 <0.9.0;
contract Ballot {
  /* mapping field below is equivalent to an associative array or hash.
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer to store the vote count
  */
  
  mapping (string => uint256) private votesReceived;
  address public chairperson;

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */
  
  string[] private candidateList;


/* This is the constructor which will be called once when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election
  */
  constructor(string[] memory candidateNames) {
      chairperson = msg.sender;
      candidateList = candidateNames;
  }
  
  /* To check chairperson is calling*/
  modifier onlyChair() {
         require(msg.sender == chairperson, 'Only chairperson');
         _;
    }
    
    function addcanditate(string memory name) public onlyChair{
    candidateList.push(name);
  }
  
  // This function returns the total votes a candidate has received so far
  function totalVotesFor(string memory candidate) view public onlyChair returns (uint256)  {

    require(validCandidate(candidate));
    return votesReceived[candidate];
  }

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote
  function castVote(string memory candidate) public {
    require(validCandidate(candidate));
    votesReceived[candidate] += 1;
  }

  function validCandidate(string memory candidate) view private returns (bool) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (keccak256(bytes(candidateList[i])) == keccak256(bytes(candidate))) {
        return true;
      }
    }
    return false;
  }
}