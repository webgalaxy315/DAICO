
pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    // user call this method
    function createCampaign (uint _minContribution) public {
        address newCampaign = new Campaign(_minContribution, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
}

contract Campaign {
    address public manager;
    uint public minContribution;
    mapping(address => bool) public contributors;
    Request[] requests;
    uint contributorsCount;
    
    struct Request {
        string description;
        uint amount;
        address vendor;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalCount;
    }
    constructor (uint _minContribution, address _manager) public {
        minContribution = _minContribution;
        manager = _manager;
    }
    
    function contribute() public payable {
        require(msg.value >= minContribution);
        contributors[msg.sender] = true;
        contributorsCount++;
    }
    
    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }
    
    function createRequest (string _description, uint _amount, address _vendor) public onlyManager {
        Request memory newRequest = Request({
            description: _description,
            amount: _amount,
            vendor: _vendor,
            complete: false,
            approvalCount: 0
        });
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        require(contributors[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public onlyManager {
        Request storage request = requests[index];
        require(!request.complete);
        require(request.approvalCount > (contributorsCount/2));
        
        request.vendor.transfer(request.amount);
        request.complete = true;
    }
    
}