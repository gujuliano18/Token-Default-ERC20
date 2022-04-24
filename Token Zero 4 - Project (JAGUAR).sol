// SPDX-License-Identifier: MIT


pragma solidity ^0.8.13;


contract ERC20 {


      mapping(address => uint256 ) private _balances;
      mapping(address => mapping(address => uint256)) private _allowances;


      uint256 private _totalSupply;
      uint8 private _decimals;
      string private _symbol;
      string private _name;


      event Transfer(address indexed from, address indexed to, uint256 value);
      event Approval(address indexed owner, address indexed spender, uint256 value);

   constructor (){
     _name = "NAME_TOKEN";//Token name
     _symbol = "SSS";//Token symbol
     _decimals = 18;//Default decimals
     _totalSupply = 3600000000000000 * 10 ** 18;//Supply 36 trillions tokens 32 digits
     _balances[msg.sender] = _totalSupply;
     }


     /**
     * @dev Returns the name of the token.
     */
     function name() public view returns (string memory){
       return _name;
     }


     /**
     * @return the symbol of the token.
     */
     function symbol() public view returns (string memory){
       return _symbol;
     }


     /**
     * @return the number of decimals of the token.
     */
     function decimals() public view returns(uint8){
       return _decimals;
     }


     /**
     * @dev Returns the amount of tokens in existence.
     */
     function totalSupply() public view returns (uint256){
       return _totalSupply;
     }


     /**
     * @dev Returns the amount of tokens owned by `account`.
     */
     function balanceOf(address _owner) public view returns (uint256){
       return _balances[_owner];
     }


     /**
     * @dev Mint new tokens by `account`.
     */
     function mint(address account, uint256 amount) public virtual returns(bool){
       _mint(account, amount);
       return true;
     }


     /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
     function _transfer(address sender, address recipient, uint256 amount) internal {
         uint256 senderBalance = _balances[sender];
         require(senderBalance >= amount, "ERC20: transfer amount exeeds balance");

         unchecked{
             _balances[sender] = senderBalance - amount;
         }

         _balances[recipient] += amount;

         emit Transfer(sender, recipient, amount);
     }


     function transfer(address recipient, uint256 amount) public returns(bool){
         _transfer(msg.sender, recipient, amount);
       return true;
     }


     /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
     function transferFrom(address sender, address repicipient, uint256 amount) public returns(bool){
       uint256 currentAllowance = _allowances[sender][msg.sender];
       require(currentAllowance >= amount, "ERC20: tranfer amount exceeds allowance");

       _transfer(sender, repicipient, amount);
       _approve(sender, msg.sender, currentAllowance - amount);
       return true;
     }


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
     function approve(address spender, uint256 amount) public returns(bool){
       _approve(msg.sender, spender, amount);
       return true;
     }


     /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
     function _approve(address owner, address spender, uint256 amount) internal {
       _allowances[owner][spender] = amount;

       emit Approval(owner, spender, amount);
     }


     /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
     function allowance(address owner, address spender) public view returns (uint256){
       return _allowances[owner][spender];
     }


     /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
     function increaseAllowance(address spender, uint256 addedValue) public returns(bool){
       _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
       return true;
     }


     /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
       uint256 currentAllowance = _allowances[msg.sender][spender];
       require(currentAllowance >= subtractedValue, "ERC20: decreased allowance belo zero");

       unchecked{_approve(msg.sender, spender, currentAllowance - subtractedValue);}
       return true;
     }


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
     function _msgSender() internal view virtual returns (address){
       return msg.sender;
     }

     function _msgData() internal view virtual returns (bytes calldata){
       return msg.data;
     }


     /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
     function burn(uint256 amount) public virtual {
       _burn(_msgSender(), amount);
     }


     /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
     function burnFrom(address account, uint256 amount) public virtual {
       _spendAllowance(account, _msgSender(), amount);
       _burn(account, amount);
     }


     /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
     }


     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
     function _mint(address account, uint256 amount) internal virtual {
       require(account != address(0), "ERC20: mint to the zero address");
       _totalSupply += amount;
       _balances[account] += amount;
       emit Transfer(address(0), account, amount);
     }


     /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
     function _burn(address account, uint256 amount) internal virtual {
       require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
     }


     /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {

     }


     /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {

     }


}//FECHA CONTRATO
//Token padrão, simples com todas as funções básicas e obrigatórias com algumas opcionais.
//com mint, com burn.
