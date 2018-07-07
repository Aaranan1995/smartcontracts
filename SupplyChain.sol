pragma solidity ^0.4.4;

contract SupplyChain {
  struct ProofEntry {
    address owner;
    string encryptedProof;
    string publicProof;
    string previousTrackingId;
  }

  mapping (string => ProofEntry) private proofs;
  mapping (string => mapping (address => bool )) private isTransfered;

  event StoreProofCompleted(
    address from,
    string trackingId,
    string previousTrackingId
  );

  event TransferCompleted(
    address from,
    address to,
    string trackingId
  );


  function SupplyChain() {

  }
  
  function storeProof(string trackingId, string previousTrackingId, string encryptedProof, string publicProof) returns(bool success) {
    
    if (hasProof(trackingId)) {
      return false;
    }
    
    if (sha3(previousTrackingId) != sha3("root")) {
      ProofEntry memory pe = getProofInternal(previousTrackingId);
      if (msg.sender != pe.owner && !isTransfered[previousTrackingId][msg.sender]) {
        return false;
      }

    }

    proofs[trackingId] = ProofEntry(msg.sender, encryptedProof, publicProof, previousTrackingId);
    StoreProofCompleted(msg.sender, trackingId, previousTrackingId);
    return true;
  }

  function transfer(string trackingId, address newOwner) returns(bool success) {
    
    if (hasProof(trackingId)) {
      ProofEntry memory pe = getProofInternal(trackingId);
      if (msg.sender == pe.owner) {
      
        isTransfered[trackingId][newOwner] = true;
        TransferCompleted(msg.sender, newOwner, trackingId);
      }
      return true;
    }
        
    return false;
  }

  function hasProof(string trackingId) constant internal returns(bool exists) {
    return proofs[trackingId].owner != address(0);
  }

  function getProofInternal(string trackingId) constant internal returns(ProofEntry proof) {
    if (hasProof(trackingId)) {
      return proofs[trackingId];
    }

    throw;
  }

  function getProof(string trackingId) constant returns(address owner, string encryptedProof, string publicProof, string previousTrackingId) {
    if (hasProof(trackingId)) {
      ProofEntry memory pe = getProofInternal(trackingId);
      owner = pe.owner;
      encryptedProof = pe.encryptedProof;
      publicProof = pe.publicProof;
      previousTrackingId = pe.previousTrackingId;
    }
  }

  function getEncryptedProof(string trackingId) constant returns(string encryptedProof) {
    if (hasProof(trackingId)) {
      return getProofInternal(trackingId).encryptedProof;
    }
  }
  
  function getPublicProof(string trackingId) constant returns(string publicProof) {
    if (hasProof(trackingId)) {
      return getProofInternal(trackingId).publicProof;
    }
  }

  function getOwner(string trackingId) constant returns(address owner) {
    if (hasProof(trackingId)) {
      return getProofInternal(trackingId).owner;
    }
  }

  function getPreviousTrackingId(string trackingId) constant returns(string previousTrackingId) {
    if (hasProof(trackingId)) {
      return getProofInternal(trackingId).previousTrackingId;
    }
  }
}
