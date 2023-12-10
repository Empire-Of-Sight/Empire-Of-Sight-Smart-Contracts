// Sources flattened with hardhat v2.15.0 https://hardhat.org

// File @openzeppelin/contracts/utils/Context.sol@v4.9.2

//
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File @openzeppelin/contracts/access/Ownable.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.2

//
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/IERC1155.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

// File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.9.2

//
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
    function uri(uint256 id) external view returns (string memory);
}

// File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File @openzeppelin/contracts/utils/Address.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                0,
                "Address: low-level call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(
        bytes memory returndata,
        string memory errorMessage
    ) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.2

//
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    /**
     * @dev See {_setURI}.
     */
    constructor(string memory uri_) {
        _setURI(uri_);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(
        address account,
        uint256 id
    ) public view virtual override returns (uint256) {
        require(
            account != address(0),
            "ERC1155: address zero is not a valid owner"
        );
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory ids
    ) public view virtual override returns (uint256[] memory) {
        require(
            accounts.length == ids.length,
            "ERC1155: accounts and ids length mismatch"
        );

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(
        address account,
        address operator
    ) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        uint256 fromBalance = _balances[id][from];
        require(
            fromBalance >= amount,
            "ERC1155: insufficient balance for transfer"
        );
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(
                fromBalance >= amount,
                "ERC1155: insufficient balance for transfer"
            );
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            from,
            to,
            ids,
            amounts,
            data
        );
    }

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(
            operator,
            address(0),
            to,
            id,
            amount,
            data
        );
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            address(0),
            to,
            ids,
            amounts,
            data
        );
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
     */
    function _burn(address from, uint256 id, uint256 amount) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(
            ids.length == amounts.length,
            "ERC1155: ids and amounts length mismatch"
        );

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(
                fromBalance >= amount,
                "ERC1155: burn amount exceeds balance"
            );
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `ids` and `amounts` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155Received(
                    operator,
                    from,
                    id,
                    amount,
                    data
                )
            returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                IERC1155Receiver(to).onERC1155BatchReceived(
                    operator,
                    from,
                    ids,
                    amounts,
                    data
                )
            returns (bytes4 response) {
                if (
                    response != IERC1155Receiver.onERC1155BatchReceived.selector
                ) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(
        uint256 element
    ) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}

// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.9.2

//
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File contracts/SupraOracles/ISupraSValueFeed.sol

pragma solidity 0.8.19;

// depending on the requirement, you may build one or more
// data structures given below.

interface ISupraSValueFeed {
    // Data structure to hold the pair data
    struct dataWithoutHcc {
        uint256 round;
        uint256 decimals;
        uint256 time;
        uint256 price;
    }

    // Data Structure To Hold The Derived Pair Data
    struct derivedData {
        int256 roundDifference;
        uint256 derivedPrice;
        uint256 decimals;
    }

    // Below functions enable you to retrieve different flavours of S-Value
    // Term "pair ID" and "Pair index" both refer to the same, pair index mentiond in our data pairs list

    // Function to retrieve the data for a single data pair
    function getSvalue(
        uint256 _pairIndex
    ) external view returns (dataWithoutHcc memory);

    //Function to fetch the data for a multiple data pairs
    function getSvalues(
        uint256[] memory _pairIndexes
    ) external view returns (dataWithoutHcc[] memory);

    // Function to convert and derive new data pairs using two pair IDs and a mathematical operator multiplication(*) or division(/).
    function getDerivedSvalue(
        uint256 pair_id_1,
        uint256 pair_id_2,
        uint256 operation
    ) external view returns (derivedData memory);

    // Function to check  the latest Timestamp on which a data pair is updated. This will help you check the staleness of a data pair before performing an action.
    function getTimestamp(uint256 _tradingPair) external view returns (uint256);
}

// File contracts/ItemFuse.sol

/// SPDX-License-Identifier: Unveiled Tech License

/// 2023 Unveiled Tech. All rights reserved.

/// This smart contract and any part thereof, including but not limited to the source code,
/// documentation, and any associated artifacts, may not be used, copied, modified,
/// sublicensed, or distributed, in whole or in part, without the express written
/// permission of Unveiled Tech.

/// ΓûêΓûê    ΓûêΓûê ΓûêΓûêΓûê    ΓûêΓûê ΓûêΓûê    ΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûê ΓûêΓûê      ΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûê      ΓûêΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûêΓûê  ΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûê   ΓûêΓûê
/// ΓûêΓûê    ΓûêΓûê ΓûêΓûêΓûêΓûê   ΓûêΓûê ΓûêΓûê    ΓûêΓûê ΓûêΓûê      ΓûêΓûê ΓûêΓûê      ΓûêΓûê      ΓûêΓûê   ΓûêΓûê        ΓûêΓûê    ΓûêΓûê      ΓûêΓûê      ΓûêΓûê   ΓûêΓûê
/// ΓûêΓûê    ΓûêΓûê ΓûêΓûê ΓûêΓûê  ΓûêΓûê ΓûêΓûê    ΓûêΓûê ΓûêΓûêΓûêΓûêΓûê   ΓûêΓûê ΓûêΓûê      ΓûêΓûêΓûêΓûêΓûê   ΓûêΓûê   ΓûêΓûê        ΓûêΓûê    ΓûêΓûêΓûêΓûêΓûê   ΓûêΓûê      ΓûêΓûêΓûêΓûêΓûêΓûêΓûê
/// ΓûêΓûê    ΓûêΓûê ΓûêΓûê  ΓûêΓûê ΓûêΓûê  ΓûêΓûê  ΓûêΓûê  ΓûêΓûê      ΓûêΓûê ΓûêΓûê      ΓûêΓûê      ΓûêΓûê   ΓûêΓûê        ΓûêΓûê    ΓûêΓûê      ΓûêΓûê      ΓûêΓûê   ΓûêΓûê
///  ΓûêΓûêΓûêΓûêΓûêΓûê  ΓûêΓûê   ΓûêΓûêΓûêΓûê   ΓûêΓûêΓûêΓûê   ΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûêΓûêΓûêΓûêΓûê         ΓûêΓûê    ΓûêΓûêΓûêΓûêΓûêΓûêΓûê  ΓûêΓûêΓûêΓûêΓûêΓûê ΓûêΓûê   ΓûêΓûê

pragma solidity ^0.8.19;

/// @title Empire of Sight Item Contract
/// @dev Extends ERC-1155 basic standard multi-token implementation with various features for the highest safety
/// and the best gaming experience.
/// @notice Play https://empireofsight.com
/// @author leeevi, Unveiled Tech
contract ItemFuse is ERC1155, Ownable, ReentrancyGuard {
    /// Solidity's arithmetic operations with added overflow checks.
    using SafeMath for uint256;

    /// All the attributes of an item
    struct ItemInfo {
        uint256 minted;
        uint256 totalSupply;
        uint256 priceUsd; // (USD value in Wei)
        bool paused;
    }

    /// Pack contains multiple types of items for batch transactions.
    struct PackInfo {
        uint256[] itemIds;
        uint256[] itemAmounts;
        uint256 priceUsd; // (USD value in Wei)
        bool paused;
    }

    /// Tracking the item IDs.
    uint256 public itemIds;

    /// Cost of Mayne Transmuting items.
    uint256 public transmuteFee;

    /// Cost of batch Mayne Transmuting items.
    uint256 public transmuteFeeBatch;

    /// Sum of received transmuting fees counts from the last withdrawal.
    uint256 public transmuteFeeSum;

    // Limit of the ERC-20 token withdrawal amount in one transaction.
    uint256 internal _ERC20WithdrawalLimit = 5;

    /// Pause for minting.
    bool public pausedMint;

    /// Pause for Mayne Transmuting.
    bool public pausedMayneTransmute;

    /// Pause for burning.
    bool public pausedBurn;

    /// Minter role.
    mapping(address => bool) internal minters;

    /// Items (item ID => {item minted, item total supply, item price, item pause}).
    mapping(uint256 => ItemInfo) public items;

    /// Pack for a batch transaction (pack ID => {item IDs, item amounts, pack price, pack pause}).
    mapping(uint256 => PackInfo) public packs;

    /// SupraOracle Data Feed of FUSE/USDT price.
    ISupraSValueFeed internal sValueFeed;

    /// SupraOrace Price Index of FUSE/USDT.
    uint256 internal priceIndex = 88;

    /// Minted item(s).
    event Minted(
        address player,
        uint256 id,
        uint256 amount,
        bool isTransmuting
    );

    /// Batch minted items.
    event MintedBatch(
        address player,
        uint256[] ids,
        uint256[] amounts,
        bool isTransmuting
    );

    /// Batch minted pack(s).
    event MintedPack(address player, uint256 packId, uint256 amount);

    /// Mayne Transmuted item(s).
    event Transmuted(
        address player,
        uint256 id,
        uint256[] amounts,
        uint256[] slots
    );

    /// Batch Mayne Transmuted items.
    event TransmutedBatch(
        address player,
        uint256[] ids,
        uint256[] amounts,
        uint256[] slots
    );

    /// Burnt item(s).
    event Burnt(
        address player,
        uint256 id,
        uint256 amount,
        bool isVirtualizing,
        bool isBridging
    );

    /// Burnt items in a batch transaction.
    event BurntBatch(
        address player,
        uint256[] id,
        uint256[] amount,
        bool isVirtualizing,
        bool isBridging
    );

    ///-------------------------------------------------------------------------
    /// CONSTRUCTOR ////////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Initializes the contract with default values and item types.
    constructor()
        ERC1155("https://empireofsight.com/metadata/items/{id}.json")
    {
        address sValueFeed_ = 0x79E94008986d1635A2471e6d538967EBFE70A296;
        sValueFeed = ISupraSValueFeed(sValueFeed_);
        address minter = 0x947E0Cc54fB2a758Ab605da79aa6317D26A8A355;
        minters[minter] = true;
        transmuteFee = 0.003 ether;
        transmuteFeeBatch = 0.003 ether;
        transmuteFeeSum = 0;
        pausedMint = false;
        pausedMayneTransmute = false;
        pausedBurn = false;

        // Initialize items
        items[0] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 5.99 ether, /// $5.99
            paused: false
        });

        items[1] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 5.99 ether, /// $5.99
            paused: false
        });

        items[2] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 3.99 ether, /// $3.99
            paused: false
        });

        items[3] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 4.99 ether, /// $4.99
            paused: false
        });

        items[4] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 3.99 ether, /// $3.99
            paused: false
        });

        // Initialize other items with default values
        for (uint16 i = 5; i <= 39; ++i) {
            items[i] = ItemInfo({
                minted: 0,
                totalSupply: 10000,
                priceUsd: 0,
                paused: true
            });
        }

        itemIds = 39;
    }

    ///-------------------------------------------------------------------------
    /// MODIFIER /////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Modifier to restrict access to only minter.
    modifier onlyWithRole() {
        require(minters[msg.sender] || owner() == msg.sender, "not minter");
        _;
    }

    ///-------------------------------------------------------------------------
    /// VIEW FUNCTIONS /////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    // requesting s-value for a single pair
    function getPrice(
        uint256 _priceIndex
    ) public view returns (ISupraSValueFeed.dataWithoutHcc memory) {
        return sValueFeed.getSvalue(_priceIndex);
    }

    /// @dev Returns the latest price of the native currency.
    /// @return The latest price of the native currency.
    function getLatestPrice() public view returns (uint256) {
        uint256 price = getPrice(priceIndex).price;

        return price;
    }

    /// @dev Returns the price in native currency to purchase a specific item.
    /// @param id The ID of the item.
    /// @param amount The number of items to purchase.
    /// @return The price in native currency.
    function getItemsNativePrice(
        uint256 id,
        uint256 amount
    ) public view returns (uint256) {
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");

        uint256 nativeCurrencyPrice = getLatestPrice();
        return items[id].priceUsd.div(nativeCurrencyPrice).mul(amount);
    }

    /// @dev Returns the price in native currency to purchase a pack.
    /// @param packId The ID of the pack.
    /// @param amount The number of packs to purchase.
    /// @return The price in native currency.
    function getPacksNativePrice(
        uint256 packId,
        uint256 amount
    ) public view returns (uint256) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount can't be zero");

        uint256 nativeCurrencyPrice = getLatestPrice();
        return packs[packId].priceUsd.div(nativeCurrencyPrice).mul(amount);
    }

    /// @dev Returns the item IDs in a pack.
    /// @param packId The ID of the pack.
    /// @return An array of item IDs in the pack.
    function getItemsInPack(
        uint256 packId
    ) public view returns (uint256[] memory) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");

        return packs[packId].itemIds;
    }

    /// @dev Returns the amounts of items in a pack.
    /// @param packId The ID of the pack.
    /// @return An array of item amounts in the pack.
    function getAmountsInPack(
        uint256 packId
    ) public view returns (uint256[] memory) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");

        return packs[packId].itemAmounts;
    }

    ///-------------------------------------------------------------------------
    /// SET FUNCTIONS //////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Sets the base URI for token metadata.
    /// @param newuri The new base URI to be set.
    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    /// @dev Toggles the pause status for the mayneTransmute function.
    function setPauseMayneTransmute() external onlyOwner {
        pausedMayneTransmute = !pausedMayneTransmute;
    }

    /// @dev Toggles the pause status for the burn function.
    function setPauseBurn() external onlyOwner {
        pausedBurn = !pausedBurn;
    }

    /// @dev Toggles the pause status for all functions in the contract.
    function setPauseMint() external onlyOwner {
        pausedMint = !pausedMint;
    }

    /// @dev Sets the details of multiple packs.
    /// @notice The `priceUsd` must be in Wei.
    /// @param packIds The IDs of the packs.
    /// @param packInfoList The list of pack details including price and items.
    function setPacks(
        uint256[] memory packIds,
        PackInfo[] calldata packInfoList
    ) external onlyOwner {
        require(
            packIds.length > 0 && packIds.length == packInfoList.length,
            "invalid arrays"
        );

        for (uint256 i = 0; i < packIds.length; ++i) {
            PackInfo storage pack = packs[packIds[i]];
            PackInfo memory packInfo = packInfoList[i];

            require(
                packInfo.itemIds.length <= itemIds + 1,
                "pack contains an item that doesn't exist"
            );
            require(
                packInfo.itemIds.length == packInfo.itemAmounts.length,
                "item IDs and amounts must have the same length"
            );

            pack.priceUsd = packInfo.priceUsd;
            pack.itemIds = packInfo.itemIds;
            pack.itemAmounts = packInfo.itemAmounts;
            pack.paused = packInfo.paused;
        }
    }

    /// @dev Sets the transmute fee for transmuting a single item.
    /// @notice `fee` must be in Wei!
    /// @param fee The new transmute fee.
    function setTransmuteFee(uint256 fee) external onlyOwner {
        transmuteFee = fee;
    }

    /// @dev Sets the transmute fee for transmuting multiple items in a batch.
    /// @notice `fee` must be in Wei!
    /// @param fee The new transmute fee.
    function setTransmuteFeeBatch(uint256 fee) external onlyOwner {
        transmuteFeeBatch = fee;
    }

    ///-------------------------------------------------------------------------
    /// PLAYER FUNCTIONS ///////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Mints items using native currency (Ether) as payment.
    /// @param id The ID of the item to mint.
    /// @param amount The number of items to mint.
    function mint(uint256 id, uint256 amount) external payable nonReentrant {
        require(!pausedMint, "minting is paused for all items");
        require(!items[id].paused, "minting is paused for this item");
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            msg.value >= getItemsNativePrice(id, amount),
            "sent value not enough"
        );
        require(
            items[id].minted + amount <= items[id].totalSupply,
            "amount exceeds total supply"
        );
        require(msg.sender != address(0), "sender can't be null address");

        _mint(msg.sender, id, amount, "");
        items[id].minted += amount;

        emit Minted(msg.sender, id, amount, false);
    }

    /// @dev Checks if the specified items can be minted in the given amounts.
    /// @param itemIdsArray An array containing the IDs of the items to check.
    /// @param itemAmounts An array containing the amounts of items to check.
    /// @param amount The multiplier for the item amounts.
    function requireItemsMintable(
        uint256[] memory itemIdsArray,
        uint256[] memory itemAmounts,
        uint256 amount
    ) internal view {
        for (uint256 i = 0; i < itemIdsArray.length; ++i) {
            ItemInfo storage item = items[itemIdsArray[i]];
            require(
                item.minted + itemAmounts[i] * amount <= item.totalSupply,
                "amount exceeds total supply"
            );
        }
    }

    /// @dev Mints a pack of items using native currency as payment.
    /// @param packId The ID of the pack to mint.
    /// @param amount The number of packs to mint.
    function mintPack(
        uint256 packId,
        uint256 amount
    ) external payable nonReentrant {
        require(
            !pausedMint && !packs[packId].paused,
            "minting or pack is paused"
        );
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            msg.value >= getPacksNativePrice(packId, amount),
            "sent value not enough"
        );
        require(msg.sender != address(0), "sender can't be null address");

        PackInfo storage pack = packs[packId];

        requireItemsMintable(pack.itemIds, pack.itemAmounts, amount);

        uint256[] memory finalItemAmounts = new uint256[](
            pack.itemAmounts.length
        );

        for (uint256 i = 0; i < pack.itemIds.length; ++i) {
            ItemInfo storage item = items[pack.itemIds[i]];
            item.minted += pack.itemAmounts[i] * amount;
            finalItemAmounts[i] = pack.itemAmounts[i] * amount;
        }

        _mintBatch(msg.sender, pack.itemIds, finalItemAmounts, "");

        emit MintedPack(msg.sender, packId, amount);
    }

    /// @dev Performs a transmutation of items.
    /// The function transmutes the specified amounts of the item with the given ID into new items in the designated slots.
    /// After performing the transmutation, the function updates the transmuteFeeSum and emits a Transmuted event.
    /// @param id The ID of the item to transmute.
    /// @param amounts An array containing the amounts of items to transmute.
    /// @param slots An array containing the slots where the transmuted items will be placed.
    function mayneTransmute(
        uint256 id,
        uint256[] memory amounts,
        uint256[] memory slots
    ) external payable nonReentrant {
        require(pausedMayneTransmute == false, "mayne transmute paused");
        require(id <= itemIds, "item doesn't exist");
        require(amounts.length == slots.length, "arrays length mismatch");
        require(msg.sender != address(0), "sender can't be null address");
        require(msg.value >= transmuteFee, "sent value not enough");

        uint256 totalFee = transmuteFee;
        for (uint256 i = 0; i < amounts.length; ++i) {
            require(amounts[i] > 0, "amount can't be zero");
            require(
                items[id].minted + amounts[i] <= items[id].totalSupply,
                "amount exceeds total supply"
            );
        }

        transmuteFeeSum += totalFee;

        emit Transmuted(msg.sender, id, amounts, slots);
    }

    /// @dev Performs a batch transmutation of items.
    /// The function transmutes the specified amounts of items with the given IDs into new items in the designated slots.
    /// The transmutation process may involve additional checks or operations specific to each iteration.
    /// After performing the transmutation, the function updates the transmuteFeeSum and emits a TransmutedBatch event.
    /// @param ids An array containing the IDs of the items to transmute.
    /// @param amounts An array containing the amounts of items to transmute.
    /// @param slots An array containing the slots where the transmuted items will be placed.
    function mayneTransmuteBatch(
        uint256[] memory ids,
        uint256[] memory amounts,
        uint256[] memory slots
    ) external payable nonReentrant {
        require(pausedMayneTransmute == false, "mayne transmute paused");
        require(
            ids.length == amounts.length && ids.length == slots.length,
            "arrays length mismatch"
        );
        require(msg.sender != address(0), "sender can't be null address");

        uint256 totalFee = transmuteFeeBatch;
        require(msg.value >= totalFee, "sent value not enough");

        for (uint256 i = 0; i < ids.length; ++i) {
            require(
                ids[i] <= itemIds,
                "ids contains an item that doesn't exist"
            );
            require(amounts[i] > 0, "amount can't be zero");
            require(
                items[ids[i]].minted + amounts[i] <= items[ids[i]].totalSupply,
                "amount exceeds the total supply"
            );
        }

        transmuteFeeSum += totalFee;

        emit TransmutedBatch(msg.sender, ids, amounts, slots);
    }

    /// @dev Burns a specified amount of an item from the sender's account.
    /// The function burns the specified amount of the item with the given ID from the sender's account.
    /// The isTransmuting and isBridging flags indicate the purpose of the burn operation.
    /// After burning the item, the function emits a Burnt event.
    /// @param id The ID of the item to burn.
    /// @param amount The amount of the item to burn.
    /// @param isVirtualizing A flag indicating whether the burn is for virtualizing.
    /// @param isBridging A flag indicating whether the burn is for bridging.
    function burn(
        uint256 id,
        uint256 amount,
        bool isVirtualizing,
        bool isBridging
    ) external nonReentrant {
        require(pausedBurn == false, "burning paused");
        require(id <= itemIds, "item doesn't exist");
        require(
            balanceOf(msg.sender, id) >= amount,
            "not enough items to burn"
        );
        require(amount > 0, "amount can't be zero");

        _burn(msg.sender, id, amount);
        items[id].minted -= amount;

        emit Burnt(msg.sender, id, amount, isVirtualizing, isBridging);
    }

    /// @dev Burns a batch of items from the sender's account.
    /// The function burns the specified amounts of items with the given IDs from the sender's account.
    /// The isTransmuting and isBridging flags indicate the purpose of the burn operation.
    /// After burning the items, the function emits a BurntBatch event.
    /// @param ids An array containing the IDs of the items to burn.
    /// @param amounts An array containing the amounts of items to burn.
    /// @param isVirtualizing A flag indicating whether the burn is for virtualizing.
    /// @param isBridging A flag indicating whether the burn is for bridging.
    function burnBatch(
        uint256[] memory ids,
        uint256[] memory amounts,
        bool isVirtualizing,
        bool isBridging
    ) external nonReentrant {
        require(pausedBurn == false, "burning paused");
        require(
            ids.length <= itemIds + 1,
            "ids contain an item that doesn't exist"
        );
        require(
            ids.length == amounts.length,
            "ids and amounts must have the same length"
        );

        for (uint256 i = 0; i < amounts.length; ++i) {
            uint256 itemId = ids[i];
            uint256 amount = amounts[i];

            require(amount > 0, "amount can't be zero");
            require(
                balanceOf(msg.sender, itemId) >= amount,
                "account doesn't have enough items to burn"
            );

            items[itemId].minted -= amount;
        }

        _burnBatch(msg.sender, ids, amounts);

        emit BurntBatch(msg.sender, ids, amounts, isVirtualizing, isBridging);
    }

    ///-------------------------------------------------------------------------
    /// ADMIN FUNCTIONS ////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Function to add an address to the minter role.
    function addMinter(address minterAddress) external onlyOwner {
        minters[minterAddress] = true;
    }

    /// @dev Function to remove an address from the minter role.
    function removeMinter(address minterAddress) external onlyOwner {
        minters[minterAddress] = false;
    }

    /// @dev Adds new items to the contract.
    /// Each item is defined by its total supply and price in USD.
    /// The function adds the new items to the contract by assigning them unique IDs.
    /// The minted amount for each item is initialized to 0, and the paused flag is set to false.
    /// @param totalSupplies An array containing the total supplies of the new items.
    /// @param priceUsds An array containing the prices of the new items in USD.
    function addItems(
        uint256[] memory totalSupplies,
        uint256[] memory priceUsds,
        bool[] memory paused
    ) external onlyOwner {
        require(
            totalSupplies.length > 0 &&
                totalSupplies.length == priceUsds.length &&
                totalSupplies.length == paused.length,
            "invalid input arrays"
        );

        uint256 firstId = itemIds + 1;
        for (uint256 i = 0; i < totalSupplies.length; ++i) {
            uint256 itemId = firstId + i;
            itemIds++;
            ItemInfo storage item = items[itemId];
            item.minted = 0;
            item.totalSupply = totalSupplies[i];
            item.priceUsd = priceUsds[i];
            item.paused = paused[i];
        }
    }

    /// @dev Updates item information.
    /// @param ids The IDs of the items.
    /// @param totalSupplies The total supplies of the items.
    /// @param priceUsds The USD prices of the items in Wei.
    /// @param paused The pause status of the items.
    function updateItems(
        uint256[] memory ids,
        uint256[] memory totalSupplies,
        uint256[] memory priceUsds,
        bool[] memory paused
    ) external onlyOwner {
        require(
            ids.length > 0 &&
                ids.length == totalSupplies.length &&
                ids.length == priceUsds.length &&
                ids.length == paused.length,
            "invalid input arrays"
        );

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 itemId = ids[i];
            ItemInfo storage item = items[itemId];
            item.totalSupply = totalSupplies[i];
            item.priceUsd = priceUsds[i];
            item.paused = paused[i];
        }
    }

    /// @dev Mints a specified amount of an item and assigns it to a specified player.
    /// The item to be minted is specified by its ID.
    /// The player address indicates the recipient of the minted item.
    /// The function mints the specified amount of the item, assigns it to the player,
    /// and updates the minted amount of the item.
    /// @param id The ID of the item to be minted.
    /// @param amount The amount of the item to be minted.
    /// @param player The address to which the minted item will be assigned.
    /// @param isTransmuting A boolean indicating whether the minting is part of a transmutation process.
    function mintWithRole(
        uint256 id,
        uint256 amount,
        address player,
        bool isTransmuting
    ) external onlyWithRole {
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");

        ItemInfo storage item = items[id];
        require(
            item.minted + amount <= item.totalSupply,
            "amount exceeds total supply"
        );

        require(player != address(0), "player can't be null address");

        _mint(player, id, amount, "");
        item.minted += amount;

        emit Minted(player, id, amount, isTransmuting);
    }

    /// @dev Mints a batch of items and assigns them to a specified player.
    /// The items to be minted are specified by their IDs and corresponding amounts.
    /// The player address indicates the recipient of the minted items.
    /// The function mints the specified amounts of items, assigns them to the player,
    /// and updates the minted amounts of the items.
    /// @param ids The IDs of the items to be minted.
    /// @param amounts The corresponding amounts of the items to be minted.
    /// @param player The address to which the minted items will be assigned.
    /// @param isTransmuting A boolean indicating whether the minting is part of a transmutation process.
    function mintBatchWithRole(
        uint256[] memory ids,
        uint256[] memory amounts,
        address player,
        bool isTransmuting
    ) external onlyWithRole {
        require(
            ids.length == amounts.length,
            "ids and amounts must have the same length"
        );

        for (uint256 i = 0; i < ids.length; ++i) {
            require(
                ids[i] <= itemIds,
                "ids contain an item that doesn't exist"
            );

            ItemInfo storage item = items[ids[i]];
            require(amounts[i] > 0, "amount can't be zero");
            require(
                item.minted + amounts[i] <= item.totalSupply,
                "amount exceeds the total supply"
            );

            item.minted += amounts[i];
        }

        require(player != address(0), "player can't be null address");

        _mintBatch(player, ids, amounts, "");

        emit MintedBatch(player, ids, amounts, isTransmuting);
    }

    /// @dev Withdraws the contract's native currency balance to designated addresses.
    /// The designated addresses are as follows:
    /// - Founder 1: 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3
    /// - Founder 2: 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d
    /// - Dev: 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D
    /// The function transfers the appropriate amounts of native currency to the designated addresses.
    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "balance can't be zero");

        uint256 founderAmount = contractBalance.mul(4).div(10);
        uint256 devAmount = contractBalance.mul(2).div(10);

        address[] memory founders = new address[](2);
        founders[0] = 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3;
        founders[1] = 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d;
        address dev = 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D;

        for (uint256 i = 0; i < founders.length; ++i) {
            require(
                payable(founders[i]).send(founderAmount),
                "transfer to founder failed"
            );
        }

        require(payable(dev).send(devAmount), "transfer to dev failed");

        transmuteFeeSum = 0;
    }
}
