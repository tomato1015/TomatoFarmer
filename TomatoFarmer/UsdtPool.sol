pragma solidity ^0.5.0;

import "../library/SafeMath.sol";
import "../library/LPTokenWrapper.sol";


contract UsdtPool is LPTokenWrapper {
    using SafeERC20 for IERC20;
    IERC20 private yfi;                          

    uint256 private initreward;                  

    bool private flag = false;                    
    uint256 private totalRewards = 0;            
    uint256 private precision = 1e18;            

    uint256 private starttime;                  
    uint256 private stoptime;                   
    uint256 private rewardRate = 0;              
    uint256 private lastUpdateTime;              
    uint256 private rewardPerTokenStored;        

    address private deployer;                  
    address private feeAddressLow;                
    address private feeAddressHigh;                 


    mapping(address => uint256) private userRewardPerTokenPaid;
    mapping(address => uint256) private rewards;              
    mapping(address => uint256) private stakes;             


    event StartPool(uint256 initreward,uint256 starttime,uint256 stoptime);      
    event Staked(address indexed user, uint256 amount,uint256 feeAmount);      
    event Withdrawn(address indexed user, uint256 amount);    
    event RewardPaid(address indexed user, uint256 reward);   




    modifier updateReward(address account) {
   
        if(block.timestamp > starttime){
            rewardPerTokenStored = rewardPerToken();
            flag = true;
            lastUpdateTime = lastTimeRewardApplicable();
            if (account != address(0)) {
         
                rewards[account] = earned(account);
             
                userRewardPerTokenPaid[account] = rewardPerTokenStored;
            }
        }
        _;
    }


    constructor (address _y, address _yfi, address _feeAddressLow,address _feeAddressHigh,uint256 _initreward, uint256 _starttime, uint256 _stoptime) public {
        deployer = msg.sender;
        feeAddressLow = _feeAddressLow;
        feeAddressHigh = _feeAddressHigh;

        super.initialize(_y);
        yfi = IERC20(_yfi);
        starttime = _starttime;
        stoptime = _stoptime;
        initreward = _initreward * (precision);
        rewardRate = initreward.div(stoptime.sub(starttime));
        emit StartPool(initreward,starttime,stoptime);
    }


    function stake(uint256 amount) public updateReward(msg.sender) checkStop{
        require(amount > 0, "The number must be greater than 0");
        uint256 feeAmount = amount.mul(5).div(100);
        super.stake(amount,feeAmount);
        sendFee(feeAmount);
        stakes[msg.sender] = stakes[msg.sender].add(amount);
        emit Staked(msg.sender, amount, feeAmount);
    }


    function getReward() public updateReward(msg.sender) checkStart{
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            yfi.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
            totalRewards = totalRewards.add(reward);
        }
    }



    function exit() public updateReward (msg.sender){
        uint256 amount = stakes[msg.sender];
        require(amount > 0, "Cannot withdraw 0");
        uint256 feeAmount = amount.mul(5).div(100);
        super.withdraw(balanceOf(msg.sender),feeAmount);
        sendFee(feeAmount);
        stakes[msg.sender] = 0;
        if(block.timestamp > starttime){
            getReward();
        }
        emit Withdrawn(msg.sender, balanceOf(msg.sender));
    }


    function sendFee(uint256 amount) private {
        uint256 feeLow = amount.mul(2).div(10);
        uint256 feeHigh = amount.sub(feeLow);
        y.transfer(feeAddressLow, feeLow);
        y.transfer(feeAddressHigh, feeHigh);
    }


 
    function earned(address account) public view returns (uint256) {
        if(block.timestamp < starttime){
            return 0;
        }
        return
        balanceOf(account)
        .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
        .div(precision)
        .add(rewards[account]);
    }




    function lastTimeRewardApplicable() internal view returns (uint256) {
        return SafeMath.min(block.timestamp, stoptime);
    }


    function rewardPerToken() internal view returns (uint256) {
        if (totalSupply() == 0) {
            return rewardPerTokenStored;
        }
        uint256 lastTime = 0 ;
        if(flag){
            lastTime = lastUpdateTime;
        }else{
            lastTime = starttime;
        }

        return
        rewardPerTokenStored.add(
            lastTimeRewardApplicable()
            .sub(lastTime)
            .mul(rewardRate)
            .mul(precision)
            .div(totalSupply())
        );
    }

 
    modifier checkStart(){
        require(block.timestamp > starttime,"not start");
        _;
    }

  
    modifier checkStop() {
        require(block.timestamp < stoptime,"already stop");
        _;
    }




    function getPoolInfo() public view returns (uint256,uint256,uint256,uint256) {
        uint left = initreward.sub(totalRewards);
        if(left < 0){
            left = 0;
        }
        return (starttime,stoptime,totalSupply(),left);
    }


    function clearPot() public {
        if(msg.sender == deployer){
            yfi.safeTransfer(msg.sender, yfi.balanceOf(address(this)));
        }
    }

}