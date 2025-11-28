// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Contrat principal EchoChain V1.1 sur MegaETH Timothy Testnet (Chain ID 6343)
// Ajoute la logique de partage de frais (Fee Splitter) et la racine Merkle pour les récompenses.

contract EchoChain {
    // Adresses initiales
    address public immutable owner;
    // Adresse où iront les frais de transaction (pour la maintenance ou la trésorerie DAO future)
    address public feeRecipient; 
    
    // Compteur d'Échos
    uint256 public echoCount = 0;
    string public constant VERSION = "V1.1 - Fee Splitter & Merkle Root";

    // Structure de récompenses Merkle Tree (pour les airdrops futurs ou les preuves de contribution)
    // C'est la racine (hash) qui prouve que l'ensemble des récompenses est sécurisé.
    bytes32 public currentMerkleRoot; 

    // Événement pour l'émission d'un Écho
    event Echo(uint256 indexed echoId, address indexed from, uint256 timestamp);
    // Événement pour la mise à jour des paramètres critiques
    event ParametersUpdated(address newFeeRecipient, bytes32 newMerkleRoot);

    constructor(address _feeRecipient) {
        owner = msg.sender;
        feeRecipient = _feeRecipient;
        // Racine Merkle initiale pour la sécurité (doit être mise à jour après un premier airdrop)
        currentMerkleRoot = 0x0; 
    }

    // Modificateur pour restreindre les fonctions à l'owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    /**
     * @dev Crée un nouvel Écho et partage les frais (s'il y en a)
     * @notice Le contrat accepte les transactions avec de la valeur (ETH/MEGA-ETH)
     */
    function createEcho() external payable {
        echoCount++;
        
        // Logique de partage des frais (simulée pour le MVP)
        if (msg.value > 0) {
            // Dans le MVP, tous les frais vont au 'feeRecipient' (trésorerie)
            (bool success, ) = payable(feeRecipient).call{value: msg.value}("");
            require(success, "Fee transfer failed");
        }

        emit Echo(echoCount, msg.sender, block.timestamp);
    }
    
    // Fonction permettant à l'owner de mettre à jour la racine Merkle (nécessaire pour les airdrops)
    function updateMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
        currentMerkleRoot = _newMerkleRoot;
        emit ParametersUpdated(feeRecipient, _newMerkleRoot);
    }

    // Fonction pour changer le destinataire des frais (par exemple, pour passer à une DAO)
    function setFeeRecipient(address _newFeeRecipient) external onlyOwner {
        feeRecipient = _newFeeRecipient;
        emit ParametersUpdated(_newFeeRecipient, currentMerkleRoot);
    }

    function getVersion() external pure returns (string memory) {
        return VERSION;
    }
}
