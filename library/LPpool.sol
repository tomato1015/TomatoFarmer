// var MyContract = artifacts.require("./MyContract.sol");


//var Token = artifacts.require("./02-Farmer/library/Token.sol");

//var LPPool = artifacts.require("./02-Farmer/TomatoFarmer/LPpool.sol");
//var UsdtPool = artifacts.require("./02-Farmer/TomatoFarmer/UsdtPool.sol");
var Pool = artifacts.require("./02-Farmer/TomatoFarmer/Pool.sol");

module.exports = function(deployer) {
         // 代币
      //deployer.deploy(Token,1000000,18,18,'TT','TT');
      //deployer.deploy(Token,8000000000000,6,6,'USDT','USDT');
      //deployer.deploy(Token,8000000000000,18,18,'HT','HT');
      //deployer.deploy(Token,8000000000000,18,18,'JST','JST');
      //deployer.deploy(Token,8000000000000,18,18,'SUN','SUN');
      //deployer.deploy(Token,8000000000000,6,6,'TTLP','TTLP');

          // 池子
          
          //USDT POOL
          //deployer.deploy(UsdtPool,'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t','TAQk2zz3wuRgZvPDFy4VPpzx8gXMEYofHF','TJSZcHTJUS9sh1STyyDDToUm6oaTUmhR6U','TQNJB1MFEkQLGGS6UeC6ac7BTV4k9g6Yy1',63000,1603702800,1607331600);
          
          //JST POOL
          deployer.deploy(Pool,'TCFLL5dx5ZJdKnWuesXxi1VPwjLVmWZZy9','TAQk2zz3wuRgZvPDFy4VPpzx8gXMEYofHF','TJSZcHTJUS9sh1STyyDDToUm6oaTUmhR6U','TQNJB1MFEkQLGGS6UeC6ac7BTV4k9g6Yy1',42000,1603702800,1607331600);
          
          //SUN POOL
          //deployer.deploy(Pool,'TKkeiboTkxXKJpbmVFbv4a8ov5rAfRDMf9','TAQk2zz3wuRgZvPDFy4VPpzx8gXMEYofHF','TJSZcHTJUS9sh1STyyDDToUm6oaTUmhR6U','TQNJB1MFEkQLGGS6UeC6ac7BTV4k9g6Yy1',21000,1603702800,1607331600);

          //HT pool
          //deployer.deploy(Pool,'TDyvndWuvX5xTBwHPYJi7J3Yq8pq8yh62h','TAQk2zz3wuRgZvPDFy4VPpzx8gXMEYofHF','TJSZcHTJUS9sh1STyyDDToUm6oaTUmhR6U','TQNJB1MFEkQLGGS6UeC6ac7BTV4k9g6Yy1',42000,1603702800,1607331600);

         
          //LP POOL
          //deployer.deploy(LPPool,'TC5wWjhtP49qSgwGtMt5qVbw2qsu3gBE2D','TAQk2zz3wuRgZvPDFy4VPpzx8gXMEYofHF',84000,1603702800,1607331600);


//deployer.deploy(Migrations);
};
