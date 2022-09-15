// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Bolao {

    address public owner;
    address[] private jogadores;
    address private ganhador;

    constructor() {
        owner = msg.sender;
    }


    function apostar() external payable {
        require(msg.value >= 0.1 ether);
        jogadores.push(msg.sender);
    }


    function sorteiaGanhador() external onlyOwner returns(address) {
        uint index = random() % jogadores.length;
        ganhador = jogadores[index];
        payable(ganhador).transfer((address(this).balance));
        zeraJogadores();
        return ganhador;
    }


    function getJogadores() external view returns (address[] memory) {
        return jogadores;
    }


    function totalAposta() external view returns(uint) {
        return address(this).balance;
    }


    modifier onlyOwner() {
        require(msg.sender == owner, unicode"Apenas o owner tem esse poder!");
        _;
    }

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, jogadores)));
    }

    function zeraJogadores() private {
        jogadores = new address[](0);
    }
}
