//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OZVolcanoCoin is
    Ownable,
    ERC20("Volcano Coin - Christian Mora", "VCCM")
{
    uint256 constant initialSupply = 10000;
    uint256 private _counter;
    address public admin;
    mapping(address => Payment[]) record;

    event TransferEvent(string _label, address _recipient, uint256 _amount);
	event supplyChanged(uint _quantity);
    enum PaymentType {
        Unknown,
        Basic,
        Refund,
        Dividend,
        Group
    }

    constructor() {
        _mint(_msgSender(), initialSupply);
        admin = _msgSender();
    }

    struct Payment {
        uint256 id;
        uint256 timestamp;
        PaymentType paymentType;
        string comment;
        address recipient;
        uint256 amount;
    }

    function _increaseSupply() public onlyOwner {
        _mint(_msgSender(), totalSupply());
		emit supplyChanged(totalSupply());
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        Payment[] storage recordUser = record[_msgSender()];
        recordUser.push(
            Payment({
                id: _incrementCount(),
                timestamp: block.timestamp,
                paymentType: PaymentType.Unknown,
                comment: "",
                recipient: recipient,
                amount: amount
            })
        );
        record[_msgSender()] = recordUser;
        emit TransferEvent("Transfer Successful", recipient, amount);
        return true;
    }

    function getPayments(address user) public view returns (Payment[] memory) {
        return record[user];
    }

    function updatePayment(
        uint256 id,
        PaymentType ptype,
        string memory comment
    ) public {
        require(id != 0, "Id invalid");
        require(
            ptype >= PaymentType.Unknown && ptype <= PaymentType.Group,
            "Payment Type invalid"
        );
        require(bytes(comment).length != 0, "Comment invalid");

        Payment[] storage recordUser = record[_msgSender()];
        for (uint256 i = 0; i < recordUser.length; i++) {
            if (recordUser[i].id == id) {
                Payment storage payment = recordUser[i];
                payment.paymentType = ptype;
                payment.comment = comment;
                break;
            }
        }
    }

    function updatePayment(uint256 id, PaymentType ptype) public {
        require(id != 0, "Id invalid");
        require(
            ptype >= PaymentType.Unknown && ptype <= PaymentType.Group,
            "Payment Type invalid"
        );
        string memory text = concatenate(
            "updated by ",
            Strings.toHexString(uint256(uint160(admin)))
        );
        updatePayment(id, ptype, text);
    }

    function _incrementCount() internal returns (uint256) {
        return ++_counter;
    }

    function concatenate(string memory created, string memory addressAdmin)
        public
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(created, " ", addressAdmin));
    }
}
