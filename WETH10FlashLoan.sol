// SPDX-License-Identifier: 0x19
pragma solidity ^0.8.7;
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
interface IERC3156FlashBorrower {

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);

}
interface IERC3156FlashLender {

    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);

}
contract WETH10FlashLoan {

    address private constant WETH = 0xf4BB2e28688e89fCcE3c0580D37d36A7672E8A9F;
    bytes32 public constant CALLBACK = keccak256("ERC3156FlashBorrower.onFlashLoan");
    IERC3156FlashLender public FlashLender;
    address public owner;
    
    constructor() {
        owner = msg.sender;
        FlashLender = IERC3156FlashLender(WETH);
    }

    function startFlashLoan() public {
        require(msg.sender == owner, "only owner!");
        uint256 amount = 1000 ether;
        bytes memory data = "";
        IERC20(WETH).approve(WETH, amount);
        FlashLender.flashLoan(IERC3156FlashBorrower(address(this)), WETH, amount, data);
    }

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data) 
    external returns (bytes32) {
        require(msg.sender == WETH, "only the FlshLender can call this function!");
        //logic
       return CALLBACK;
    }

}