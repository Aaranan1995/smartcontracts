pragma solidity ^0.4.0;
contract RentalAgreement {
    struct PaidRent {
    uint id;
    uint value; 
    }

    PaidRent[] public paidrents;

    uint public createdTimestamp;

    uint public rent;
    string public house;

    address public landlord;

    address public tenant;
    enum State {Created, Started, Terminated}
    State public state;

    function RentalAgreement(uint _rent, string _house) {
        rent = _rent;
        house = _house;
        landlord = msg.sender;
        createdTimestamp = block.timestamp;
    }
    modifier require(bool _condition) {
        if (!_condition) throw;
        _;
    }
    modifier onlyLandlord() {
        if (msg.sender != landlord) throw;
        _;
    }
    modifier onlyTenant() {
        if (msg.sender != tenant) throw;
        _;
    }
    modifier inState(State _state) {
        if (state != _state) throw;
        _;
    }
    
    function getPaidRents() internal returns (PaidRent[]) {
        return paidrents;
    }

    function getHouse() constant returns (string) {
        return house;
    }

    function getLandlord() constant returns (address) {
        return landlord;
    }

    function getTenant() constant returns (address) {
        return tenant;
    }

    function getRent() constant returns (uint) {
        return rent;
    }

    function getContractCreated() constant returns (uint) {
        return createdTimestamp;
    }

    function getContractAddress() constant returns (address) {
        return this;
    }

    function getState() returns (State) {
        return state;
    }
    
    event agreementConfirmed();

    event paidRent();

    event contractTerminated();
    
    function confirmAgreement()
    inState(State.Created)
    require(msg.sender != landlord)
    {
        agreementConfirmed();
        tenant = msg.sender;
        state = State.Started;
    }

    function payRent()
    onlyTenant
    inState(State.Started)
    require(msg.value == rent)
    {
        paidRent();
        landlord.send(msg.value);
        paidrents.push(PaidRent({
        id : paidrents.length + 1,
        value : msg.value
        }));
    }
    and the contract is terminated */
    function terminateContract()
    onlyLandlord
    {
        contractTerminated();
        landlord.send(this.balance);
        state = State.Terminated;
    }
}
